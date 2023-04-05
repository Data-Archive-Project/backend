from django.db import models
from django.contrib.auth.models import User
from django.core.validators import RegexValidator


class Rank(models.Model):
    name = models.CharField(max_length=100)

    def __str__(self):
        return self.name


class Position(models.Model):
    name = models.CharField(max_length=100)

    def __str__(self):
        return self.name


class DocumentCategory(models.Model):
    name = models.CharField(max_length=100)
    description = models.CharField(max_length=300)

    def __str__(self):
        return self.name


class Document(models.Model):
    FILE_CHOICES = [
        ("image", "Image"),
        ("word", "Word"),
        ("excel", "Excel"),
        ("pdf", "PDF")
    ]
    title = models.CharField(max_length=255)
    description = models.TextField()
    file_type = models.CharField(choices=FILE_CHOICES, max_length=255)
    file = models.FileField()
    source = models.CharField(max_length=255)
    category = models.ForeignKey(DocumentCategory, on_delete=models.CASCADE, related_name="documents")
    created_at = models.DateTimeField(auto_now_add=True)
    uploaded_by = models.ForeignKey(User, on_delete=models.CASCADE)
    allowed_access = models.ManyToManyField(User, related_name='documents', through='DocumentAccess')
    approved = models.BooleanField(default=False)

    def __str__(self):
        return self.title


class DocumentAccess(models.Model):
    ACCESS_CHOICES = [
        ('read', 'Read'),
        ('update', 'Update'),
    ]
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    document = models.ForeignKey(Document, on_delete=models.CASCADE)
    access = models.CharField(max_length=10, choices=ACCESS_CHOICES)

    def __str__(self):
        return f"{self.document} ({self.access})"

    class Meta:
        unique_together = ('document', 'user')


class UserProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name="profile")
    rank = models.ForeignKey(Rank, on_delete=models.CASCADE)
    position = models.ForeignKey(Position, on_delete=models.CASCADE)
    phone_regex = RegexValidator(regex=r'^\+?1?\d{9,15}$', message="Format: '+999999999'. Up to 15 digits allowed.")
    phone = models.CharField(max_length=17, validators=[phone_regex], blank=True)

    def __str__(self):
        return self.user.username


