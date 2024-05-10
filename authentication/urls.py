from django.urls import path
from authentication.views import show_register, show_login, show_landing

app_name = 'authentication'

urlpatterns = [
    path('register/', show_register, name='register'), 
    path('login/', show_login, name='login'),
    path('', show_landing, name='show_landing'),
]