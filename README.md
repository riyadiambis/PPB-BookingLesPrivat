# Booking Les Privat

Aplikasi mobile berbasis Flutter untuk mencari dan memesan tutor les privat sesuai mata pelajaran yang dibutuhkan. Project ini dikembangkan secara bertahap sebagai tugas praktikum mata kuliah Pemrograman Piranti Bergerak, Program Studi Informatika, Universitas Mulawarman.

## Tampilan Aplikasi

<img src="docs/screenshot-beranda.png" width="300" alt="Tampilan halaman beranda">
<img src="docs/screenshot-jadwal.png" width="300" alt="Tampilan halaman jadwal">

## Progres Pengembangan

| Posttest | Materi | Yang Dikerjakan | Status |
|---|---|---|---|
| Posttest 1 | Widget Dasar | Halaman beranda: pencarian, daftar tutor, navigasi bawah | Selesai |
| Posttest 2 | Widget Lanjutan dan Navigation | Foto tutor, halaman Jadwal, panel total, navigasi antar halaman | Selesai |

## Fitur Saat Ini

- Kolom pencarian tutor atau mata pelajaran
- Daftar tutor berisi foto, nama, mata pelajaran, harga per sesi, dan tombol booking
- Menu navigasi bawah: Beranda, Jadwal, dan Profil
- Perpindahan halaman dari Beranda ke Jadwal dan sebaliknya
- Halaman Jadwal berisi daftar sesi yang akan dibooking, input jumlah sesi, serta panel total harga yang tetap berada di bagian bawah layar

Data tutor masih berupa data contoh dan tampilan masih bersifat statis.

## Widget yang Digunakan (Posttest 1)

MaterialApp, Scaffold, SafeArea, SingleChildScrollView, Padding, Column, Row, Container, SizedBox, Text, Icon, TextField, dan Expanded. Setiap penggunaan widget diberi komentar di dalam kode.

## Widget yang Digunakan (Posttest 2)

Image.asset untuk menampilkan foto tutor dari folder assets, Stack dan Positioned untuk menumpuk panel total di atas daftar jadwal, BoxShadow untuk memberi bayangan pada panel total, TextField dengan keyboardType angka untuk input jumlah sesi, NavigationBar untuk menu navigasi bawah, serta Navigator.push dan Navigator.pop untuk berpindah antar halaman.

## Rencana Pengembangan

Selain pemesanan tutor, aplikasi ini direncanakan memiliki fitur presensi sesi les. Alurnya dimulai dari pemesanan tutor, penjadwalan sesi, pencatatan kehadiran, hingga rekap riwayat belajar siswa.

## Cara Menjalankan

```bash
flutter pub get
flutter run -d chrome
```

## Pengembang

Rahmat Riyadi (2409106074)
Informatika, Universitas Mulawarman