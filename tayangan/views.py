import random
from urllib.parse import quote
import urllib.parse
from django.shortcuts import render, redirect
from django.db import connection
from django.contrib.auth.decorators import login_required
from django.http import *
from datetime import datetime, timedelta
import datetime


def execute_query(query):
    with connection.cursor() as cursor:
        cursor.execute(query)
        columns = [col[0] for col in cursor.description]
        return [
            dict(zip(columns, row))
            for row in cursor.fetchall()
        ]

#Fungsi untuk mengurus halaman film, akan mereturn html film
def film(request, film_id):
    with connection.cursor() as cursor:
        cursor.execute(
            f"SELECT judul, sinopsis, asal_negara FROM TAYANGAN WHERE id = '{film_id}'"
        )
        film_details = cursor.fetchone()

        if film_details:
            cursor.execute(
                f"SELECT genre FROM GENRE_TAYANGAN WHERE id_tayangan = '{film_id}'"
            )
            genres = [genre[0] for genre in cursor.fetchall()]

            cursor.execute(
                f"SELECT url_video_film, release_date_film, durasi_film FROM FILM WHERE id_tayangan = '{film_id}'"
            )
            film_info = cursor.fetchone()

            cursor.execute(
                f"SELECT id_sutradara FROM TAYANGAN WHERE id = '{film_id}'"
            )
            director_id = cursor.fetchone()[0] if cursor.rowcount > 0 else None

            director = None
            if director_id:
                cursor.execute(
                    f"SELECT nama FROM CONTRIBUTORS WHERE id = '{director_id}'"
                )
                director = cursor.fetchone()[0]

            cursor.execute(
                f"SELECT id_pemain FROM MEMAINKAN_TAYANGAN WHERE id_tayangan = '{film_id}'"
            )
            pemain_ids = cursor.fetchall()

            pemain_names = []
            for pemain_id in pemain_ids:
                cursor.execute(
                    f"SELECT nama FROM CONTRIBUTORS WHERE id = '{pemain_id[0]}'"
                )
                pemain_name = cursor.fetchone()
                if pemain_name:
                    pemain_names.append(pemain_name[0])

            pemain = pemain_names if pemain_names else None

            cursor.execute(
                f"SELECT id_penulis_skenario FROM MENULIS_SKENARIO_TAYANGAN WHERE id_tayangan = '{film_id}'"
            )
            penulis_ids = cursor.fetchall()

            penulis_names = []
            for penulis_id in penulis_ids:
                cursor.execute(
                    f"SELECT nama FROM CONTRIBUTORS WHERE id = '{penulis_id[0]}'"
                )
                penulis_name = cursor.fetchone()
                if penulis_name:
                    penulis_names.append(penulis_name[0])

            penulis = penulis_names if penulis_names else None
            release_date_film = film_info[1]  # This is already a datetime.date object
            is_released = release_date_film <= datetime.now().date()

            film_details = {
                'judul': film_details[0],
                'sinopsis': film_details[1],
                'asal_negara': film_details[2],
                'genres': genres,
                'is_released': is_released,
                'url_video_film' : film_info[0],
                'release_date_film': film_info[1],
                'durasi_film': film_info[2],
                'sutradara': director,
                'pemain' : pemain,
                'penulis' : penulis,
                'id_tayangan' : film_id
            }

    return render(request, 'hal_film.html', {'film_details': film_details})

#Fungsi untuk mengurus halaman series, akan mereturn html series
def series(request, series_id):
    with connection.cursor() as cursor:
        cursor.execute(
            f"SELECT judul, sinopsis, asal_negara FROM TAYANGAN WHERE id = '{series_id}'"
        )
        series_details = cursor.fetchone()

        if series_details:
            cursor.execute(
                f"SELECT genre FROM GENRE_TAYANGAN WHERE id_tayangan = '{series_id}'"
            )
            genres = [genre[0] for genre in cursor.fetchall()]

            cursor.execute(
                f"SELECT id_sutradara FROM TAYANGAN WHERE id = '{series_id}'"
            )
            director_id = cursor.fetchone()[0] if cursor.rowcount > 0 else None

            director = None
            if director_id:
                cursor.execute(
                    f"SELECT nama FROM CONTRIBUTORS WHERE id = '{director_id}'"
                )
                director = cursor.fetchone()[0]

            cursor.execute(
                f"SELECT id_pemain FROM MEMAINKAN_TAYANGAN WHERE id_tayangan = '{series_id}'"
            )
            pemain_ids = cursor.fetchall()
            pemain_names = []
            for pemain_id in pemain_ids:
                cursor.execute(
                    f"SELECT nama FROM CONTRIBUTORS WHERE id = '{pemain_id[0]}'"
                )
                pemain_name = cursor.fetchone()
                if pemain_name:
                    pemain_names.append(pemain_name[0])
            pemain = pemain_names if pemain_names else None

            cursor.execute(
                f"SELECT id_penulis_skenario FROM MENULIS_SKENARIO_TAYANGAN WHERE id_tayangan = '{series_id}'"
            )
            penulis_ids = cursor.fetchall()
            penulis_names = []
            for penulis_id in penulis_ids:
                cursor.execute(
                    f"SELECT nama FROM CONTRIBUTORS WHERE id = '{penulis_id[0]}'"
                )
                penulis_name = cursor.fetchone()
                if penulis_name:
                    penulis_names.append(penulis_name[0])
            penulis = penulis_names if penulis_names else None

            # Mendapatkan detail episode
            cursor.execute(f"""SELECT id_series, sub_judul
                               FROM EPISODE
                               WHERE id_series = '{series_id}';""")
            episodes_data = cursor.fetchall()
            episodes_num = [(i, *episode) for i, episode in enumerate(episodes_data)]

            series_details = {
                'judul': series_details[0],
                'sinopsis': series_details[1],
                'asal_negara': series_details[2],
                'genres': genres,
                'sutradara': director,
                'pemain' : pemain,
                'penulis' : penulis,
                'id_tayangan' : series_id,
                'episodes' : episodes_num,
            }

            return render(request, 'hal_series.html', {'series_details': series_details})
        else:
            # Handle case when series_details is not found
            # For example, return an error page or redirect to another page
            return HttpResponse("Series not found", status=404)

def episode(request, series_id, episode_number):
    episode_number = int(episode_number)
    with connection.cursor() as cursor:
        # Mendapatkan judul tayangan
        cursor.execute("SELECT judul FROM TAYANGAN WHERE id = %s", [series_id])
        series_title = cursor.fetchone()

        # Mendapatkan semua episode untuk id_series tertentu
        cursor.execute("SELECT * FROM EPISODE WHERE id_series = %s", [series_id])
        episodes = cursor.fetchall()
        episodes_num = [(i, *episode) for i, episode in enumerate(episodes)]

        # Memilih episode berdasarkan episode_number
        if 0 <= episode_number < len(episodes):
            episode = episodes[episode_number]
            episode_details = {
                'id_series': episode[0],
                'sub_judul': episode[1],
                'sinopsis': episode[2],
                'durasi': episode[3],
                'url_video': episode[4],
                'release_date': episode[5],
            }
        else:
            episode_details = None

    context = {
        'episodes': episodes_num,
        'episode': episode_details,
        'series_title': series_title[0] if series_title else None,  # Ensure series_title is not None before accessing the title
    }
    return render(request, 'hal_eps.html', context)

def tayangan(request):

    top_10_query = f"""
        WITH durasi_tayangan AS (
            SELECT T.id AS id, F.durasi_film AS durasi
            FROM TAYANGAN AS T
            JOIN FILM AS F ON F.id_tayangan = T.id
            UNION
            SELECT T.id AS id, AVG(E.durasi) AS durasi
            FROM TAYANGAN AS T
            JOIN SERIES AS S ON S.id_tayangan = T.id
            JOIN EPISODE AS E ON E.id_series = T.id
            GROUP BY T.id
        ), recent_views AS (
            SELECT T.id AS id, EXTRACT(EPOCH FROM (RW.end_date_time - RW.start_date_time)) / 60 AS watch_time
            FROM TAYANGAN AS T
            JOIN RIWAYAT_NONTON AS RW ON RW.id_tayangan = T.id
            WHERE RW.start_date_time >= NOW() - INTERVAL '7 DAYS'
        )
        SELECT T.id, T.judul, T.sinopsis_trailer, T.url_video_trailer, T.release_date_trailer, COUNT(RV.id) as total_view,
               CASE
                   WHEN EXISTS (SELECT 1 FROM FILM AS F WHERE F.id_tayangan = T.id) THEN 'film'
                   ELSE 'series'
               END AS tipe_tayangan
        FROM TAYANGAN AS T
        JOIN durasi_tayangan AS DT ON DT.id = T.id
        JOIN recent_views AS RV ON RV.id = T.id
        WHERE RV.watch_time > (0.7 * DT.durasi)
        GROUP BY T.id, T.judul, T.sinopsis_trailer, T.url_video_trailer, T.release_date_trailer
        ORDER BY total_view DESC, T.judul ASC
        LIMIT 10;
    """

    film_query = f"""
        SELECT T.id, T.judul, T.sinopsis_trailer, T.url_video_trailer, T.release_date_trailer
        FROM TAYANGAN AS T
        JOIN FILM AS F ON F.id_tayangan = T.id;
    """

    series_query = f"""
        SELECT T.id, T.judul, T.sinopsis_trailer, T.url_video_trailer, T.release_date_trailer
        FROM TAYANGAN AS T
        JOIN SERIES AS S ON S.id_tayangan = T.id;
    """
    paket = execute_query(f"""SELECT
                                CASE
                                    WHEN MAX(end_date_time) > CURRENT_DATE THEN 1
                                    ELSE 0
                                END AS is_valid
                            FROM TRANSACTION
                            WHERE username = '{request.COOKIES.get('username')}';""")

    top_10 = execute_query(top_10_query)
    film = execute_query(film_query)
    series = execute_query(series_query)


    # Menambahkan peringkat
    rank = 1
    for i in top_10:
        i['rank'] = rank
        rank += 1

    context = {
        "film": film,
        "series": series,
        "top_10": top_10,
        "paket": paket[0],
    }

    return render(request, 'daftar_tayangan.html', context)

#Fungsi Search untuk suatu tayangan berdasarkan judul, akan mereturn ke halaman hasil search
def show_hasil_pencarian_tayangan(request, value):
    checked_value = check_string_valid(value)
    tayangan = execute_query(f"""SELECT id, judul, sinopsis_trailer, url_video_trailer, release_date_trailer
                                FROM TAYANGAN
                                WHERE LOWER(judul) LIKE LOWER('%{checked_value}%');""")

    paket = execute_query(f"""SELECT
                                 CASE
                                     WHEN MAX(end_date_time) > CURRENT_DATE THEN 1
                                     ELSE 0
                                 END AS is_valid
                             FROM TRANSACTION
                             WHERE username = '{request.COOKIES.get('username')}';""")

    context = {"tayangan": tayangan,
               "searchvalue": value,
               "paket": paket[0]}

    return render(request, 'hasil_search.html', context)


def add_tonton(request):
    # Cek apakah pengguna sudah login
    if 'username' not in request.session or 'username' not in request.COOKIES:
        return redirect('authentication:show_landing')

    # Jika request metode adalah POST
    if request.method == "POST":
        # Ambil data dari request
        username = request.COOKIES.get('username')
        id_tayangan = request.POST['id_tayangan']
        tipe = request.POST['tipe']
        progress = int(request.POST['progress'])
        durasi = int(request.POST['durasi'])

        # Hitung progress dalam durasi menit
        progress = int((progress / 100) * durasi)

        cursor = connection.cursor()
        try:
            # Masukkan data nonton ke dalam database
            cursor.execute(f"""
                INSERT INTO RIWAYAT_NONTON VALUES ('{id_tayangan}', '{username}', NOW(), NOW() + {progress} * INTERVAL '1 minute');
            """)
            # Beri pesan sukses
            messages.add_message(request, messages.SUCCESS, 'Tayangan berhasil ditonton!', extra_tags='tonton')
        except InternalError as e:
            # Beri pesan gagal
            messages.add_message(request, messages.ERROR, 'Tayangan gagal ditonton!', extra_tags='tonton')

        # Alihkan ke halaman yang sesuai berdasarkan tipe tayangan
        if tipe == 'series':
            subjudul = request.POST['subjudul']
            encoded = quote(subjudul)
            url = f"{id_tayangan}/{encoded}/"
            return HttpResponseRedirect(f'/tayangan/series/{url}')
        return HttpResponseRedirect(f'/tayangan/film/{id_tayangan}')

def unduh_tayangan(request, id_tayangan):
    username = request.COOKIES.get('username')

    if username:
        current_time = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        with connection.cursor() as cursor:
            cursor.execute(f"""
                    INSERT INTO TAYANGAN_TERUNDUH VALUES ('{id_tayangan}', '{username}', '{current_time}');
                """)
            return HttpResponseRedirect(f'/tayangan/series/{id_tayangan}')

    else:
        return HttpResponseBadRequest('User not authenticated')

# def insert_unduhan(request):
#     username = request.COOKIES.get('username')
#     id_tayangan = request.GET.get('id_tayangan')
#     timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
#
#     with connection.cursor() as cursor:
#         cursor.execute(
#             f'INSERT INTO TAYANGAN_TERUNDUH VALUES (\'{id_tayangan}\', \'{username}\', \'{timestamp}\')')
#
#     connection.commit()
#     return JsonResponse({'status': 'success'})

def go_to_unduhan(request):
    return redirect('daftar_unduhan:daftar_unduhan')

def tambah_ke_daftar_favorit(request, id_tayangan, judul):
    username = request.COOKIES.get('username')
    with connection.cursor() as cursor:
        cursor.execute(f"""SELECT timestamp
                           FROM DAFTAR_FAVORIT
                           WHERE username = '{username}' AND judul = '{judul}'
                        """)
        timestamp = cursor.fetchall()
        timestamp_output = timestamp[0][0]

    with connection.cursor() as cursor:
        cursor.execute(f"""INSERT INTO TAYANGAN_MEMILIKI_DAFTAR_FAVORIT
                           VALUES ('{id_tayangan}', '{timestamp_output}', '{username}')
                       """)

    return JsonResponse({'message': 'Successfully added to favorites'})

def daftar_favorit_series(request, id_series, judul):
        username = request.COOKIES.get('username')
        if username:
            with connection.cursor() as cursor:
                cursor.execute(f"""SELECT timestamp
                                FROM DAFTAR_FAVORIT
                                WHERE username = '{username}' AND judul = '{judul}'
                                """)
                timestamp = cursor.fetchall()
                print(timestamp)
                timestamp_output = timestamp[0][0]

            with connection.cursor() as cursor:
                cursor.execute(f"""INSERT INTO TAYANGAN_MEMILIKI_DAFTAR_FAVORIT VALUES ('{id_series}', '{timestamp_output}', '{username}')
                            """)
            return JsonResponse({'message': 'Successfully added to favorites'})  # Or return any other response as needed
        else:
            return JsonResponse({'message': 'User not authenticated'}, status=401)

def open_ulasan(request, tayangan_id):
    return redirect('ulasan:hal_ulasan', id_tayangan=tayangan_id)

def check_string_valid(string):
    new_string = ''
    for char in string:
        if char == "'":
            new_string += "''"
        elif char == "\\":
            new_string += "\\\\"
        else:
            new_string += char
    return new_string