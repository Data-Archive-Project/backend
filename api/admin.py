from django.contrib import admin
from .models import *

class RankAdmin(admin.ModelAdmin):
    list_display = ['id', 'name']


class PositionAdmin(admin.ModelAdmin):
    list_display = ['id', 'name']


class UserProfileAdmin(admin.ModelAdmin):
    list_display = ['user', 'rank', 'position', 'phone']


admin.site.register(Rank, RankAdmin)
admin.site.register(Position, PositionAdmin)
admin.site.register(UserProfile, UserProfileAdmin)