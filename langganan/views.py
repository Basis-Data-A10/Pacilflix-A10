from datetime import *
from django.db import connection
from django.shortcuts import redirect, render
from django.core.paginator import Paginator
from django.contrib.auth.decorators import login_required

# @login_required
def beli_paket(request):
    if request.method == 'POST':
        username = request.COOKIES.get('username')
        nama_paket = request.POST.get('nama_paket')
        metode_pembayaran = request.POST.get('metode_pembayaran')
        timestamp_pembayaran = datetime.now()
        start_date_time = datetime.now()
        end_date_time = start_date_time + timedelta(days=30)

        with connection.cursor() as cursor:
            cursor.execute("""
                INSERT INTO transaction (username, start_date_time, end_date_time, nama_paket, metode_pembayaran, timestamp_pembayaran)
                VALUES (%s, %s, %s, %s, %s, %s)
                SET end_date_time = %s, nama_paket = %s, metode_pembayaran = %s, timestamp_pembayaran = %s
            """, [username, timestamp_pembayaran, end_date_time, nama_paket, metode_pembayaran, datetime.now(), end_date_time, nama_paket, metode_pembayaran, datetime.now()])

        return redirect('langganan:langganan')
    
    nama_paket = request.GET.get('nama_paket')
    if not nama_paket:
        return redirect('langganan:langganan')

    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT pa.nama, pa.harga, pa.resolusi_layar, string_agg(dp.dukungan_perangkat, ', ') AS dukungan_perangkat
            FROM PAKET pa
            LEFT JOIN DUKUNGAN_PERANGKAT dp ON pa.nama = dp.nama_paket
            WHERE pa.nama = %s
            GROUP BY pa.nama, pa.harga, pa.resolusi_layar
        """, [nama_paket])
        package = cursor.fetchone()

    return render(request, 'belipaket.html', {'package': package})

# @login_required
def daftar_kontributor(request):
    tipe_filter = request.GET.get('tipe', '')

    with connection.cursor() as cursor:
        query = """
            SELECT c.nama, 
                   CASE 
                       WHEN ps.id IS NOT NULL THEN 'Penulis Skenario' 
                       WHEN pm.id IS NOT NULL THEN 'Pemain' 
                       WHEN s.id IS NOT NULL THEN 'Sutradara' 
                   END AS tipe, 
                   c.jenis_kelamin, 
                   c.kewarganegaraan 
            FROM CONTRIBUTORS c 
            LEFT JOIN PENULIS_SKENARIO ps ON c.id = ps.id 
            LEFT JOIN PEMAIN pm ON c.id = pm.id 
            LEFT JOIN SUTRADARA s ON c.id = s.id
        """
        if tipe_filter:
            query += " WHERE CASE WHEN ps.id IS NOT NULL THEN 'Penulis Skenario' WHEN pm.id IS NOT NULL THEN 'Pemain' WHEN s.id IS NOT NULL THEN 'Sutradara' END = %s"
            cursor.execute(query, [tipe_filter])
        else:
            cursor.execute(query)
        contributors = cursor.fetchall()

    formatted_contributors = []
    for contributor in contributors:
        formatted_contributors.append({
            'nama': contributor[0],
            'tipe': contributor[1],
            'jenis_kelamin': 'Laki-laki' if contributor[2] == 0 else 'Perempuan',
            'kewarganegaraan': contributor[3]
        })

    paginator = Paginator(formatted_contributors, 10)  # 10 contributors per page
    page_number = request.GET.get('page')
    page_obj = paginator.get_page(page_number)

    return render(request, 'daftar_kontributor.html', {
        'page_obj': page_obj,
        'tipe_filter': tipe_filter,
    })

def langganan(request):
    username = request.COOKIES.get('username')
    if not username:
        return redirect('login')
    print(f"user: {username}")

    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT p.username, pa.nama, pa.harga, pa.resolusi_layar, 
                   string_agg(dp.dukungan_perangkat, ', ') AS dukungan_perangkat, 
                   t.start_date_time, t.end_date_time
            FROM TRANSACTION t
            JOIN PAKET pa ON t.nama_paket = pa.nama
            JOIN PENGGUNA p ON t.username = p.username
            LEFT JOIN DUKUNGAN_PERANGKAT dp ON pa.nama = dp.nama_paket
            WHERE p.username = %s
            GROUP BY p.username, pa.nama, pa.harga, pa.resolusi_layar, t.start_date_time, t.end_date_time
            ORDER BY t.start_date_time DESC
            LIMIT 1
        """, [username])
        current_subscription = cursor.fetchone()
        print(f'Current Subscription: {current_subscription}')

    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT pa.nama, pa.harga, pa.resolusi_layar, string_agg(dp.dukungan_perangkat, ', ') AS dukungan_perangkat
            FROM PAKET pa
            LEFT JOIN DUKUNGAN_PERANGKAT dp ON pa.nama = dp.nama_paket
            GROUP BY pa.nama, pa.harga, pa.resolusi_layar
        """)
        packages = cursor.fetchall()
        print(f'Packages: {packages}')

    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT t.nama_paket, t.start_date_time, t.end_date_time, t.metode_pembayaran, t.timestamp_pembayaran, pa.harga
            FROM TRANSACTION t
            JOIN PAKET pa ON t.nama_paket = pa.nama
            WHERE t.username = %s
            ORDER BY t.start_date_time DESC
        """, [username])
        transaction_history = cursor.fetchall()
        print(f'Transaction History: {transaction_history}')

    context = {
        'current_subscription': current_subscription,
        'packages': packages,
        'transaction_history': transaction_history,
    }

    return render(request, 'langganan.html', context)
