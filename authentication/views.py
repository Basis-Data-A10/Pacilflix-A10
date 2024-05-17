from django.http import HttpResponseRedirect
from django.shortcuts import redirect, render
from django.contrib.auth import logout as auth_logout
from django.urls import reverse
from pacilflix_function.functions import *
from pacilflix_function.authentication import *
from utils.query import *

def show_landing(request):
    return render(request, "landing_page.html")

def show_register(request):
    return render(request, "register_page.html")

def show_login(request):
    return render(request, "login_page.html")

def register(request):
    if request.method == "POST":
        username = request.POST.get("username")
        password = request.POST.get("password")
        negara_asal = request.POST.get("negara_asal")
        query_register(username, password, negara_asal, request)
    return render(request, 'register_page.html')

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