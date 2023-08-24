from django.db import models
from django.utils import timezone
from django.contrib.auth.models import User
from django.core.validators import RegexValidator
from django.contrib.contenttypes.fields import GenericForeignKey
from django.contrib.contenttypes.models import ContentType
from django.core.validators import MaxValueValidator, MinValueValidator


class Rank(models.Model):
    name = models.CharField(max_length=100, unique=True)

    def __str__(self):
        return self.name


class Position(models.Model):
    name = models.CharField(max_length=100, unique=True)

    def __str__(self):
        return self.name


class Category(models.Model):
    tag = models.CharField(max_length=100, unique=True)
    description = models.CharField(max_length=300)

    def __str__(self):
        return self.tag


class Document(models.Model):
    FILE_CHOICES = [
        ("image", "Image"),
        ("word", "Word"),
        ("excel", "Excel"),
        ("pdf", "PDF")
    ]
    title = models.CharField(max_length=255)
    description = models.TextField(blank=True, default="")
    file_type = models.CharField(choices=FILE_CHOICES, max_length=255)
    file = models.FileField(upload_to="documents")
    source = models.CharField(max_length=255)
    category = models.ForeignKey(Category, on_delete=models.PROTECT, related_name="documents", blank=True)
    uploaded_by = models.ForeignKey(User, on_delete=models.PROTECT)
    read_access = models.ManyToManyField(User, related_name='access_documents', blank=True)
    update_access = models.ManyToManyField(User, related_name='update_documents', blank=True)
    position_access = models.ManyToManyField(Position, related_name="position_documents", blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    last_updated = models.DateTimeField(auto_now=True)
    date_received = models.DateTimeField(blank=True, null=True, default=timezone.now)

    def __str__(self):
        return self.title

    class Meta:
        ordering = ['-created_at']


class Profile(models.Model):
    GENDER_CHOICES = [
        ("female", "female"),
        ("male", "male")
    ]
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name="profile")
    staff_id = models.IntegerField(unique=True, validators=[MinValueValidator(10000000), MaxValueValidator(99999999)])
    title = models.CharField(max_length=20, blank=True)
    gender = models.CharField(max_length=25, choices=GENDER_CHOICES, blank=True)
    is_admin = models.BooleanField(default=False)
    rank = models.ForeignKey(Rank, on_delete=models.PROTECT)
    position = models.OneToOneField(Position, on_delete=models.PROTECT, blank=True, null=True, related_name="profile")
    phone_regex = RegexValidator(regex=r'^\+?1?\d{9,15}$', message="Format: '+999999999'. Up to 15 digits allowed.")
    phone = models.CharField(max_length=17, validators=[phone_regex], blank=True)

    def __str__(self):
        return self.user.username


class Comment(models.Model):
    document = models.ForeignKey(Document, related_name='comments', on_delete=models.CASCADE)
    author = models.ForeignKey(User, on_delete=models.CASCADE)
    text = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Comment: {self.text[:10]}..."


class Notification(models.Model):
    receiver = models.ForeignKey(User, on_delete=models.CASCADE)
    message = models.TextField(max_length=300)
    is_read = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    document = models.ForeignKey('Document', on_delete=models.CASCADE, null=True, blank=True)

    def __str__(self):
        return f"{self.message[:10]}"


class AuditLog(models.Model):
    user = models.ForeignKey(User, on_delete=models.SET_NULL, null=True)
    content_type = models.ForeignKey(ContentType, on_delete=models.CASCADE)
    object_id = models.PositiveIntegerField()
    content_object = GenericForeignKey('content_type', 'object_id')
    action = models.CharField(max_length=50)
    timestamp = models.DateTimeField(auto_now_add=True)
    changes = models.TextField()

    def __str__(self):
        return f"{self.action} on {self.content_object} at {self.timestamp}"
    

class Version(models.Model):
    document = models.ForeignKey(Document, on_delete=models.CASCADE, related_name='versions')
    version_number = models.PositiveIntegerField()
    file = models.FileField(upload_to="document_versions")
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.document} - Version {self.version_number}"


class Approval(models.Model):
    STATUS_CHOICES = [
        ('pending', 'Pending'),
        ('accepted', 'Accepted'),
        ('rejected', 'Rejected'),
    ]
    document = models.ForeignKey(Document, on_delete=models.CASCADE, related_name='approvals')
    requester = models.ForeignKey(User, on_delete=models.CASCADE, related_name="approvals")
    approver = models.ForeignKey(Position, on_delete=models.CASCADE, related_name="approvals")
    notes = models.TextField(blank=True)
    status = models.CharField(choices=STATUS_CHOICES, max_length=25, default="pending")
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.document} - Requested by {self.requester} - To be approved by f{self.approver}"

    class Meta:
        unique_together = ['document', 'status']


class AccessRequest(models.Model):
    STATUS_CHOICES = [
        ('pending', 'Pending'),
        ('approved', 'Approved'),
        ('rejected', 'Rejected'),
    ]

    ACCESS_CHOICES = [
        ('read', 'Read'),
        ('update', 'Update'),
    ]

    user = models.ForeignKey(User, on_delete=models.CASCADE)
    document = models.ForeignKey(Document, on_delete=models.CASCADE)
    access = models.CharField(choices=ACCESS_CHOICES, max_length=20)
    status = models.CharField(choices=STATUS_CHOICES, default='pending', max_length=20)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.user.username} - {self.document.title}"
