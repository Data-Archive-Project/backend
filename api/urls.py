from django.urls import path
from .views import *

app_name = "api"
urlpatterns = [
    path("login/", Login.as_view(), name="login"),

    path("users/", UserList.as_view(), name="users"),
    path("users/<int:pk>/", UserDetail.as_view(), name="user"),

    path("ranks/", RankList.as_view(), name='ranks'),
    path("ranks/<int:id>/", RankDetail.as_view(), name="rank"),

    path("positions/", PositionList.as_view(), name='positions'),
    path("positions/<int:pk>/", PositionDetail.as_view(), name="position"),

    path("categories/", CategoryList.as_view(), name="categories"),
    path("categories/<int:id>/", CategoryDetail.as_view(), name="category"),

    path("documents/", DocumentList.as_view(), name="documents"),
    path("documents/<int:id>/", DocumentDetail.as_view(), name="document"),

    path("approvals/", ApprovalList.as_view(), name="approvals"),
    path("approval/<int:id>", ApprovalDetail.as_view(), name="approval"),

    path("comments/", CommentList.as_view(), name="comments"),
    # path("comments/<int:id>", CommentDetail.as_view(), name="comment"),

    path("notifications/", NotificationList.as_view(), name="notifications"),
    path("notifications/<int:id>", NotificationDetail.as_view(), name="notification"),

    path('files/<path:file_path>/', serve_file, name='serve_file'),
]