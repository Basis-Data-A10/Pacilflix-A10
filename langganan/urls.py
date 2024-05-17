from django.urls import path
from django.views.generic import TemplateView
from langganan import views

app_name = "langganan"

urlpatterns = [
    path('', views.langganan, name='langganan'),
    path('beli_paket/', views.beli_paket, name='beli_paket'),
    path('daftar_kontributor/', views.daftar_kontributor, name='daftar_kontributor')
]
    