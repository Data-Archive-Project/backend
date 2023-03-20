from rest_framework.views import APIView
from rest_framework.decorators import api_view, permission_classes, authentication_classes
from rest_framework.response import Response
from rest_framework.authtoken.models import Token
from rest_framework import status, serializers
from rest_framework.permissions import IsAuthenticated

from django.contrib.auth import login, authenticate
from django.core.exceptions import ObjectDoesNotExist
from django.contrib.auth.models import User

from drf_yasg import openapi
from drf_yasg.utils import swagger_auto_schema

from .utils import BearerAuthentication
from .serializers import *
from .models import *


class Login(APIView):
    response_schema_dict = {
            "201": openapi.Response(
                description="",
                examples={
                    "application/json": {
                        'token': "usertokenstring",
                        'user_id': "integer",
                    }
                }
            )
    }

    @swagger_auto_schema(request_body=LoginSerializer, responses=response_schema_dict)
    def post(self, request):
        """
            Returns an Authentication Bearer Token given valid user email and password.
        """

        # get data from request body
        serializer = LoginSerializer(data=request.data)

        if serializer.is_valid():

            # find user using email
            try:
                user = User.objects.get(email=serializer.data['email'])
            except ObjectDoesNotExist:
                return Response(data={"login": "Invalid Email"}, status=status.HTTP_401_UNAUTHORIZED,)
            
            # authenticate User
            user = authenticate(username=user.username, password=serializer.data['password'])

            # authenticate role and return user's token
            if user is not None and user.is_staff == serializer.data['is_admin']:
                token, created = Token.objects.get_or_create(user=user)
                return Response(data={
                    'token': token.key,
                    'user_id': user.pk,
                }, status=status.HTTP_200_OK)
                
            else:
                return Response(data={"login": "Invalid Password or Role"}, status=status.HTTP_401_UNAUTHORIZED,)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
@authentication_classes([BearerAuthentication])
# @permission_classes((IsAuthenticated, ))
@swagger_auto_schema()
def get_user(request, id: int):
    """
        Returns the User Model given the ID
    """
    try:
        user = User.objects.get(id=id)
        print(request.user)
    except ObjectDoesNotExist:
        return Response(data={'error_message': 'User does not exist'}, status=status.HTTP_404_NOT_FOUND)
    
    serializer = UserProfileSerializer(user)
    return Response(serializer.data, status=status.HTTP_200_OK)


class UserProfileList(APIView):
    """
    List all UserProfiles, or create a new UserProfile.
    """
    authentication_classes = [BearerAuthentication]
    permission_classes = [IsAuthenticated]

    @swagger_auto_schema(responses={"200": UserProfileSerializer(many=True)})
    def get(self, request):
        user_profiles = UserProfile.objects.all()
        serializer = UserProfileSerializer(user_profiles, many=True)
        return Response(serializer.data)

    def post(self, request):
        """ Creates a new user and userprofile"""
        serializer = UserProfileSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
