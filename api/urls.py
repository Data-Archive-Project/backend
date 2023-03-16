from django.urls import path
from .views import login, get_user

urlpatterns = [
    path("login/", login),
    path("users/<int:id>", get_user)
]