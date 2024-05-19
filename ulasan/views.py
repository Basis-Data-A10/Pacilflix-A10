import json
from django.shortcuts import render, redirect
from django.db import connection
from django.contrib import messages
from django.http import JsonResponse, HttpResponseRedirect
from django.contrib.auth.decorators import login_required
from datetime import datetime

#@login_required
def ulasan(request, id_tayangan):
    if request.method == "POST":
        if 'username' not in request.session or 'username' not in request.COOKIES:
            return redirect('authentication:landing')

        username = request.COOKIES.get('username')
        id = request.POST['id']
        rating = int(request.POST['rating'])
        deskripsi = request.POST['deskripsi']
#         tipe = request.POST['tipe']
        timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

        with connection.cursor() as cursor:
            try:
                cursor.execute("""
                    INSERT INTO ULASAN (id_tayangan, username, tanggal, rating, deskripsi)
                    VALUES (%s, %s, NOW(), %s, %s);
                """, [id, username, rating, deskripsi])
                if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
                    return JsonResponse({
                        'success': True,
                        'username': username,
                        'timestamp': timestamp,
                        'rating': rating,
                        'deskripsi': deskripsi
                    })
                messages.add_message(request, messages.SUCCESS, 'Ulasan berhasil ditambahkan!', extra_tags='ulasan')
            except Exception as e:
                if 'Username' in str(e):
                    if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
                        return JsonResponse({'success': False, 'error': f"Username {username} sudah memberikan ulasan pada tayangan ini!"})
                    messages.add_message(request, messages.ERROR, f"Username {username} sudah memberikan ulasan pada tayangan ini!", extra_tags='ulasan')

#         if tipe == 'series':
#             return HttpResponseRedirect(f'/tayangan/series/{id}')
#         return HttpResponseRedirect(f'/tayangan/film/{id}')

    with connection.cursor() as cursor:
        cursor.execute("SELECT * FROM ULASAN WHERE id_tayangan = %s", [id_tayangan])
        ulasans = cursor.fetchall()

        cursor.execute("SELECT judul FROM TAYANGAN WHERE id = %s", [id_tayangan])
        judul = cursor.fetchone()

    context = {
        'judul': judul,
        'ulasans': ulasans,
        'id_tayangan': id_tayangan,  # Pastikan ID tayangan tersedia untuk form
#         'tipe': 'series' if 'series' in request.path else 'film'  # Tentukan tipe berdasarkan URL
    }
    return render(request, 'hal_ulasan.html', context)
