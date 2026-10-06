# Booking Les Privat

Aplikasi mobile berbasis Flutter untuk mencari dan memesan tutor les privat sesuai mata pelajaran yang dibutuhkan. Project ini dikembangkan secara bertahap sebagai tugas praktikum mata kuliah Pemrograman Piranti Bergerak, Program Studi Informatika, Universitas Mulawarman.

## Tampilan Aplikasi

![Tampilan halaman beranda](https://github.com/riyadiambis/PPB-BookingLesPrivat/raw/main/docs/screenshot-beranda.png)

![Tampilan halaman jadwal](https://github.com/riyadiambis/PPB-BookingLesPrivat/raw/main/docs/screenshot-jadwal.png)

## Progres Pengembangan

| Posttest   | Materi                         | Yang Dikerjakan                                                 | Status  |
| ---------- | ------------------------------ | --------------------------------------------------------------- | ------- |
| Posttest 1 | Widget Dasar                   | Halaman beranda: pencarian, daftar tutor, navigasi bawah        | Selesai |
| Posttest 2 | Widget Lanjutan dan Navigation | Foto tutor, halaman Jadwal, panel total, navigasi antar halaman | Selesai |
| Posttest 3 | State Management (Provider)    | BookingProvider buat kelola data tutor dan jumlah sesi, total harga otomatis, popup konfirmasi booking | Selesai |

## Fitur Saat Ini

- Kolom pencarian tutor atau mata pelajaran
- Daftar tutor berisi foto, nama, mata pelajaran, harga per sesi, dan tombol booking
- Menu navigasi bawah: Beranda, Jadwal, dan Profil
- Perpindahan halaman dari Beranda ke Jadwal dan sebaliknya
- Halaman Jadwal berisi daftar sesi yang akan dibooking, input jumlah sesi, serta panel total harga yang tetap berada di bagian bawah layar
- State booking (data tutor yang dipilih, jumlah sesi, total harga) dikelola terpusat pakai Provider, jadi Beranda dan Jadwal selalu sinkron
- Total harga di halaman Jadwal terhitung otomatis dan update seketika tanpa refresh manual
- Popup konfirmasi booking (icon centang + auto tertutup) saat tombol Konfirmasi Booking dipencet

Data tutor masih berupa data contoh dan tampilan masih bersifat statis.

## Widget yang Digunakan (Posttest 1)

MaterialApp, Scaffold, SafeArea, SingleChildScrollView, Padding, Column, Row, Container, SizedBox, Text, Icon, TextField, dan Expanded. Setiap penggunaan widget diberi komentar di dalam kode.

## Widget yang Digunakan (Posttest 2)

Image.asset untuk menampilkan foto tutor dari folder assets, Stack dan Positioned untuk menumpuk panel total di atas daftar jadwal, BoxShadow untuk memberi bayangan pada panel total, TextField dengan keyboardType angka untuk input jumlah sesi, NavigationBar untuk menu navigasi bawah, serta Navigator.push dan Navigator.pop untuk berpindah antar halaman.

## State Management (Posttest 3)

Posttest ini menerapkan konsep Provider yang dibahas di modul. Data tutor dan jumlah sesi booking dipindah dari masing-masing halaman ke satu `BookingProvider` (class yang extends `ChangeNotifier`), lalu didaftarkan ke seluruh aplikasi lewat `ChangeNotifierProvider` di `main.dart`. Beranda dan Jadwal membaca serta mengubah data yang sama lewat `context.watch` dan `context.read`, dan setiap perubahan (booking baru, ubah jumlah sesi, konfirmasi booking) dikabarkan ke semua halaman lewat `notifyListeners()`. State lokal yang cuma dipakai satu halaman, seperti kata kunci pencarian di Beranda, tetap pakai `setState()` biasa.

Di luar materi modul, ditambahkan juga popup `AlertDialog` dengan icon centang yang muncul dan otomatis tertutup sendiri setelah Konfirmasi Booking dipencet, sebagai penanda visual bahwa booking berhasil.

## Struktur Project

```
lib/
├── main.dart                      # halaman Beranda
├── jadwalPage.dart                # halaman Jadwal
├── providers/
│   └── booking_provider.dart      # BookingProvider, kelola state tutor & booking
└── widgets/
    └── kartuJadwal.dart           # widget kartu sesi pada halaman Jadwal
assets/
└── ...                            # foto masing-masing tutor
```

## Rencana Pengembangan

Selain pemesanan tutor, aplikasi ini direncanakan memiliki fitur presensi sesi les. Alurnya dimulai dari pemesanan tutor, penjadwalan sesi, pencatatan kehadiran, hingga rekap riwayat belajar siswa.

## Cara Menjalankan

```
flutter pub get
flutter run -d chrome
```

## Pengembang

Rahmat Riyadi (2409106074)
Informatika, Universitas Mulawarman