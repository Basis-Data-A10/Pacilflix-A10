from django.http import HttpResponseRedirect
from django.shortcuts import redirect, render
from django.contrib.auth import logout as auth_logout
from django.urls import reverse
from pacilflix_function.functions import *
from pacilflix_function.authentication import *
from utils.query import *
from django.views.decorators.csrf import csrf_exempt

def show_landing(request):
    return render(request, "landing_page.html")

def show_register(request):
    return render(request, "register_page.html")

def show_login(request):
    return render(request, "login_page.html")

@csrf_exempt
def register(request):
    if request.method == "POST":
        username = request.POST.get("username")
        password = request.POST.get("password")
        negara_asal = request.POST.get("negara_asal")

        query_register(username, password, negara_asal, request)

        response = redirect('authentication:show_landing')
        response.set_cookie('username', username)
        response.set_cookie('password', password)
        response.set_cookie('negara_asal', negara_asal)
        response.set_cookie('is_authenticated', "True")

        return response
    
    return render(request, 'register_page.html')

@csrf_exempt
def login(request):
    context = {}

    if request.method == "POST":
        username = request.POST.get("username")
        password = request.POST.get("password")

        query_login(username, password, request)

    return render(request, 'login_page.html', context)

def logout(request):
    response = HttpResponseRedirect(reverse('authentication:show_landing'))
    response.delete_cookie('username')
    response.delete_cookie('negara')
    response.delete_cookie('is_authenticated')

    auth_logout(request)

    return response