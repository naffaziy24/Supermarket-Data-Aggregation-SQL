# Supermarket-Data-Aggregation-SQL
Advanced SQL queries utilizing GROUPING SETS, ROLLUP, and CUBE extensions to perform multi-dimensional data aggregation on the Adventure Works supermarket database

## 📌 Project Overview

Proyek ini menyajikan **analisis data berbasis SQL dan agregasi tingkat lanjut** (*advanced aggregation*) pada data transaksi di dalam ekosistem Database Supermarket Adventure Works. Berdasarkan data operasional yang kompleks, proyek ini berfokus pada eksplorasi data menggunakan fungsi *extended query* seperti `GROUPING SETS`, `ROLLUP`, `CUBE`, dan fungsi `GROUPING`. Pendekatan ini mempermudah pihak manajemen dalam mengurai data penjualan, manajemen inventaris, transaksi pelanggan, serta data cabang penjualan untuk menghasilkan keputusan bisnis yang lebih cerdas dan strategis.

## 🎯 Objectives

* Menganalisis efisiensi stok dan hubungan antara manajemen penyimpanan dengan volume penjualan.
* Memahami preferensi dan perilaku pembelian pelanggan berdasarkan demografi dan segmentasi tertentu.
* Mengidentifikasi faktor-faktor kunci serta tren penjualan multidimensional yang memengaruhi pendapatan supermarket.
* Mengimplementasikan teknik extended query guna mempermudah pengelolaan informasi dari volume data yang besar dan kompleks.

## 📊 Key Metrics Analyzed

* Total Penjualan per Mode Pembayaran dan Jenis Kelamin.
* Rata-rata Rating Feedback berdasarkan Gender pelanggan dan ID pelanggan.
* Total Produk yang Dikembalikan (*Return Slip*) per Kategori, Mode Pembayaran, dan ID Penawaran.
* Total Penjualan per Jenis Tawaran (*Offer Type*), Tipe Pelanggan, dan Tanggal Faktur.
* Total Pembelian (*Quantity*) per Invoice, Kategori Produk, Karyawan (*Cashier*), Tipe Pelanggan, hingga Lokasi Blok Gudang.

## 🔍 Key Insights

* **Fleksibilitas Analisis Multigrup:** Penggunaan `GROUPING SETS` memungkinkan penentuan beberapa grup agregasi dalam satu query (seperti perpaduan kategori produk dan blok), memberikan fleksibilitas tinggi dalam analisis pasar.
* **Agregasi Hierarkis Terstruktur:** Fitur `ROLLUP` mempermudah pemantauan performa bisnis pada berbagai tingkat granularitas, contohnya melacak data pelanggan paling favorit secara bertingkat dari tahun ke tahun.
* **Kombinasi Data Komprehensif:** Konsep `CUBE` menyajikan agregasi data pada semua kombinasi kolom, membantu manajemen melihat keterkaitan silang antara tata letak blok toko, jenis produk, dan tingkat loyalitas pelanggan dari berbagai perspektif sekaligus.
* **Integritas Data Hasil Agregasi:** Pemanfaatan fungsi `GROUPING` berhasil menjaga integritas laporan dengan membedakan nilai `NULL` asli pada database dari nilai `NULL` yang dihasilkan oleh kalkulasi sistem `ROLLUP` atau `CUBE`.

## 🛠️ Tools Used

* **SQL Dialect:** PostgreSQL-compatible syntax
* **Database:** Adventure Works Supermarket Database
* **Advanced Features:** `GROUPING SETS`, `ROLLUP`, `CUBE`, dan fungsi `GROUPING`

