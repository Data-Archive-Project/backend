from django.contrib.auth.models import User
from django.contrib.contenttypes.models import ContentType
from django.utils import timezone
from .models import AuditLog


class AuditLogMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        response = self.get_response(request)

        # Check if user is authenticated and if request method is not GET or OPTIONS
        if request.user.is_authenticated and request.method not in ('GET', 'OPTIONS'):
            user = request.user
            content_type = 'ContentType.objects.get_for_model(request)'
            object_id = response.id
            content_object = response
            action = request.method
            timestamp = timezone.now()
            changes = ""

            # Save the audit log
            AuditLog.objects.create(
                user=user,
                content_type=content_type,
                object_id=object_id,
                content_object=content_object,
                action=action,
                timestamp=timestamp,
                changes=changes,
            )

        return response