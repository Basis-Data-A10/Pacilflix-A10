from django.http import HttpResponseRedirect
from django.shortcuts import redirect, render
from django.contrib.auth import logout as auth_logout
from django.urls import reverse
from pacilflix_function.functions import *
from pacilflix_function.authentication import *
from utils.query import *
from django.views.decorators.csrf import csrf_exempt
from django.contrib import messages
from django.db import InternalError, connection
from tayangan.views import *

def show_landing(request):
    return render(request, "landing_page.html")

@csrf_exempt
def register(request):
    context = {}

    if request.method == "POST":
        username = request.POST.get("username")
        password = request.POST.get("password")
        negara_asal = request.POST.get("negara_asal")
        
        # response = query_register(username, password, negara_asal, request)
        # return response
        cursor = connection.cursor()

        try:
            cursor.execute("INSERT INTO PENGGUNA VALUES (%s, %s, %s)", [username, password, negara_asal])
            # messages.success(request, f'Register success! Hello, {username}!')
            print(f'Register account {username} from {negara_asal} succeeded!')
            # response = HttpResponseRedirect(reverse("authentication:login"))    
            # return response
            return redirect('authentication:login')  
        except InternalError as e:
            print(e)
            messages.error(request, 'Register failed! Please use another username.')

    return render(request, 'register_page.html', context)

@csrf_exempt
def login(request):
    context = {}

    if request.method == "POST":
        username = request.POST.get("username")
        password = request.POST.get("password")

        cursor = connection.cursor()
        cursor.execute("SELECT username, password FROM PENGGUNA WHERE username = %s AND password = %s", [username, password])
        user = cursor.fetchone()

        if user is not None:
            # request.session['username'] = username
            # messages.success(request, f'Login success! Welcome to PacilFlix, {username}!')
            print(f'Login to {username} succeeded!')
            # response = HttpResponseRedirect(reverse("authentication:show_landing"))  # NANTI JADI TAYANGAN!!!
            response = redirect('tayangan:tayangan')
            response.set_cookie('username', username)
            response.set_cookie('password', password)
            response.set_cookie('authenticated', 'True')
            return response
        else:
            print('Login failed! Please try again.')
            messages.error(request, 'Login failed! Please try again.')

    return render(request, 'login_page.html', context)

def logout(request):
    response = redirect('authentication:show_landing')
    # response = HttpResponseRedirect(reverse("authentication:show_landing"))
    response.delete_cookie('username')
    response.delete_cookie('password')
    response.delete_cookie('authenticated')
    return response