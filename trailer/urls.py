from django.urls import path
from django.views.generic import TemplateView

urlpatterns = [
    path('', TemplateView.as_view(template_name='daftar_trailer.html'), name='daftar_trailer'),
    path('hasil-search/', TemplateView.as_view(template_name='hasil_search.html'), name='hasil_search'),

]
