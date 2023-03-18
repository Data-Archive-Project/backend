from django.urls import path
from .views import *

urlpatterns = [
    path("login/", login, name="login"),
    path("users/<int:id>", get_user, name="user"),
    path("notes/<int:id>", Notes.as_view(), name="notes")
]