from django.db import IntegrityError
from django.db.models import Q
from rest_framework import serializers
from .models import *
from .email import send_notification_email


class LoginSerializer(serializers.Serializer):
    """
      To handle data auth credentials
    """
    staff_id = serializers.IntegerField()
    password = serializers.CharField()
    is_admin = serializers.BooleanField()


class RankSerializer(serializers.ModelSerializer):
    class Meta:
        model = Rank
        fields = ["id", "name"]


class PositionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Position
        fields = ["id", "name"]


class UserProfileSerializer(serializers.ModelSerializer):

    class Meta:
        model = Profile
        fields = ['staff_id', 'rank', 'position', 'title', 'gender', 'phone', 'is_admin']


class UserSerializer(serializers.ModelSerializer):
    password = serializers.CharField(max_length=17, write_only=True)
    profile = UserProfileSerializer()

    class Meta:
        model = User
        # depth = 1
        fields = ['id', 'first_name', 'last_name', 'email', 'username', "password", "profile"]

    def create(self, validated_data):
        userprofile_data = validated_data.pop("profile")
        password = validated_data.pop("password")

        # create user and set password
        user = User(**validated_data)
        user.set_password(password)
        user.save()

        # create a user profile for the new user
        Profile.objects.create(user=user, **userprofile_data)

        return user

    def update(self, instance, validated_data):
        profile_data = validated_data.pop("profile", {})
        password = validated_data.pop("password", None)
        print(password)
        # rank_data = validated_data.pop("rank", {})
        # position_data = validated_data.pop("position", {})

        # Update Profile instance
        profile = instance.profile
        for attr, value in profile_data.items():
            setattr(profile, attr, value)
        profile.save()

        # # Update Rank instance
        # if rank_data:
        #     rank_instance = instance.rank
        #     for attr, value in rank_data.items():
        #         setattr(rank_instance, attr, value)
        #     rank_instance.save()
        #
        # # Update Position instance
        # if position_data:
        #     position_instance = instance.position
        #     for attr, value in position_data.items():
        #         setattr(position_instance, attr, value)
        #     position_instance.save()

        # Update User instance
        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        instance.save()

        if password:
            instance.set_password(password)

        instance.save()
        return instance


class CategorySerializer(serializers.ModelSerializer):
    num_of_docs = serializers.IntegerField(default=0, read_only=True)

    class Meta:
        model = Category
        fields = ['id', 'tag', 'description', 'num_of_docs']

    def get_num_of_docs(self, instance):
        user = self.context['request'].user  # Access the current user
        if user.profile.is_admin:
            return instance.documents.count()
        # filter documents by user read access, update access and position access
        filtered = instance.documents.filter(Q(read_access=user) | Q(update_access=user) | Q(position_access=user.profile.position))
        return filtered.distinct().count()

    def to_representation(self, instance):
        representation = super().to_representation(instance)
        representation["num_of_docs"] = self.get_num_of_docs(instance)
        return representation


class DocumentSerializer(serializers.ModelSerializer):
    file = serializers.FileField(read_only=True)
    uploaded_by = serializers.PrimaryKeyRelatedField(queryset=User.objects.all())
    read_access = serializers.PrimaryKeyRelatedField(queryset=User.objects.all(), many=True, required=False)
    update_access = serializers.PrimaryKeyRelatedField(queryset=User.objects.all(), many=True, required=False)
    position_access = serializers.PrimaryKeyRelatedField(queryset=Position.objects.all(), many=True, required=False)
    approver = serializers.PrimaryKeyRelatedField(queryset=Position.objects.all(), write_only=True, required=False)

    class Meta:
        model = Document
        fields = ['id', 'title', 'description', 'source', 'category', 'file_type', 'file', 'uploaded_by', "read_access", "update_access", "position_access", 'approver', 'date_received', 'created_at']

    def to_representation(self, instance):
        representation = super().to_representation(instance)

        # add something to track if document approval
        status = None
        if instance.approvals.all():
            approval = instance.approvals.first()
            status = approval.status

        # add document versions
        versions = instance.versions.all()
        representation["versions"] = VersionSerializer(versions, many=True).data

        representation["approval_status"] = status
        return representation

    def create(self, validated_data):
        read_access = validated_data.pop("read_access", [])
        update_access = validated_data.pop("update_access", [])
        position_access = validated_data.pop("position_access", [])
        approver = validated_data.pop("approver", None)

        # create document instance
        document = Document.objects.create(**validated_data)

        # create a document version
        version = Version.objects.create(document=document, version_number=1, changes="Initial Upload", changed_by=document.uploaded_by)

        # add approver
        if approver:
            Approval.objects.create(document=document, approver=approver, requester=document.uploaded_by)
            position_access.append(approver)
            message = f"Document Approval Request: '{document.title}'"
            Notification.objects.create(receiver=approver.profile.user, message=message, document=document)
            # send email to approver
            send_notification_email([approver.profile.user.email], "Document Approval Request", document.title, document.description, document.uploaded_by.first_name,
                                    document.uploaded_by.last_name)

        # # automatically add the uploaded_by user to the read_access list
        # read_access.append(document.uploaded_by)
        # update_access.append(document.uploaded_by)

        # add read access
        document.read_access.set(read_access)

        # add update access
        document.update_access.set(update_access)

        # add position access
        document.position_access.set(position_access)

        # notifications
        if read_access:
            # Create notifications for read access users
            for user in read_access:
                message = f"You have been granted read access to the document '{document.title}'."
                Notification.objects.create(receiver=user, message=message, document=document)

        if update_access:
            # Create notifications for update access users
            for user in update_access:
                message = f"You have been granted update access to the document '{document.title}'."
                Notification.objects.create(receiver=user, message=message, document=document)

        if position_access:
            # Create notifications for position access users
            for position in position_access:
                message = f"You have been granted access to the document '{document.title}'."
                Notification.objects.create(receiver=position.profile.user, message=message, document=document)

        # combine all access users and send email
        position_users = [position.profile.user for position in position_access]
        all_access_users = read_access + update_access + position_users
        all_access_users = list(set(all_access_users))
        all_emails = [user.email for user in all_access_users]
        send_notification_email(all_emails, "New Document Access",  document.title, document.description, document.uploaded_by.first_name, document.uploaded_by.last_name)

        return document

    def update(self, instance, validated_data):
        read_access = validated_data.pop("read_access", [])
        update_access = validated_data.pop("update_access", [])
        position_access = validated_data.pop("position_access", [])
        approver = validated_data.pop("approver", None)

        # update document instance
        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        instance.save()

        # add approver
        if approver:
            Approval.objects.create(document=instance, approver=approver, requester=instance.uploaded_by)
            position_access.append(approver)

        # add read access
        instance.read_access.set(read_access)

        # add update access
        instance.update_access.set(update_access)

        # add position access
        instance.position_access.set(position_access)

        # notifications
        if read_access:
            # Create notifications for read access users
            for user in read_access:
                message = f"You have been granted read access to the document '{instance.title}'."
                try:
                    Notification.objects.create(receiver=user, message=message, document=instance)
                except IntegrityError:
                    continue

        if update_access:
            # Create notifications for update access users
            for user in update_access:
                message = f"You have been granted update access to the document '{instance.title}'."
                try:
                    Notification.objects.create(receiver=user, message=message, document=instance)
                except IntegrityError:
                    continue

        if position_access:
            # Create notifications for position access users
            for position in position_access:
                message = f"You have been granted access to the document '{instance.title}'."
                try:
                    Notification.objects.create(receiver=position.profile.user, message=message, document=instance)
                except IntegrityError:
                    continue

        return instance


class ApprovalSerializer(serializers.ModelSerializer):

    class Meta:
        model = Approval
        fields = ['id', 'document', 'requester', 'approver', 'notes', 'status', 'created_at']


class CommentSerializer(serializers.ModelSerializer):

    class Meta:
        model = Comment
        fields = ["id", "document", "author", "text", "created_at"]


class NotificationSerializer(serializers.ModelSerializer):

    class Meta:
        model = Notification
        fields = "__all__"


class EmailSerializer(serializers.Serializer):
    subject = serializers.CharField()
    message = serializers.CharField()
    recipients = serializers.ListSerializer(child=serializers.EmailField())
    document_id = serializers.PrimaryKeyRelatedField(queryset=Document.objects.all(), required=False)


class VersionSerializer(serializers.ModelSerializer):

    class Meta:
        model = Version
        fields = ["document", "version_number", "changes", "changed_by", "created_at"]