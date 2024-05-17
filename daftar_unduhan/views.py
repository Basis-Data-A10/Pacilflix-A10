from django.shortcuts import render
from django.urls import reverse
from django.contrib import messages
from django.http import HttpResponseRedirect
from pacilflix_function.functions import *
from uuid import UUID



def show_downloads(request):
    username = request.COOKIES.get('username')
    print("Username from session:", username)
    
    if username is None:
        print("Username is None")
        return redirect('authentication:login')  # Redirect to login if username is not found in session
    
    with connection.cursor() as cursor:
        cursor.execute("""
               SELECT t.judul, tt.timestamp, t.id
               FROM tayangan_terunduh AS tt
               INNER JOIN tayangan AS t ON tt.id_tayangan = t.id
               WHERE tt.username = %s
               """, [username])
        
        downloads = cursor.fetchall()
        print("Retrieved downloads:", downloads)
    
    context = {'downloads': downloads}
    return render(request, "daftar_unduhan.html", context)


def delete_download(request, download_id):
    username = request.COOKIES.get('username')

    try:
        uuid_obj = UUID(str(download_id), version=4)  # Ensure the ID is a valid UUID
    except ValueError:
        print("Invalid UUID format")
        messages.error(request, "Invalid download ID format.")
        return HttpResponseRedirect(reverse('daftar_unduhan:show_downloads'))
    
    try:
        with connection.cursor() as cursor:
            cursor.execute("""
                DELETE FROM tayangan_terunduh 
                WHERE id_tayangan = %s AND username = %s
                RETURNING id_tayangan
            """, [str(uuid_obj), username])
            deleted_row = cursor.fetchone()
            print("Dia masuk sini")
            if deleted_row is None:
                print("No download found with the specified ID")
                messages.error(request, "No download found with the specified ID.")
                return HttpResponseRedirect(reverse('daftar_unduhan:show_downloads'))   
    except Exception as e:
            with connection.cursor() as cursor:
                cursor.execute("""
                    SELECT t.judul, tt.timestamp, t.id
                    FROM tayangan_terunduh AS tt
                    INNER JOIN tayangan AS t ON tt.id_tayangan = t.id
                    WHERE tt.username = %s
                """, [username])
                print("An error occurred:", str(e))
                downloads = cursor.fetchall()

            return render(request, "daftar_unduhan.html", {'error_deletion': True, 'downloads': downloads})
    return HttpResponseRedirect(reverse('daftar_unduhan:show_downloads'))