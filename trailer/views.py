from django.shortcuts import render
import random
from urllib.parse import quote
import urllib.parse
from django.shortcuts import render, redirect
from django.db import connection
from django.contrib.auth.decorators import login_required
from django.http import JsonResponse
from datetime import datetime
from django.http import HttpResponse
# Create your views here.

def trailer(request):
    return render(request, 'hal_trailer.html')

def trailer_guest(request):
    return render(request, 'hal_trailer_guest.html')

def show_hasil_pencarian_trailer(request, value):
    checked_value = check_string_valid(value)
    tayangan = query_result(f"""SELECT judul, sinopsis_trailer, url_video_trailer, release_date_trailer
                                FROM "TAYANGAN"
                                WHERE judul ILIKE '%{checked_value}%';""")

    context = {"tayangan": tayangan,
               "searchvalue": value}

    return render(request, 'hasil_pencarian_trailer.html', context)
