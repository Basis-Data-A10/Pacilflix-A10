# from tayangan.views import show_tayangan # Hapus baris ini atau komentari
from django.urls import path
from django.views.generic import TemplateView
from .views import *

app_name = 'tayangan'

urlpatterns = [
    path('series/episode/<series_id>/<episode_number>/', episode, name='episode'),
    path('film/<film_id>/', film, name='film'),
    path('series/<series_id>/', series, name='series'),
    path('', tayangan, name='tayangan'),
    path('unduh_tayangan/<str:id_tayangan>/', unduh_tayangan, name='unduh_tayangan'),
    path('unduh_tayangan_series/<str:id_tayangan>/', unduh_tayangan_series, name='unduh_tayangan_series'),
    path('insert_favorit_film/<str:id_tayangan>', tambah_ke_daftar_favorit, name='insert_favorit'),
    path('insert_favorit_series/<str:id_series>/<str:judul>/', daftar_favorit_series, name='insert_favorit_series'),
    path('add_tonton/', add_tonton, name='add_tonton'),
    path('ulasan/<tayangan_id>', open_ulasan, name='open_ulasan'),
    path('search/', show_hasil_pencarian_tayangan, name='hasil_search'),
]
