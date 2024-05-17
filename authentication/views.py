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

@csrf_exempt
def register(request):
    context = {}

    if request.method == "POST":
        username = request.POST.get("username")
        password = request.POST.get("password")
        negara_asal = request.POST.get("negara_asal")
        response = query_register(username, password, negara_asal, request)
        return response

    return render(request, 'register_page.html', context)

@csrf_exempt
def login(request):
    context = {}

    if request.method == "POST":
        username = request.POST.get("username")
        password = request.POST.get("password")

        response = query_login(username, password, request)
        return response 

    return render(request, 'login_page.html', context)

def logout(request):
    response = query_logout(request)
    return response