# Generated by Django 4.1.7 on 2023-06-10 18:13

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0013_profile_is_admin'),
    ]

    operations = [
        migrations.AlterField(
            model_name='profile',
            name='staff_id',
            field=models.IntegerField(max_length=8),
        ),
        migrations.AlterField(
            model_name='profile',
            name='title',
            field=models.CharField(blank=True, max_length=20),
        ),
    ]
