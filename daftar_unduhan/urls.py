from django.urls import path
from .views import show_downloads, delete_download

app_name = 'daftar_unduhan'

urlpatterns = [
    path('', show_downloads, name='show_downloads'),
    path('delete/<uuid:download_id>/', delete_download, name='delete_download')
]