from django.db.models.signals import post_save
from django.dispatch import receiver
from django.core.mail import send_mail
from .models import Notification


@receiver(post_save, sender=Notification)
def send_notification_email(sender, instance, created, **kwargs):
    if created:
        subject = 'New Notification'
        message = instance.message
        sender_email = 'janprince002@gmail.com'  # Replace this with your email

        recipient_list = [instance.receiver.email]
        send_mail(subject, message, sender_email, recipient_list)
