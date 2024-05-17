from django.shortcuts import render
from django.db import connection
from datetime import datetime, timedelta


def execute_query(query):
    with connection.cursor() as cursor:
        cursor.execute(query)
        columns = [col[0] for col in cursor.description]
        return [
            dict(zip(columns, row))
            for row in cursor.fetchall()
        ]

def trailer_guest(request):
#     if 'username' not in request.session or 'username' not in request.COOKIES:
#         return redirect('authentication:show_landing')

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
    }

    return render(request, 'hal_trailer_guest.html', context)


def show_hasil_pencarian_trailer(request, value):
    checked_value = check_string_valid(value)
    tayangan = query_result(f"""SELECT judul, sinopsis_trailer, url_video_trailer, release_date_trailer
                                FROM "TAYANGAN"
                                WHERE judul ILIKE '%{checked_value}%';""")

    context = {"tayangan": tayangan,
               "searchvalue": value}

    return render(request, 'hasil_search_trailer.html', context)

def check_string_valid(string):
    new_string = ''
    for char in string:
        if char == "'":
            new_string += "''"
        elif char == "\\":
            new_string += "\\\\"
        else:
            new_string += char
