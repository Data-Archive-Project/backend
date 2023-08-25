from django.core.mail import EmailMessage, EmailMultiAlternatives
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


def send_document_email(recipient, subject, message, sender, file_path):
    # Generate the HTML message from a template
    html_message = render_to_string('emails/document.html', {'message': message})
    plain_message = strip_tags(html_message)  # Convert HTML to plain text for non-HTML email clients
    sender_email = sender  # Replace this with your email

    # Create an instance of EmailMessage and attach the file
    # Create an EmailMultiAlternatives instance
    email = EmailMultiAlternatives(
        subject=subject,
        body=plain_message,  # Plain text version of the email
        from_email=sender_email,
        to=[recipient],
    )

    # Attach the HTML content as an alternative content type
    email.attach_alternative(html_message, "text/html")

    # Attach a file if provided
    email.attach_file(file_path)

    # Send the email
    email.send()

    # Send the email
    email.send()

