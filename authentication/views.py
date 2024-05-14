from django.shortcuts import render
from django.http import HttpResponseRedirect
from django.urls import reverse
from pacilflix_function.functions import *

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
        try:    
            execute_query(f"INSERT INTO PENGGUNA (username, password, negara_asal) VALUES ('{username}', '{password}', '{negara_asal}');")
            response = HttpResponseRedirect(reverse("authentication:show_landing"))
            return response
        except:
            context = {"username_exists": True}     
        return render(request, 'register_page.html', context)
    context = {"username_exists": False}
    return render(request, 'register_page.html', context)

def login(request):
    context = {"error": ""}
    if request.method == "POST":
        username = request.POST.get("username")
        password = request.POST.get("password")
        result = execute_query(f"SELECT * FROM PENGGUNA WHERE username='{username}' AND password='{password}';")
        print(result)
        if len(result) == 0:
            context = {"wrong_input": True}
        else:
            response = HttpResponseRedirect(reverse("authentication:show_landing"))
            return response
    return render(request, 'login_page.html', context)

def logout(request):
    response = HttpResponseRedirect(reverse("authentication:show_landing"))
    return response