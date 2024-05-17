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
    path('insert_unduhan/', insert_unduhan, name='insert_unduhan'),
    path('insert_favorit/', insert_favorit, name='insert_favorit'),
    path('add_tonton/', add_tonton, name='add_tonton'),
    path('go_to_unduhan/', go_to_unduhan, name='go_to_unduhan'),
    path('ulasan/<tayangan_id>', open_ulasan, name='open_ulasan'),
    path('hasil_search/<str:value>/', show_hasil_pencarian_tayangan, name='hasil_search'),
]
