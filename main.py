import mysql.connector
from tabulate import tabulate
import matplotlib.pyplot as plt
import matplotlib.ticker as mticker
import squarify
import os

# =============================================
# KONEKSI DATABASE
# =============================================
def connect_db():
    try:
        connection = mysql.connector.connect(
            host="localhost",
            user="root",
            password="Rockefeller123",
            database="electronic_store"
        )
        return connection
    except mysql.connector.Error as e:
        print(f"\n  ❌ Koneksi database gagal: {e}")
        print(f"  Pastikan MySQL sudah berjalan dan password benar.\n")
        return None
# =============================================
# FITUR 1 - READ TABLE
# =============================================
def read_sales_table():
    print("\n" + "="*65)
    print("         DATA PENJUALAN - ELECTROMART ALL BRANCHES")
    print("="*65)

    conn = connect_db()
    if not conn:    # ← tambah ini
        return      # ← dan ini
    print("  Mengambil data...")   # ← tambah ini
    cursor = conn.cursor()

    query = """
        SELECT 
            s.sale_id                    AS 'Sale ID',
            b.branch_name                AS 'Cabang',
            p.product_name               AS 'Produk',
            p.price                      AS 'Harga Satuan',
            s.quantity                   AS 'Qty',
            (p.price * s.quantity)       AS 'Total Harga',
            s.sale_date                  AS 'Tanggal'
        FROM sales s
        JOIN products p ON s.product_id = p.product_id
        JOIN branches b ON s.branch_id = b.branch_id
        ORDER BY s.sale_date DESC
    """

    cursor.execute(query)
    results = cursor.fetchall()
    headers = [desc[0] for desc in cursor.description]

    formatted_results = []
    for row in results:
        row = list(row)
        row[3] = f"Rp {row[3]:,.0f}".replace(",", ".")
        row[5] = f"Rp {row[5]:,.0f}".replace(",", ".")
        formatted_results.append(row)

    print(tabulate(formatted_results, headers=headers, tablefmt="fancy_grid"))
    print(f"\nTotal Transaksi: {len(results)} data\n")

    cursor.close()
    conn.close()

# =============================================
# FITUR 2 - SHOW STATISTIK
# =============================================
def show_statistik():
    print("\n" + "="*65)
    print("         STATISTIK PENJUALAN - ELECTROMART ALL BRANCHES")
    print("="*65)

    conn = connect_db()
    if not conn:    # ← tambah ini
        return      # ← dan ini
    print("  Menghitung statistik...")  # ← tambah ini
    cursor = conn.cursor()

    query = """
    SELECT 
        c.category_name                      AS 'Kategori',
        COUNT(s.sale_id)                     AS 'Total Transaksi',
        ROUND(AVG(p.price), 0)               AS 'Avg Harga Satuan',
        ROUND(AVG(s.quantity), 1)            AS 'Avg Qty',
        ROUND(AVG(p.price * s.quantity), 0)  AS 'Avg Total per Transaksi',
        SUM(p.price * s.quantity)            AS 'Total Revenue'
    FROM sales s
    JOIN products p ON s.product_id = p.product_id
    JOIN categories c ON p.category_id = c.category_id
    GROUP BY c.category_name
    ORDER BY SUM(p.price * s.quantity) DESC
    """

    cursor.execute(query)
    results = cursor.fetchall()
    headers = [desc[0] for desc in cursor.description]

    # Format angka jadi Rupiah
    formatted_results = []
    for row in results:
        row = list(row)
        row[2] = f"Rp {row[2]:,.0f}".replace(",", ".")  # Avg Harga Satuan
        row[4] = f"Rp {row[4]:,.0f}".replace(",", ".")  # Avg Total per Transaksi
        row[5] = f"Rp {row[5]:,.0f}".replace(",", ".")  # Total Revenue
        formatted_results.append(row)

    print(tabulate(formatted_results, headers=headers, tablefmt="fancy_grid"))

    # ---- Summary bawah tabel ----
    cursor.execute("""
        SELECT 
            COUNT(s.sale_id)              AS total_transaksi,
            SUM(p.price * s.quantity)     AS total_revenue,
            ROUND(AVG(p.price), 0)        AS avg_harga,
            ROUND(AVG(s.quantity), 1)     AS avg_qty
        FROM sales s
        JOIN products p ON s.product_id = p.product_id
    """)
    summary = cursor.fetchone()

    print("\n" + "-"*65)
    print("  RINGKASAN KESELURUHAN")
    print("-"*65)
    print(f"  Total Transaksi        : {summary[0]} transaksi")
    print(f"  Total Revenue          : Rp {summary[1]:,.0f}".replace(",", "."))
    print(f"  Rata-rata Harga Produk : Rp {summary[2]:,.0f}".replace(",", "."))
    print(f"  Rata-rata Qty per Trx  : {summary[3]} unit")
    print("-"*65 + "\n")

    cursor.close()
    conn.close()

# =============================================
# FITUR 3 - DATA VISUALIZATION
# =============================================
def show_visualisasi():
    print("\n" + "="*65)
    print("         DATA VISUALIZATION - ELECTROMART")
    print("="*65)
    print("  Memuat visualisasi data...")

    conn = connect_db()
    if not conn:    # ← tambah ini
        return      # ← dan ini
    print("  Memuat visualisasi...")
    cursor = conn.cursor()

    # ---- DATA 1: Revenue per Kategori (Pie Chart) ----
    cursor.execute("""
        SELECT c.category_name, SUM(p.price * s.quantity) AS total_revenue
        FROM sales s
        JOIN products p ON s.product_id = p.product_id
        JOIN categories c ON p.category_id = c.category_id
        GROUP BY c.category_name
        ORDER BY total_revenue DESC
    """)
    data_kategori = cursor.fetchall()
    labels_kategori = [row[0] for row in data_kategori]
    values_kategori = [float(row[1]) for row in data_kategori]

    # ---- DATA 2: Transaksi per Cabang (Bar Chart) ----
    cursor.execute("""
        SELECT b.branch_name, COUNT(s.sale_id) AS total_transaksi
        FROM sales s
        JOIN branches b ON s.branch_id = b.branch_id
        GROUP BY b.branch_name
        ORDER BY total_transaksi DESC
    """)
    data_cabang = cursor.fetchall()
    labels_cabang = [row[0] for row in data_cabang]
    values_cabang = [row[1] for row in data_cabang]

    # ---- DATA 3: Distribusi Total Harga (Histogram) ----
    cursor.execute("""
        SELECT (p.price * s.quantity) AS total_harga
        FROM sales s
        JOIN products p ON s.product_id = p.product_id
    """)
    data_harga = [row[0] for row in cursor.fetchall()]

    cursor.close()
    conn.close()

    # =============================================
    # PLOT SEMUA CHART DALAM 1 FIGURE
    # =============================================
    fig, axes = plt.subplots(1, 3, figsize=(22, 7))
    fig.patch.set_facecolor("#0F0F0F")
    fig.suptitle("ElectroMart - Dashboard Visualisasi Penjualan",
                 fontsize=15, fontweight="bold", color="white")

    # ---- Chart 1: Horizontal Bar Chart ----
    total = sum(values_kategori)
    colors_bar1 = ["#FF3333", "#00CC99", "#0099FF", "#FF9900", "#CC44FF", "#FF66AA"]

    # Balik urutan supaya yang terbesar di atas
    labels_rev = labels_kategori[::-1]
    values_rev = values_kategori[::-1]
    colors_rev = colors_bar1[::-1]

    bars1 = axes[0].barh(labels_rev, values_rev,
                         color=colors_rev,
                         edgecolor="#0F0F0F",
                         linewidth=1.5,
                         height=0.6)

    # Label nilai di ujung kanan tiap bar
    for bar, val in zip(bars1, values_rev):
        pct = val / total * 100
        axes[0].text(bar.get_width() + total * 0.01,
                     bar.get_y() + bar.get_height() / 2,
                     f"Rp{val/1e6:.0f}jt\n({pct:.1f}%)", 
                     va="center", ha="left",
                     fontsize=7.5, fontweight="bold", color="white")

    axes[0].set_facecolor("#1A1A1A")
    axes[0].set_title("Revenue per Kategori",
                      fontweight="bold", color="white", pad=10)
    axes[0].set_xlabel("Total Revenue (Rp)", color="white")
    axes[0].tick_params(axis="y", colors="white", labelsize=8)
    axes[0].tick_params(axis="x", colors="white", rotation=30) 
    axes[0].spines["bottom"].set_color("#444444")
    axes[0].spines["left"].set_color("#444444")
    axes[0].spines["top"].set_visible(False)
    axes[0].spines["right"].set_visible(False)
    axes[0].xaxis.set_major_formatter(
        mticker.FuncFormatter(lambda x, _: f"Rp{x/1e6:.0f}jt")
    )
    # Tambah ruang di kanan untuk label nilai
    axes[0].set_xlim(0, max(values_rev) * 1.55)
    axes[0].set_facecolor("#1A1A1A")
    
    # ---- Chart 2: Bar Chart ----
    colors_bar = ["#FF3333", "#00CC99", "#0099FF", "#FF9900", "#CC44FF"]
    bars = axes[1].bar(
        labels_cabang,
        values_cabang,
        color=colors_bar,
        edgecolor="#0F0F0F",
        linewidth=1.5
    )
    axes[1].set_facecolor("#1A1A1A")
    axes[1].set_title("Total Transaksi per Cabang",
                      fontweight="bold", color="white", pad=10)
    axes[1].set_xlabel("Cabang", color="white")
    axes[1].set_ylabel("Jumlah Transaksi", color="white")
    axes[1].tick_params(axis="x", rotation=15, colors="white")
    axes[1].tick_params(axis="y", colors="white")
    axes[1].spines["bottom"].set_color("#444444")
    axes[1].spines["left"].set_color("#444444")
    axes[1].spines["top"].set_visible(False)
    axes[1].spines["right"].set_visible(False)
    for bar, val in zip(bars, values_cabang):
        axes[1].text(bar.get_x() + bar.get_width()/2, bar.get_height() + 0.3,
                     str(val), ha="center", va="bottom",
                     fontsize=10, fontweight="bold", color="white")

    # ---- Chart 3: Histogram ----
    axes[2].hist(
        data_harga,
        bins=10,
        color="#0099FF",
        edgecolor="#0F0F0F",
        linewidth=1.5
    )
    axes[2].set_facecolor("#1A1A1A")
    axes[2].set_title("Distribusi Total Harga Transaksi",
                      fontweight="bold", color="white", pad=10)
    axes[2].set_xlabel("Total Harga (Rp)", color="white")
    axes[2].set_ylabel("Frekuensi", color="white")
    axes[2].tick_params(axis="x", rotation=15, colors="white")
    axes[2].tick_params(axis="y", colors="white")
    axes[2].spines["bottom"].set_color("#444444")
    axes[2].spines["left"].set_color("#444444")
    axes[2].spines["top"].set_visible(False)
    axes[2].spines["right"].set_visible(False)
    axes[2].xaxis.set_major_formatter(
        mticker.FuncFormatter(lambda x, _: f"Rp{x/1e6:.0f}jt")
    )

    plt.tight_layout(pad=2.5)
    plt.subplots_adjust(left=0.08, right=0.97, wspace=0.35) 
    print("\n  Grafik berhasil dimuat! Tutup jendela grafik untuk kembali ke menu.\n")
    plt.show()

# =============================================
# FITUR 4 - ADD DATA
# =============================================
def add_data():
    print("\n" + "="*55)
    print("         TAMBAH TRANSAKSI BARU - ELECTROMART")
    print("="*55)

    conn = connect_db()
    if not conn:    # ← tambah ini
        return      # ← dan ini
    print("  Memuat data...")
    cursor = conn.cursor()

    # ---- Tampilkan daftar cabang ----
    cursor.execute("SELECT branch_id, branch_name, city FROM branches")
    branches = cursor.fetchall()

    print("\n  Daftar Cabang:")
    print("  " + "-"*35)
    for b in branches:
        print(f"  {b[0]}. {b[1]} - {b[2]}")
    print("  " + "-"*35)

    while True:
        try:
            branch_input = int(input("\n  Pilih nomor cabang: "))
            branch_ids = [b[0] for b in branches]
            if branch_input in branch_ids:
                branch_name = next(b[1] for b in branches if b[0] == branch_input)
                break
            else:
                print("  Nomor cabang tidak valid, coba lagi.")
        except ValueError:
            print("  Input harus berupa angka!")

    # ---- Tampilkan daftar produk ----
    cursor.execute("""
        SELECT p.product_id, p.product_name, c.category_name, p.price
        FROM products p
        JOIN categories c ON p.category_id = c.category_id
        ORDER BY c.category_name, p.product_name
    """)
    products = cursor.fetchall()

    print("\n  Daftar Produk:")
    print("  " + "-"*55)
    print(f"  {'No':<5} {'Produk':<30} {'Kategori':<15} {'Harga'}")
    print("  " + "-"*55)
    for p in products:
        harga = f"Rp {float(p[3]):,.0f}".replace(",", ".")
        print(f"  {p[0]:<5} {p[1]:<30} {p[2]:<15} {harga}")
    print("  " + "-"*55)

    while True:
        try:
            product_input = int(input("\n  Pilih nomor produk: "))
            product_ids = [p[0] for p in products]
            if product_input in product_ids:
                product_data = next(p for p in products if p[0] == product_input)
                product_name = product_data[1]
                product_price = float(product_data[3])
                break
            else:
                print("  Nomor produk tidak valid, coba lagi.")
        except ValueError:
            print("  Input harus berupa angka!")

    # ---- Input quantity ----
    while True:
        try:
            quantity = int(input("\n  Masukkan jumlah unit: "))
            if quantity > 0:
                break
            else:
                print("  Quantity harus lebih dari 0!")
        except ValueError:
            print("  Input harus berupa angka!")

    # ---- Hitung total & tanggal otomatis ----
    from datetime import date
    sale_date = date.today()
    total_harga = product_price * quantity

    # ---- Cek stok di inventory ----
    cursor.execute("""
        SELECT stock FROM inventory
        WHERE branch_id = %s AND product_id = %s
    """, (branch_input, product_input))
    
    stok_data = cursor.fetchone()
    
    if not stok_data:
        print(f"\n  ❌ Stok produk ini tidak ditemukan di cabang {branch_name}.")
        cursor.close()
        conn.close()
        return

    stok_tersedia = stok_data[0]

    # ---- Konfirmasi sebelum simpan ----
    print("\n" + "="*55)
    print("  KONFIRMASI TRANSAKSI")
    print("="*55)
    print(f"  Cabang         : {branch_name}")
    print(f"  Produk         : {product_name}")
    print(f"  Harga Satuan   : Rp {product_price:,.0f}".replace(",", "."))
    print(f"  Quantity       : {quantity} unit")
    print(f"  Total Harga    : Rp {total_harga:,.0f}".replace(",", "."))
    print(f"  Tanggal        : {sale_date}")
    print(f"  Stok Tersedia  : {stok_tersedia} unit")
    print("="*55)

    # ---- Validasi stok cukup ----
    if quantity > stok_tersedia:
        print(f"\n  ❌ STOK TIDAK CUKUP!")
        print(f"     Stok tersedia : {stok_tersedia} unit")
        print(f"     Qty diminta   : {quantity} unit")
        print(f"     Selisih kurang: {quantity - stok_tersedia} unit\n")
        cursor.close()
        conn.close()
        return

    konfirmasi = input("\n  Simpan transaksi ini? (y/n): ").lower()

    if konfirmasi == "y":
        # INSERT transaksi baru
        cursor.execute("""
            INSERT INTO sales (branch_id, product_id, quantity, sale_date)
            VALUES (%s, %s, %s, %s)
        """, (branch_input, product_input, quantity, sale_date))

        new_sale_id = cursor.lastrowid

        # UPDATE stok inventory berkurang
        cursor.execute("""
            UPDATE inventory
            SET stock = stock - %s
            WHERE branch_id = %s AND product_id = %s
        """, (quantity, branch_input, product_input))

        conn.commit()

        stok_setelah = stok_tersedia - quantity
        print(f"\n  ✅ Transaksi berhasil disimpan!")
        print(f"  Sale ID        : {new_sale_id}")
        print(f"  Sisa stok      : {stok_setelah} unit\n")
    else:
        print("\n  ❌ Transaksi dibatalkan.\n")

    cursor.close()
    conn.close()

# =============================================
# MENU UTAMA
# =============================================
def show_menu():
    os.system('cls' if os.name == 'nt' else 'clear')
    print("\n" + "="*45)
    print("  ██████  ELECTROMART MANAGEMENT SYSTEM")
    print("="*45)
    print("  Sistem Manajemen Toko Elektronik")
    print("  5 Cabang | Real-time Database")
    print("="*45)

    while True:
        print("\n" + "─"*45)
        print("  MENU UTAMA")
        print("─"*45)
        print("  1.  Lihat Data Penjualan")
        print("  2.  Statistik Penjualan")
        print("  3.  Visualisasi Data")
        print("  4.  Tambah Transaksi Baru")
        print("  0.  Keluar")
        print("─"*45)

        pilihan = input("  Pilih menu [0-4]: ").strip()

        if pilihan == "1":
            read_sales_table()
        elif pilihan == "2":
            show_statistik()
        elif pilihan == "3":
            show_visualisasi()
        elif pilihan == "4":
            add_data()
        elif pilihan == "0":
            print("\n" + "="*45)
            print("  Terima kasih telah menggunakan")
            print("  ElectroMart Management System!")
            print("="*45 + "\n")
            break
        else:
            print("\n  ⚠️  Menu tidak valid! Pilih angka 0-4.")
# =============================================
# JALANKAN PROGRAM
# =============================================
show_menu()