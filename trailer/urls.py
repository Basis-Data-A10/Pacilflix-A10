from django.urls import path
from django.views.generic import TemplateView

urlpatterns = [
    path('', TemplateView.as_view(template_name='daftar_trailer.html'), name='daftar_trailer'),
#     path('hasil-pencarian-trailer/<str:value>/', show_hasil_pencarian_trailer, name='show_hasil_pencarian_trailer'),

]
