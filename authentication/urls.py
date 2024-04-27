from django.urls import path, include
from authentication.views import register, login, logout, show_landing

app_name = 'authentication'

urlpatterns = [
    path('register/', register, name='register'), 
    path('login/', login, name='login'),
    path('logout/', logout, name='logout'),
    path('', show_landing, name='show_landing'),
]