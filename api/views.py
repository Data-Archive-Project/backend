from django.shortcuts import render
from rest_framework.views import APIView
from django.http import HttpResponse, JsonResponse
from django.views.decorators.csrf import csrf_exempt
from rest_framework.decorators import api_view
from .models import *
from django.contrib.auth import login, authenticate
from django.core.exceptions import ObjectDoesNotExist
from rest_framework.authtoken.models import Token


@api_view(['POST'])
def login(request):
    """
        Performs Authentication using tokens
    """

    # get data from request body
    request_data = request.data
    email = request_data["email"]
    password = request_data["password"]

    # find user
    try:
        user = User.objects.get(email=email)
    except ObjectDoesNotExist:
        return JsonResponse(data={"login": "Invalid Email"})
    
    # authenticate User
    user = authenticate(username=user.username, password=password)

    if user is not None:
        token, created = Token.objects.get_or_create(user=user)
        return JsonResponse({
            'token': token.key,
            'user_id': user.pk,
            'email': user.email
        })
        
    else:
        return JsonResponse(data={"login": "Invalid Password"})

