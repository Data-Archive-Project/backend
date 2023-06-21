from rest_framework import serializers
from .models import *


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

    def to_representation(self, instance):
        representation = super().to_representation(instance)
        representation["num_of_docs"] = instance.documents.count()
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

    def create(self, validated_data):
        read_access = validated_data.pop("read_access", [])
        update_access = validated_data.pop("update_access", [])
        position_access = validated_data.pop("position_access", [])
        approver = validated_data.pop("approver", None)

        # create document instance
        document = Document.objects.create(**validated_data)

        # add read access
        document.read_access.set(read_access)

        # add update access
        document.update_access.set(update_access)

        # add position access
        document.position_access.set(position_access)

        # add approver
        if approver:
            Approval.objects.create(document=document, approver=approver, requester=document.uploaded_by)

        return document
