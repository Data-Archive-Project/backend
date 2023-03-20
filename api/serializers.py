from rest_framework import serializers
from .models import *


class LoginSerializer(serializers.Serializer):
    """
      To handle data auth credentials
    """
    email = serializers.EmailField()
    password = serializers.CharField()
    is_admin = serializers.BooleanField()


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'first_name', 'last_name', 'email', 'username']


class UserProfileSerializer(serializers.ModelSerializer):
    user = UserSerializer()

    class Meta:
        model = UserProfile
        fields = ['user', 'rank', 'position', 'phone']

    def create(self, validated_data):
        user_data = validated_data.pop("user")
        user = User.objects.create(**user_data)
        user_profile = UserProfile.objects.create(user=user, **validated_data)
        return user_profile


# class DocumentCategorySerializer(serializers.ModelSerializer):
#     class Meta:
#         model = DocumentCategory
#         fields = ["name", 'description']