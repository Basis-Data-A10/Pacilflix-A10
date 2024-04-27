from django.shortcuts import render
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.views.decorators.csrf import csrf_exempt
from django.shortcuts import redirect
from django.contrib import messages
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login as auth_login
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth import logout as auth_logout
from django.http import HttpResponseNotFound, HttpResponseRedirect, JsonResponse
from django.urls import reverse


#@login_required(login_url='/login')
def show_landing(request):
    context = {
        'name': 'Pak Bepe',
        'class': 'PBP A',
        'images': ['https://cdn3.iconfinder.com/data/icons/letters-and-numbers-1/32/letter_P_red-1024.png']
    }

    return render(request, "landing_page.html", context)

@csrf_exempt
def register(request):
    form = UserCreationForm()

    if request.method == "POST":
        form = UserCreationForm(request.POST)
        if User.objects.filter(username=request.POST.get('username')).exists():
            messages.error(request, 'Username already exists. Please try again.')
        elif form.is_valid():
            form.save()
            messages.success(request, 'Your account has been successfully created!')
            return redirect('authentication:show_landing')
    context = {'form':form}
    return render(request, 'register_page.html', context)

@csrf_exempt
def login_user(request):
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')
        user = authenticate(request, username=username, password=password)
        if user is not None:
            login(request, user)
            response = HttpResponseRedirect(reverse("authentication:show_landing")) 
            return response
        else:
            messages.info(request, 'Sorry, incorrect username or password. Please try again.')
    context = {}
    return render(request, 'login_page.html', context)

def logout_user(request):
    logout(request)
    response = HttpResponseRedirect(reverse('authentication:show_landing'))
    return response