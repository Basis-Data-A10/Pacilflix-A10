from django.urls import path
from django.views.generic import TemplateView
from .views import show_favorite, show_favorite_detail, delete_favorite, delete_favorite_film

app_name = 'daftar_favorit'

urlpatterns = [
    path('',show_favorite, name='daftar_favorit'),
    path('delete/<str:favorite_timestamp>/', delete_favorite, name='delete_favorite'),
    path('detail/<str:favorite_timestamp>/', show_favorite_detail, name='show_favorite_detail'),
    path('delete_film/<str:favorite_timestamp>/<uuid:film_id>', delete_favorite_film, name='delete_favorite_film')

]