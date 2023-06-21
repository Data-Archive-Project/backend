# Generated by Django 4.1.7 on 2023-06-21 09:19

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion
import django.utils.timezone


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('api', '0022_alter_document_read_access_and_more'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='document',
            name='status',
        ),
        migrations.AddField(
            model_name='approval',
            name='approver',
            field=models.ForeignKey(default=1, on_delete=django.db.models.deletion.CASCADE, related_name='approvals', to='api.position'),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='approval',
            name='notes',
            field=models.TextField(blank=True),
        ),
        migrations.AddField(
            model_name='approval',
            name='requester',
            field=models.ForeignKey(default=1, on_delete=django.db.models.deletion.CASCADE, related_name='approvals', to=settings.AUTH_USER_MODEL),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='document',
            name='date_received',
            field=models.DateTimeField(blank=True, default=django.utils.timezone.now, null=True),
        ),
        migrations.AddField(
            model_name='document',
            name='position_access',
            field=models.ManyToManyField(related_name='position_documents', to='api.position'),
        ),
        migrations.AlterField(
            model_name='approval',
            name='status',
            field=models.CharField(choices=[('pending', 'Pending'), ('accepted', 'Accepted'), ('rejected', 'Rejected')], default='pending', max_length=25),
        ),
        migrations.AlterUniqueTogether(
            name='approval',
            unique_together={('document', 'requester', 'approver', 'status')},
        ),
        migrations.RemoveField(
            model_name='approval',
            name='approval_by',
        ),
    ]
