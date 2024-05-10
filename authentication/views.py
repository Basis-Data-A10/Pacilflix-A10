from django.shortcuts import render

def show_landing(request):
    return render(request, "landing_page.html")

def show_register(request):
    return render(request, "register_page.html")

def show_login(request):
    return render(request, "login_page.html")