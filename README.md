# Sakuku - Aplikasi Manajemen Keuangan & Kurs Real-time

**Sakuku** adalah aplikasi mobile berbasis Flutter yang dirancang untuk membantu pengguna mengelola keuangan pribadi (Pencatatan Pemasukan & Pengeluaran) serta memantau nilai tukar mata uang asing secara *real-time* menggunakan integrasi RESTful API.

Proyek ini dikembangkan sebagai pemenuhan tugas Ujian Akhir Semester (UAS) Mata Kuliah Mobile Programming.

## 📱 Fitur Utama

1.  **Manajemen Saldo Utama**:
    * Mencatat Pemasukan (*Income*) dan Pengeluaran (*Expense*).
    * Perhitungan otomatis Saldo Utama (*Main Balance*).
    * Visualisasi riwayat transaksi dengan indikator warna (Hijau untuk Pemasukan, Merah untuk Pengeluaran).

2.  **Informasi Kurs Dunia (Integrasi API)**:
    * **Live Data**: Mengambil data nilai tukar mata uang dari server publik secara *real-time*.
    * **Search Feature**: Fitur pencarian untuk memfilter mata uang tertentu (misal: USD, EUR, JPY).
    * **Asynchronous UI**: Indikator visual saat memuat data (*Loading State*) dan penanganan kesalahan koneksi (*Error State*).

## 🔗 Daftar Endpoint API

Aplikasi ini menggunakan API publik gratis dari **Frankfurter API** untuk data kurs mata uang.

* **Nama API**: Frankfurter API
* **Base URL**: `https://api.frankfurter.app`

### Endpoint yang Digunakan:

| Method | Endpoint | Deskripsi |
| :--- | :--- | :--- |
| `GET` | `/latest?from=IDR` | Mengambil daftar nilai tukar seluruh mata uang dunia dengan basis Rupiah (IDR). |

**Contoh Response (JSON):**
```json
{
  "amount": 1.0,
  "base": "IDR",
  "date": "2023-12-12",
  "rates": {
    "USD": 0.000064,
    "EUR": 0.000059,
    "JPY": 0.0093
  }
}
