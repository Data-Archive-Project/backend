# Generated by Django 4.1.7 on 2023-06-04 17:51

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0012_alter_profile_position_alter_profile_rank'),
    ]

    operations = [
        migrations.AddField(
            model_name='profile',
            name='is_admin',
            field=models.BooleanField(default=False),
        ),
    ]
