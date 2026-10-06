import 'package:flutter/material.dart';

// data satu tutor, dipindah ke sini (sebelumnya ada di main.dart) biar bisa dipakai provider
class TutorData {
  final String id; // id unik buat jadi key di map jumlahSesi
  final String nama;
  final String mapel;
  final String harga; // teks harga buat ditampilin, misal "Rp75.000 / sesi"
  final int hargaAngka; // harga dalam angka, buat dihitung total
  final String imagePath;

  const TutorData({
    required this.id,
    required this.nama,
    required this.mapel,
    required this.harga,
    required this.hargaAngka,
    required this.imagePath,
  });
}

// BookingProvider: state management pake konsep Provider dari modul.
// Nyimpen daftar tutor dan jumlah sesi yang mau dibooking, dipakai bareng
// sama HomePage (buat nambahin booking) dan JadwalPage (buat nampilin & edit)
class BookingProvider extends ChangeNotifier {
  // data dummy tutor, sama kayak yang dulu ada di HomePage
  final List<TutorData> daftarTutor = const [
    TutorData(
      id: 't1',
      nama: 'Bahlil Lahadalia',
      mapel: 'Matematika SMA',
      harga: 'Rp75.000 / sesi',
      hargaAngka: 75000,
      imagePath: 'assets/bahlil.png',
    ),
    TutorData(
      id: 't2',
      nama: 'Puan Maharani',
      mapel: 'Bahasa Inggris',
      harga: 'Rp65.000 / sesi',
      hargaAngka: 65000,
      imagePath: 'assets/puan maharani.png',
    ),
    TutorData(
      id: 't3',
      nama: 'Megawati Soekarnoputri',
      mapel: 'Fisika SMA',
      harga: 'Rp80.000 / sesi',
      hargaAngka: 80000,
      imagePath: 'assets/megawati.png',
    ),
    TutorData(
      id: 't4',
      nama: 'Mulyono',
      mapel: 'Kimia SMA',
      harga: 'Rp70.000 / sesi',
      hargaAngka: 70000,
      imagePath: 'assets/pigai.png',
    ),
    TutorData(
      id: 't5',
      nama: 'Pigai',
      mapel: 'Bahasa Indonesia',
      harga: 'Rp60.000 / sesi',
      hargaAngka: 60000,
      imagePath: 'assets/image.png',
    ),
  ];

  // nyimpen jumlah sesi tiap tutor yang mau dibooking, key-nya id tutor.
  // kalau tutor belum dipilih, dia nggak ada di map ini sama sekali
  final Map<String, int> jumlahSesi = {};

  // daftar tutor yang udah dipilih (jumlah sesinya lebih dari 0), ini yang
  // ditampilin di halaman Jadwal sebagai "keranjang" booking
  List<TutorData> get daftarBooking =>
      daftarTutor.where((t) => (jumlahSesi[t.id] ?? 0) > 0).toList();

  // total harga dari semua sesi yang udah dipilih
  int get grandTotal {
    int total = 0;
    for (final tutor in daftarBooking) {
      total += tutor.hargaAngka * (jumlahSesi[tutor.id] ?? 0);
    }
    return total;
  }

  // dipanggil pas pencet "Booking Sekarang" di Home, nambah 1 sesi buat tutor itu
  void tambahSesi(String tutorId) {
    jumlahSesi[tutorId] = (jumlahSesi[tutorId] ?? 0) + 1;
    notifyListeners(); // kasih tau widget yang dengerin kalau state berubah
  }

  // dipanggil pas user ngetik ulang jumlah sesi di kolom input halaman Jadwal
  void setJumlahSesi(String tutorId, int jumlah) {
    if (jumlah <= 0) {
      jumlahSesi.remove(tutorId); // jumlah 0 artinya dibatalin dari booking
    } else {
      jumlahSesi[tutorId] = jumlah;
    }
    notifyListeners();
  }

  // dipanggil pas pencet "Konfirmasi Booking", ngosongin keranjang
  void konfirmasiBooking() {
    jumlahSesi.clear();
    notifyListeners();
  }
}

// helper format angka jadi teks rupiah pake titik ribuan, misal 150000 jadi "Rp150.000"
String formatRupiah(int angka) {
  final teks = angka.toString();
  final buffer = StringBuffer();
  for (int i = 0; i < teks.length; i++) {
    final posisiDariKanan = teks.length - i;
    buffer.write(teks[i]);
    if (posisiDariKanan > 1 && posisiDariKanan % 3 == 1) {
      buffer.write('.');
    }
  }
  return 'Rp$buffer';
}