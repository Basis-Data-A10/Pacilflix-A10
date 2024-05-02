# from tayangan.views import show_tayangan # Hapus baris ini atau komentari
from django.urls import path
from django.views.generic import TemplateView

urlpatterns = [
    path('', TemplateView.as_view(template_name='daftar_tayangan.html'), name='daftar_tayangan'),
    
]
