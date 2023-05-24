from rest_framework import serializers
from .models import *


class LoginSerializer(serializers.Serializer):
    """
      To handle data auth credentials
    """
    email = serializers.EmailField()
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
        model = UserProfile
        fields = ['rank', 'position', 'phone']


class UserSerializer(serializers.ModelSerializer):
    password = serializers.CharField(max_length=17, write_only=True)
    profile = UserProfileSerializer()

    class Meta:
        model = User
        fields = ['id', 'first_name', 'last_name', 'email', 'username', "password", "profile"]

    def create(self, validated_data):
        userprofile_data = validated_data.pop("profile")
        password = validated_data.pop("password")

        # create user and set password
        user = User(**validated_data)
        user.set_password(password)
        user.save()

        # create a user profile for the new user
        UserProfile.objects.create(user=user, **userprofile_data)

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


class DocumentCategorySerializer(serializers.ModelSerializer):
    num_of_docs = serializers.IntegerField(default=0, read_only=True)

    class Meta:
        model = DocumentCategory
        fields = ['id', 'name', 'description', 'num_of_docs']

    def to_representation(self, instance):
        representation = super().to_representation(instance)
        representation["num_of_docs"] = instance.documents.count()
        return representation


class DocumentSerializer(serializers.ModelSerializer):
    file = serializers.FileField(read_only=True)
    # created_at = serializers.DateTimeField(read_only=True)

    class Meta:
        model = Document
        fields = ['title', 'description', 'file_type', 'source', 'file', 'category', 'created_at', 'uploaded_by', "status"]