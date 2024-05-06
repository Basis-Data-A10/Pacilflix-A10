from django.db import models

class Auth(models.Model):
    username = models.TextField(null=True)
    password = models.TextField(null=True)
    negara_asal = models.CharField(max_length=255, null=True)

