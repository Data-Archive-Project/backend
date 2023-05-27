from django.contrib import admin
from .models import *

class RankAdmin(admin.ModelAdmin):
    list_display = ['id', 'name']


class PositionAdmin(admin.ModelAdmin):
    list_display = ['id', 'name']


class UserProfileAdmin(admin.ModelAdmin):
    list_display = ['id', 'user', 'rank', 'position', 'phone']


class DocumentCategoryAdmin(admin.ModelAdmin):
    list_display = ['pk', 'name',]


class DocumentAdmin(admin.ModelAdmin):
    list_display = ['id', 'title', 'file_type', 'source', 'status']


admin.site.register(Rank, RankAdmin)
admin.site.register(Position, PositionAdmin)
admin.site.register(UserProfile, UserProfileAdmin)
admin.site.register(DocumentCategory, DocumentCategoryAdmin)
admin.site.register(Document, DocumentAdmin)
# admin.site.register()
