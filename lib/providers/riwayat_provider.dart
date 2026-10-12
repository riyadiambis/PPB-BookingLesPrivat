import 'package:flutter/material.dart';
import 'package:posttest1_booking_les_privat/providers/booking_provider.dart';

// data satu riwayat booking yang udah dikonfirmasi
class RiwayatBooking {
  final String namaTutor;
  final String mapel;
  final String imagePath;
  final int jumlahSesi;
  final int totalHarga;

  const RiwayatBooking({
    required this.namaTutor,
    required this.mapel,
    required this.imagePath,
    required this.jumlahSesi,
    required this.totalHarga,
  });
}

// RiwayatProvider: provider kedua, nyimpen booking yang udah dikonfirmasi.
// Dipisah dari BookingProvider biar tugasnya jelas (keranjang vs riwayat),
// makanya di main.dart dua-duanya didaftarin lewat MultiProvider
class RiwayatProvider extends ChangeNotifier {
  final List<RiwayatBooking> daftarRiwayat = [];

  // total semua sesi yang pernah dibooking
  int get totalSesi =>
      daftarRiwayat.fold(0, (total, riwayat) => total + riwayat.jumlahSesi);

  // total uang yang udah dikeluarin buat booking
  int get totalPengeluaran =>
      daftarRiwayat.fold(0, (total, riwayat) => total + riwayat.totalHarga);

  // dipanggil pas konfirmasi booking, isi keranjang disalin ke riwayat
  void simpanDariKeranjang(
    List<TutorData> daftarBooking,
    Map<String, int> jumlahSesi,
  ) {
    for (final tutor in daftarBooking) {
      final jumlah = jumlahSesi[tutor.id] ?? 0;
      daftarRiwayat.add(
        RiwayatBooking(
          namaTutor: tutor.nama,
          mapel: tutor.mapel,
          imagePath: tutor.imagePath,
          jumlahSesi: jumlah,
          totalHarga: tutor.hargaAngka * jumlah,
        ),
      );
    }
    notifyListeners(); // biar halaman Profil langsung nampilin riwayat baru
  }
}
