from django.urls import path
from .views import *

urlpatterns = [
    path("login/", Login.as_view(), name="login"),

    path("users/", UserProfileList.as_view(), name="users"),
    path("users/<int:id>/", get_user, name="user"),
]