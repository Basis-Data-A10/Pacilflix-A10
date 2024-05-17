from django.urls import path
from .views import *

app_name = 'ulasan'

urlpatterns = [
    path('/<id_tayangan>/', ulasan, name='ulasan')
]