from django.shortcuts import render
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.views.decorators.csrf import csrf_exempt
from django.shortcuts import redirect
from django.contrib import messages
from django.contrib.auth.forms import UserCreationForm


# @login_required(login_url='/login')
# def show_main(request):
#     context = {
#         'name': 'Pak Bepe',
#         'class': 'PBP A'
#     }

#     return render(request, "index.html", context)

def register(request):
    form = UserCreationForm()

    if request.method == "POST":
        form = UserCreationForm(request.POST)
        if form.is_valid():
            form.save()
            messages.success(request, 'Your account has been successfully created!')
            return redirect('login')
    context = {'form':form}
    return render(request, 'register_page.html', context)

def login_user(request):
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')
        user = authenticate(request, username=username, password=password)

        if user is not None:
            login(request, user)
            return redirect('lend:show_catalog')
        
        else:
            messages.info(request, 'Sorry, incorrect username or password. Please try again.')
    context = {}
    return render(request, 'login_page.html', context)

def logout_user(request):
    logout(request)
    return redirect('login')
