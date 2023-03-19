from rest_framework import serializers
from django.contrib.auth.models import User



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


