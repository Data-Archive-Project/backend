# Generated by Django 4.1.7 on 2023-06-25 08:48

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0023_remove_document_status_approval_approver_and_more'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='document',
            options={'ordering': ['-created_at']},
        ),
        migrations.AlterUniqueTogether(
            name='approval',
            unique_together={('document', 'status')},
        ),
    ]
