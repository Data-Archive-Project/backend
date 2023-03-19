from rest_framework import serializers
from .models import *


class LoginSerializer(serializers.Serializer):
  """
    To handle data auth credentials
  """
	email = serializers.EmailField()
	password = serializers.CharField()
	is_admin = serializers.BooleanField()


class UserProfileSerializer(serializers.ModelSerializer):
  class Meta:
    model = UserProfile
    fields = ['user', 'rank', 'position', 'phone']

  

class DocumentCategorySerializer(serializers.ModelSerializer):
  class Meta:
    model = DocumentCategory
    fields = ["name", 'decription']


