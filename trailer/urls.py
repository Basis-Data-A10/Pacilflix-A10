from django.urls import path
from django.views.generic import TemplateView
from .views import *


app_name = 'trailer'

urlpatterns = [
    path('search-trailer/<str:value>/', show_hasil_pencarian_trailer, name='show_hasil_pencarian_trailer'),
    path('trailer-guest/', trailer_guest, name='trailer_guest'),
]
