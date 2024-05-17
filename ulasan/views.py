from django.shortcuts import render, redirect
from django.db import connection
from django.contrib import messages
from django.http import HttpResponseRedirect
from django.contrib.auth.decorators import login_required

def ulasan(request, id_tayangan):
    if request.method == "POST":
        # Tambahkan ulasan jika metode request adalah POST
        if 'username' not in request.session or 'username' not in request.COOKIES:
            return redirect('authentication:landing')

        username = request.COOKIES.get('username')
        id = request.POST['id']
        rating = int(request.POST['rating'])
        deskripsi = request.POST['deskripsi']
        tipe = request.POST['tipe']

        cursor = connection.cursor()
        try:
            cursor.execute(f"""
                INSERT INTO "ULASAN" VALUES ('{id}', '{username}', NOW(), '{rating}', '{deskripsi}');
            """)
            messages.add_message(request, messages.SUCCESS, 'Ulasan berhasil ditambahkan!', extra_tags='ulasan')
        except Exception as e:
            if 'Username' in str(e):
                messages.add_message(request, messages.ERROR, f"Username {username} sudah memberikan ulasan pada tayangan ini!", extra_tags='ulasan')

        if tipe == 'series':
            return HttpResponseRedirect(f'/tayangan/series/{id}')
        return HttpResponseRedirect(f'/tayangan/film/{id}')

    # Ambil ulasan jika metode request adalah GET
    ulasans = []
    with connection.cursor() as cursor:
        cursor.execute(f"SELECT * FROM ULASAN WHERE id_tayangan = '{id_tayangan}'")
        ulasans = cursor.fetchall()

        cursor.execute(f"SELECT judul FROM TAYANGAN WHERE id = '{id_tayangan}'")
        judul = cursor.fetchone()

    context = {
        'judul': judul,
        'ulasans': ulasans,
        'id_tayangan': id_tayangan,  # Pastikan ID tayangan tersedia untuk form
        'tipe': 'series' if 'series' in request.path else 'film'  # Tentukan tipe berdasarkan URL
    }
    return render(request, 'hal_ulasan.html', context)
