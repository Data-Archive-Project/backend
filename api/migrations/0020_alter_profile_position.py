# Generated by Django 4.1.7 on 2023-06-19 17:50

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0019_alter_document_category_alter_document_uploaded_by_and_more'),
    ]

    operations = [
        migrations.AlterField(
            model_name='profile',
            name='position',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.PROTECT, to='api.position'),
        ),
    ]
