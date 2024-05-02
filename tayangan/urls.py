# from tayangan.views import show_tayangan # Hapus baris ini atau komentari
from django.urls import path
from django.views.generic import TemplateView

urlpatterns = [
    path('', TemplateView.as_view(template_name='daftar_tayangan.html'), name='daftar_tayangan'),
    path('hasil-search/', TemplateView.as_view(template_name='hasil_search.html'), name='hasil_search'),
    path('hal-film/', TemplateView.as_view(template_name='hal_film.html'), name='hal_film'),
    path('hal-series/', TemplateView.as_view(template_name='hal_series.html'), name='hal_series'),
    path('hal-eps/', TemplateView.as_view(template_name='hal_eps.html'), name='hal_eps'),
    
]
