from django.urls import path
from .views import *

urlpatterns = [
    path("login/", Login.as_view(), name="login"),

    path("users/", UserProfileList.as_view(), name="users"),
    path("users/<int:pk>/", UserProfileDetail.as_view(), name="user"),

    path("ranks/", RankList.as_view(), name='ranks'),
    path("ranks/<int:id>/", RankDetail.as_view(), name="rank"),

    path("positions/", PositionList.as_view(), name='positions'),
    path("positions/<int:pk>/", PositionDetail.as_view(), name="position")
]