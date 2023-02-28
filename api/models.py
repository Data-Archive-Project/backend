from django.db import models
from django.contrib.auth import User
from django.core.validators import RegexValidator

class Role(models.Model):
    name = models.CharField(max_length=100) # admin, staff, 

    def __str__(self):
        return self.name


class Document(models.Model):
    FILE_CHOICES = [
        ("Image", "Image"),
        ("DOC", "Word Document"),
        ("Excel", "Excel File"),
        ("PDF", "PDF File")
    ]
    title = models.CharField(max_length=255)
    from_ = None

    description = models.TextField()
    file_type = models.CharField(choices=FILE_CHOICES)
    file = models.FileField()
    category = models.ForeignKey(Category, on_delete=models.CASCADE, related_name="documents")
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)


    def __str__(self):
        return self.title


class Profile(models.Model):
    user  = models.OneToOneField(User, on_delete=models.CASCADE, related_name="profile")
    title = models.CharField(max_length=255) # dr, prof, mr 
    phone_regex = RegexValidator(regex=r'^\+?1?\d{9,15}$', message="Phone number must be entered in the format: '+999999999'. Up to 15 digits allowed.")
    phone = models.CharField(max_length=17, validators=[phone_regex], blank=True)
    role = model.ForeignKey(Role, on_delete=models.CASCADE)
    documents = models.ManyToManyField(Document, related_name="profiles", on_delete=models.CASCADE)

    def __str__(self):
        pass


class Category(model.Model):
    cat_name = models.CharField(max_length=255)
    description = models.TextField(blank=True)

    def __str__(self):
        return self.cat_name


class Document(models.Model):
    FILE_CHOICES = [
        ("Image", "Image"),
        ("DOC", "Word Document"),
        ("Excel", "Excel File"),
        ("PDF", "PDF File")
    ]
    title = models.CharField(max_length=255)
    from_ = None

    description = models.TextField()
    file_type = models.CharField(choices=FILE_CHOICES)
    file = models.FileField()
    category = models.ForeignKey(Category, on_delete=models.CASCADE, related_name="documents")
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)


    def __str__(self):
        return self.title
