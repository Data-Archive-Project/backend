from django.core.mail import send_mail
from django.template.loader import render_to_string
from django.utils.html import strip_tags


def send_notification_email(recipients, title, description, first_name, last_name):

    subject = 'New Notification'
    html_message = render_to_string('emails/notification.html', {'title': title, 'description': description, 'first_name': first_name, 'last_name': last_name})
    plain_message = strip_tags(html_message)  # Convert HTML to plain text for non-HTML email clients
    sender_email = 'janprince002@gmail.com'  # Replace this with your email

    recipient_list = recipients
    send_mail(subject, plain_message, sender_email, recipient_list, html_message=html_message)
