# from tayangan.views import show_tayangan # Hapus baris ini atau komentari
from django.urls import path
from django.views.generic import TemplateView
from .views import *

app_name = 'tayangan'
#
# urlpatterns = [
#     path('', TemplateView.as_view(template_name='daftar_tayangan.html'), name='daftar_tayangan'),
#     path('hasil-search/', TemplateView.as_view(template_name='hasil_search.html'), name='hasil_search'),
#     path('hal-film/', TemplateView.as_view(template_name='hal_film.html'), name='hal_film'),
#     path('hal-series/', TemplateView.as_view(template_name='hal_series.html'), name='hal_series'),
#     path('hal-eps/', TemplateView.as_view(template_name='hal_eps.html'), name='hal_eps'),
# #     path('show_tayangan/'), TemplateView.as_view(template_name='show_tayangan.html', name='show_tayangan'),
# #
# ]

urlpatterns = [
    path('series/episode/<series_id>/<episode_number>/', episode, name='episode'),
    path('film/<film_id>/', film, name='film'),
    path('series/<series_id>/', series, name='series'),
    path('', tayangan, name='tayangan'),
    path('insert_unduhan/', insert_unduhan, name='insert_unduhan'),
    path('list_favorit/', list_favorit, name='list_favorit'),
    path('insert_favorit/', insert_favorit, name='insert_favorit'),
    path('go_to_unduhan/', go_to_unduhan, name='go_to_unduhan'),
    path('ulasan/<tayangan_id>', open_ulasan, name='open_ulasan')
]
