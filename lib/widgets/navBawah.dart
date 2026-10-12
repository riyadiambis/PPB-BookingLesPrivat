import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:posttest1_booking_les_privat/jadwalPage.dart';
import 'package:posttest1_booking_les_privat/profilPage.dart';
import 'package:posttest1_booking_les_privat/providers/booking_provider.dart';

// widget nav bawah yang dipake bareng di Beranda, Jadwal, dan Profil biar gak nulis ulang
class NavBawah extends StatelessWidget {
  final int indexAktif; // 0 Beranda, 1 Jadwal, 2 Profil

  const NavBawah({super.key, required this.indexAktif});

  // ngatur pindah halaman sesuai tab yang dipencet
  void _pindahHalaman(BuildContext context, int index) {
    if (index == indexAktif) return; // lagi di halaman itu, gak usah ngapa-ngapain

    // balik ke Beranda: tutup semua halaman sampe tinggal halaman pertama
    if (index == 0) {
      Navigator.popUntil(context, (route) => route.isFirst);
      return;
    }

    final Widget halamanTujuan =
        index == 1 ? const JadwalPage() : const ProfilPage();
    final rute = MaterialPageRoute(builder: (context) => halamanTujuan);

    // dari Beranda pake push, dari Jadwal ke Profil (atau sebaliknya) pake
    // pushReplacement biar halamannya gak numpuk-numpuk
    if (indexAktif == 0) {
      Navigator.push(context, rute);
    } else {
      Navigator.pushReplacement(context, rute);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Consumer<BookingProvider>: cuma nav bawah ini yang rebuild pas isi keranjang berubah,
    // dipake buat update angka badge di tab Jadwal
    return Consumer<BookingProvider>(
      builder: (context, booking, child) {
        // NavigationBar: menu navigasi bawah
        return NavigationBar(
          backgroundColor: Colors.white,
          selectedIndex: indexAktif,
          onDestinationSelected: (index) => _pindahHalaman(context, index),
          destinations: [
            // NavigationDestination: tab Beranda
            const NavigationDestination(
              // Icon: ikon rumah
              icon: Icon(Icons.home),
              label: 'Beranda',
            ),
            // NavigationDestination: tab Jadwal
            NavigationDestination(
              // Badge: bulatan merah berisi jumlah sesi di keranjang, muncul kalau ada isinya
              icon: Badge(
                isLabelVisible: booking.totalSesiKeranjang > 0,
                // Text: angka di dalam badge
                label: Text('${booking.totalSesiKeranjang}'),
                // Icon: ikon kalender
                child: const Icon(Icons.calendar_today),
              ),
              label: 'Jadwal',
            ),
            // NavigationDestination: tab Profil
            const NavigationDestination(
              // Icon: ikon orang
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        );
      },
    );
  }
}
