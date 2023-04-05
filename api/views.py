from rest_framework.views import APIView
from rest_framework.decorators import api_view, permission_classes, authentication_classes
from rest_framework.response import Response
from rest_framework.authtoken.models import Token
from rest_framework import status, serializers, generics
from rest_framework.permissions import IsAuthenticated

from django.http import Http404
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


class RankList(APIView):
    """
        List all ranks, or create a new rank.
    """
    authentication_classes = [BearerAuthentication]
    permission_classes = [IsAuthenticated]

    @swagger_auto_schema(responses={"200": RankSerializer(many=True)})
    def get(self, request):
        ranks = Rank.objects.all()
        serializer = RankSerializer(ranks)
        return Response(serializer.data)

    @swagger_auto_schema(request_body=RankSerializer(), responses={"200": RankSerializer(many=True)})
    def post(self, request):
        serializer = RankSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class RankDetail(APIView):
    """
        Retrieve, update or delete a rank instance.
    """

    # drf-yasg stuff
    manual_parameters = [
        openapi.Parameter(name="id", required=True, type="integer", in_=openapi.IN_PATH, description="instance id", ),
    ]

    def get_object(self, pk):
        try:
            return Rank.objects.get(id=pk)
        except Rank.DoesNotExist:
            raise Http404

    @swagger_auto_schema(responses={"200": RankSerializer()}, manual_parameters=manual_parameters)
    def get(self, request, id, format=None):
        """
            Retrieve a rank instance
        """
        rank = self.get_object(id)
        serializer = RankSerializer(rank)
        return Response(serializer.data)

    @swagger_auto_schema(request_body=RankSerializer(), responses={"200": RankSerializer()}, manual_parameters=manual_parameters)
    def put(self, request, id):
        """
            update a rank instance
        """
        rank = self.get_object(id)
        serializer = RankSerializer(rank, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    @swagger_auto_schema(responses={"204": None}, manual_parameters=manual_parameters)
    def delete(self, request, id):
        """
            delete a rank instance
        """
        rank = self.get_object(id)
        rank.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class PositionList(generics.ListCreateAPIView):
    """
        List all positions, or creates a new position. (written using generics: abstractions go brrrrrrrrr)
    """
    queryset = Position.objects.all()
    serializer_class = PositionSerializer
    authentication_classes = [BearerAuthentication]
    permission_classes = [IsAuthenticated]


class PositionDetail(generics.RetrieveUpdateDestroyAPIView):
    """
        Retrieve, update or delete a position instance.
    """
    queryset = Position.objects.all()
    serializer_class = PositionSerializer
    authentication_classes = [BearerAuthentication]
    permission_classes = [IsAuthenticated]


class UserList(generics.ListCreateAPIView):
    """
        List all Users
    """
    queryset = User.objects.all()
    serializer_class = UserSerializer
    authentication_classes = [BearerAuthentication]
    permission_classes = [IsAuthenticated]


class UserDetail(generics.RetrieveUpdateDestroyAPIView):
    """
        Retrieve, update or delete a User instance.
    """
    queryset = User.objects.all()
    serializer_class = UserSerializer
    authentication_classes = [BearerAuthentication]
    permission_classes = [IsAuthenticated]