# Generated by Django 4.1.7 on 2023-06-04 17:20

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0010_alter_permission_user'),
    ]

    operations = [
        migrations.AlterField(
            model_name='permission',
            name='document',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='permissions', to='api.document'),
        ),
    ]
