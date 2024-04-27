from django.urls import path, include
from authentication.views import register, login_user, logout_user, show_landing

app_name = 'authentication'

urlpatterns = [
    path('register/', register, name='register'), 
    path('login/', login_user, name='login'),
    path('logout/', logout_user, name='logout'),
    path('', show_landing, name='show_landing'),
]