import 'package:flutter/material.dart';
import 'package:posttest1_booking_les_privat/widgets/kartuJadwal.dart';

class JadwalPage extends StatelessWidget {
  const JadwalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Jadwal Les',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF3A5BA0),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      // sementara isinya teks dulu, nanti diganti daftar jadwal
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // judul section
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: Text(
                'Sesi yang Mau Dibooking',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF222222),
                ),
              ),
            ),
            // Expanded biar Stack ngisi sisa layar di bawah judul
            Expanded(
              child: Stack(
                children: [
                  // lapisan belakang: daftar kartu yang bisa discroll
                  SingleChildScrollView(
                    child: Padding(
                      // bottom 120 biar kartu terakhir gak ketutup panel total
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 120,
                      ),
                      child: Column(
                        children: const [
                          KartuJadwal(
                            nama: 'Andi Pratama',
                            mapel: 'Matematika SMA',
                            harga: 'Rp75.000 / sesi',
                          ),
                          SizedBox(height: 16),
                          KartuJadwal(
                            nama: 'Siti Nurhaliza',
                            mapel: 'Bahasa Inggris',
                            harga: 'Rp65.000 / sesi',
                          ),
                          SizedBox(height: 16),
                          KartuJadwal(
                            nama: 'Budi Santoso',
                            mapel: 'Fisika SMA',
                            harga: 'Rp80.000 / sesi',
                          ),
                          SizedBox(height: 16),
                          KartuJadwal(
                            nama: 'Rina Wulandari',
                            mapel: 'Kimia SMA',
                            harga: 'Rp70.000 / sesi',
                          ),
                        ],
                      ),
                    ),
                  ),
                  // lapisan depan: panel total, dikunci di bawah Stack
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        // bayangan ke atas biar panelnya kayak ngambang
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 10,
                            offset: const Offset(0, -3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Rp290.000',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF3A5BA0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          // flex 2 artinya tombol dapet jatah lebar 2x lipat dari total
                          Expanded(
                            flex: 2,
                            child: SizedBox(
                              height: 46,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3A5BA0),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.event_available, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'Konfirmasi Booking',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // nav bawah, index 1 artinya tab Jadwal yang lagi aktif
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        selectedIndex: 1,
        onDestinationSelected: (index) {
          // kalau pencet Beranda, tutup halaman ini biar balik ke Home
          if (index == 0) {
            Navigator.pop(context);
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today),
            label: 'Jadwal',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}