from rest_framework import serializers
from django.contrib.auth.models import User



class LoginSerializer(serializers.Serializer):
	email = serializers.EmailField()
	password = serializers.CharField()
	is_admin = serializers.BooleanField()


class UserSerializer(serializers.ModelSerializer):
  class Meta:
    model = User
    fields = ['id', 'username','email','first_name','last_name']


class NoteSerializer(serializers.Serializer):
  id = serializers.IntegerField()
  text = serializers.CharField()
