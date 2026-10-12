import 'package:flutter/material.dart';

// data satu tutor, sekarang ada sisaSlot (mirip product.stock di modul)
class TutorData {
  final String id; // id unik buat jadi key di map jumlahSesi
  final String nama;
  final String mapel;
  final String harga; // teks harga buat ditampilin, misal "Rp75.000 / sesi"
  final int hargaAngka; // harga dalam angka, buat dihitung total
  final String imagePath;
  int sisaSlot; // kuota sesi tutor, gak final soalnya bakal berkurang pas dibooking

  TutorData({
    required this.id,
    required this.nama,
    required this.mapel,
    required this.harga,
    required this.hargaAngka,
    required this.imagePath,
    required this.sisaSlot,
  });
}

// BookingProvider: class yang extends ChangeNotifier, jadi bisa ngasih tau
// widget yang dengerin (Consumer / context.watch) tiap kali state berubah.
// Nyimpen data tutor + keranjang booking, dipakai bareng Beranda, Jadwal, dan NavBawah
class BookingProvider extends ChangeNotifier {
  // data dummy tutor, sekarang tiap tutor punya kuota slot
  final List<TutorData> daftarTutor = [
    TutorData(
      id: 't1',
      nama: 'Bahlil Lahadalia',
      mapel: 'Matematika SMA',
      harga: 'Rp75.000 / sesi',
      hargaAngka: 75000,
      imagePath: 'assets/bahlil.png',
      sisaSlot: 3,
    ),
    TutorData(
      id: 't2',
      nama: 'Puan Maharani',
      mapel: 'Bahasa Inggris',
      harga: 'Rp65.000 / sesi',
      hargaAngka: 65000,
      imagePath: 'assets/puan maharani.png',
      sisaSlot: 5,
    ),
    TutorData(
      id: 't3',
      nama: 'Megawati Soekarnoputri',
      mapel: 'Fisika SMA',
      harga: 'Rp80.000 / sesi',
      hargaAngka: 80000,
      imagePath: 'assets/megawati.png',
      sisaSlot: 2,
    ),
    TutorData(
      id: 't4',
      nama: 'Mulyono',
      mapel: 'Kimia SMA',
      harga: 'Rp70.000 / sesi',
      hargaAngka: 70000,
      imagePath: 'assets/pigai.png',
      sisaSlot: 4,
    ),
    TutorData(
      id: 't5',
      nama: 'Pigai',
      mapel: 'Bahasa Indonesia',
      harga: 'Rp60.000 / sesi',
      hargaAngka: 60000,
      imagePath: 'assets/image.png',
      sisaSlot: 3,
    ),
  ];

  // jumlah sesi tiap tutor di keranjang, key-nya id tutor (mirip cartQuantities di modul)
  final Map<String, int> jumlahSesi = {};

  // tutor yang ada di keranjang (jumlah sesinya lebih dari 0), ditampilin di halaman Jadwal
  List<TutorData> get daftarBooking =>
      daftarTutor.where((t) => (jumlahSesi[t.id] ?? 0) > 0).toList();

  // total semua sesi di keranjang, dipakai buat angka badge di nav bawah
  int get totalSesiKeranjang =>
      jumlahSesi.values.fold(0, (total, jumlah) => total + jumlah);

  // total harga otomatis, pake fold kayak grandTotal di modul
  int get grandTotal => daftarTutor.fold(0, (total, tutor) {
        return total + tutor.hargaAngka * (jumlahSesi[tutor.id] ?? 0);
      });

  // mirip addToCart() di modul: kalau slot habis langsung return,
  // kalau masih ada slotnya dikurangin terus jumlah sesi di keranjang nambah 1
  void tambahSesi(TutorData tutor) {
    if (tutor.sisaSlot == 0) return;

    tutor.sisaSlot--;
    jumlahSesi[tutor.id] = (jumlahSesi[tutor.id] ?? 0) + 1;
    notifyListeners(); // kasih tau widget yang dengerin kalau state berubah
  }

  // kebalikan tambahSesi: sesi dikurangin 1 dan slotnya dibalikin ke tutor
  void kurangiSesi(TutorData tutor) {
    final jumlah = jumlahSesi[tutor.id] ?? 0;
    if (jumlah == 0) return;

    tutor.sisaSlot++;
    if (jumlah == 1) {
      jumlahSesi.remove(tutor.id); // tinggal 1 terus dikurangin, keluar dari keranjang
    } else {
      jumlahSesi[tutor.id] = jumlah - 1;
    }
    notifyListeners();
  }

  // pas konfirmasi keranjang dikosongin, slot gak dibalikin karena udah kepake beneran
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