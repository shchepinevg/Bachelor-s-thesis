# Generated by Django 3.0.6 on 2020-06-15 15:53

import django.contrib.postgres.fields
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('optim_app', '0009_auto_20200613_1845'),
    ]

    operations = [
        migrations.AddField(
            model_name='optimizationfunction',
            name='coordinates',
            field=django.contrib.postgres.fields.ArrayField(base_field=models.FloatField(), null=True, size=None),
        ),
        migrations.AddField(
            model_name='optimizationparameters',
            name='coordinates',
            field=django.contrib.postgres.fields.ArrayField(base_field=models.FloatField(), null=True, size=None),
        ),
    ]