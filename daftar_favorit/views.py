from django.shortcuts import render
from django.http import HttpResponseRedirect
from django.urls import reverse
from pacilflix_function.functions import *
from django.db import connection
from uuid import UUID

def show_favorite(request):
    if not request.user.is_authenticated:
        print("User is not authenticated")
    
    username = request.COOKIES.get('username')
    print("Username from session: ", username)

    if username is None:
        print("Username is None")

    with connection.cursor() as cursor:
        cursor.execute("""
                       SELECT * FROM daftar_favorit
                       WHERE username = %s
                       """, [username])
        
        daftar_favorit = cursor.fetchall()

        print("Daftar favorit: ", daftar_favorit)
    
    context = {
        'daftar_favorit': daftar_favorit
    }

    return render(request, "daftar_favorit.html", context)

def delete_favorite(request, favorite_timestamp):
    if not request.user.is_authenticated:
        print("User is not authenticated from delete_favorite")
    
    username = request.COOKIES.get('username')
    
    with connection.cursor() as cursor:
        cursor.execute("""
                       DELETE FROM daftar_favorit
                       WHERE timestamp = %s AND username = %s
                       """, [favorite_timestamp, username])
    
    return HttpResponseRedirect(reverse('daftar_favorit:daftar_favorit'))

def show_favorite_detail(request, favorite_timestamp):
    if not request.user.is_authenticated:
        print("User is not authenticated from show_favorite_detail")
    
    username = request.COOKIES.get('username')
    
    with connection.cursor() as cursor:
        cursor.execute("""
                       SELECT t.judul, tf.timestamp, t.id
                       FROM tayangan AS t
                       INNER JOIN tayangan_memiliki_daftar_favorit AS tf
                       ON t.id = tf.id_tayangan
                       WHERE tf.timestamp = %s AND tf.username = %s
                       """, [favorite_timestamp, username])
        
        favorite_detail = cursor.fetchall()

        print("Favorite detail: ", favorite_detail)
    
    context = {
        'favorite_detail': favorite_detail
    }

    return render(request, "daftar_favorit_detail.html", context)

def delete_favorite_film(request, favorite_timestamp, film_id):
    if not request.user.is_authenticated:
        print("User is not authenticated from delete_favorite_film")
    
    username = request.COOKIES.get('username')
    
    try:
        uuid_obj = UUID(str(film_id), version=4) # Ensure the ID is a valid UUID
    except ValueError:
        # Handle the error if film_id is not a valid UUID
        return HttpResponseRedirect(reverse('daftar_favorit:daftar_favorit'))
    
    with connection.cursor() as cursor:
        cursor.execute("""
                       DELETE FROM tayangan_memiliki_daftar_favorit
                       WHERE timestamp = %s AND username = %s AND id_tayangan = %s
                       """, [favorite_timestamp, username, str(uuid_obj)])
    
    return HttpResponseRedirect(reverse('daftar_favorit:daftar_favorit'))