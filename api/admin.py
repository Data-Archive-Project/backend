from django.contrib import admin
from .models import *


class RankAdmin(admin.ModelAdmin):
    list_display = ['id', 'name']


class PositionAdmin(admin.ModelAdmin):
    list_display = ['id', 'name']


class ProfileAdmin(admin.ModelAdmin):
    list_display = ['id', 'user', 'rank', 'position', 'phone', 'is_admin']


class CategoryAdmin(admin.ModelAdmin):
    list_display = ['pk', 'tag',]


class DocumentAdmin(admin.ModelAdmin):
    list_display = ['id', 'title', 'file_type', 'source', 'status']
    filter_horizontal = ('read_access', 'update_access')


class CommentAdmin(admin.ModelAdmin):
    list_display = ['id', 'document', 'author', 'text', 'created_at']


admin.site.register(Rank, RankAdmin)
admin.site.register(Position, PositionAdmin)
admin.site.register(Profile, ProfileAdmin)
admin.site.register(Category, CategoryAdmin)
admin.site.register(Document, DocumentAdmin)
# admin.site.register(Permission, PermissionAdmin)
admin.site.register(Comment, CommentAdmin)
# admin.site.register()
