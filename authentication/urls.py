from django.urls import path
from authentication.views import show_register, show_login, show_landing, login, logout, register

app_name = 'authentication'

urlpatterns = [
    path('', show_landing, name='show_landing'),
    # path('register/', show_register, name='register'), 
    # path('login/', show_login, name='login'),
    path('register/', register, name='register'),
    path('login/', login, name='login'),
    path('logout/', logout, name='logout'),  
]