from django.shortcuts import render, redirect
from django.urls import reverse
from django.db import connection
from django.contrib import messages
from django.http import HttpResponseRedirect
from pacilflix_function.functions import *
from uuid import UUID


def show_downloads(request):
    if not request.user.is_authenticated:
        print("User is not authenticated")
    
    username = request.session.get('username')

    # Debug: Check if the username is correctly retrieved from the session
    print("Username from session:", username)
    
    if username is None:
        print("Username is None")
    
    with connection.cursor() as cursor:
        cursor.execute("""
               SELECT t.judul, tt.timestamp, t.id
               FROM tayangan_terunduh AS tt
               INNER JOIN tayangan AS t ON tt.id_tayangan = t.id
               WHERE tt.username = %s
               """, [username])
        
        downloads = cursor.fetchall()

        # Debug: Print the retrieved downloads
        print("Retrieved downloads:", downloads)
    
    context = {'downloads': downloads}

    return render(request, "daftar_unduhan.html", context)

def delete_download(request, download_id):
    if not request.user.is_authenticated:
        print("User is not authenticated from delete_download")
    
    username = request.session.get('username')

    try:
        uuid_obj = UUID(str(download_id), version=4)  # Ensure the ID is a valid UUID
    except ValueError:
        # Handle the error if download_id is not a valid UUID
        return HttpResponseRedirect(reverse('daftar_unduhan:show_downloads'))
    
    with connection.cursor() as cursor:
        cursor.execute("""
                       DELETE FROM tayangan_terunduh 
                       WHERE id_tayangan = %s AND username = %s
                       """, [str(uuid_obj), username])
    
    return HttpResponseRedirect(reverse('daftar_unduhan:show_downloads'))