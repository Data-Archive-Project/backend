from django.shortcuts import render
from rest_framework.views import APIView
from drf_yasg import openapi
from rest_framework.response import Response
from django.views.decorators.csrf import csrf_exempt
from rest_framework.decorators import api_view
from .models import *
from django.contrib.auth import login, authenticate
from django.core.exceptions import ObjectDoesNotExist
from rest_framework.authtoken.models import Token
from rest_framework import status, serializers
from .serializers import *
from django.contrib.auth.models import User
from rest_framework.decorators import permission_classes, authentication_classes
from rest_framework.permissions import IsAuthenticated
from .utils import BearerAuthentication
from drf_yasg.utils import swagger_auto_schema

@api_view(['POST'])
@swagger_auto_schema(request_body=UserSerializer)
def login(request):
    """
        Returns an Authentication Token given valid user email and password.
    """

    # get data from request body
    request_data = request.data
    email = request_data["email"]
    password = request_data["password"]
    is_admin = True if request_data["is_admin"] == "true" else False

    # find user using email
    try:
        user = User.objects.get(email=email)
    except ObjectDoesNotExist:
        return Response(data={"login": "Invalid Email"}, status=status.HTTP_401_UNAUTHORIZED,)
    
    # authenticate User
    user = authenticate(username=user.username, password=password)

    # return user's token
    if user is not None and user.is_staff == is_admin:
        token, created = Token.objects.get_or_create(user=user)
        return Response(data={
            'token': token.key,
            'user_id': user.pk,
            'email': user.email
        }, status=status.HTTP_200_OK)
        
    else:
        return Response(data={"login": "Invalid Password or Role"}, status=status.HTTP_401_UNAUTHORIZED,)


@api_view(['GET'])
@authentication_classes([BearerAuthentication])
# @permission_classes((IsAuthenticated, ))
@swagger_auto_schema(request_body=UserSerializer)
def get_user(request, id: int):
    """
        Returns the User Model given the ID
    """
    try:
        user = User.objects.get(id=id)
        print(request.user)
    except ObjectDoesNotExist:
        return Response(data={'error_message': 'User does not exist'}, status=status.HTTP_404_NOT_FOUND)
    
    serializer = UserSerializer(user)
    return Response(serializer.data, status=status.HTTP_200_OK)

# @api_view(["GET"])
# @swagger_auto_schema(request_body=NoteSerializer)
# def notes(request):
#     """returns a list of notes"""
#     note = {"id": 3, "text": "hello worl"}
#     serializer = NoteSerializer(note)
   
#     return Response(serializer.data, status=status.HTTP_200_OK)


# class Notes(APIView):
#     response_schema_dict = {
#         "200": openapi.Response(
#             description="custom 200 description",
#             examples={
#                 "application/json": {
#                     "200_key1": "200_value_1",
#                     "200_key2": "200_value_2",
#                 }
#             }
#         ),
#         "205": openapi.Response(
#             description="custom 205 description",
#             examples={
#                 "application/json": {
#                     "205_key1": "205_value_1",
#                     "205_key2": "205_value_2",
#                 }
#             }
#         ),
#     }
#     id_param = openapi.Parameter('num', openapi.IN_QUERY, description="test manual param", type=openapi.TYPE_BOOLEAN)

#     @swagger_auto_schema(
#         responses = response_schema_dict, manual_parameters=[id_param])
#     def get(self, request, id=None):
#         """returns a list of notes"""
#         note = {"id": 3, "text": "hello world"}
#         serializer = NoteSerializer(note)
   
#         return Response(serializer.data, status=status.HTTP_200_OK)



class UserList:
    pass


class UserDetail:
    pass

