from django.shortcuts import render
from django.http import HttpResponseRedirect
from django.urls import reverse
from pacilflix_function.functions import *

def show_favorite(request):
    return render(request, "daftar_favorit.html")