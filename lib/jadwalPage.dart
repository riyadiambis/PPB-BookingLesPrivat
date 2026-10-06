import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:posttest1_booking_les_privat/widgets/kartuJadwal.dart';
import 'package:posttest1_booking_les_privat/providers/booking_provider.dart';

class JadwalPage extends StatelessWidget {
  const JadwalPage({super.key});

  // popup sukses: icon centang hijau + teks, nutup sendiri abis 1.5 detik
  void _tampilkanPopupSukses(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // biar gak ketutup gara-gara user pencet luar dialog
      builder: (dialogContext) {
        // auto nutup dialognya sendiri abis 1.5 detik
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (dialogContext.mounted) {
            Navigator.of(dialogContext).pop();
          }
        });
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // lingkaran hijau isi icon centang, biar kesannya kayak checkmark sukses
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4CAF50),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Booking Berhasil!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Jadwal les kamu sudah dikonfirmasi',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // context.watch: halaman ini ikut rebuild tiap kali ada sesi yang ditambah/diubah/dihapus
    final bookingProvider = context.watch<BookingProvider>();
    final daftarBooking = bookingProvider.daftarBooking;

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
              // kalau belum ada tutor yang dipilih, kasih pesan kosong daripada layar putih polos
              child: daftarBooking.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 48,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Belum ada sesi yang dipilih.\nPencet "Booking Sekarang" di Beranda dulu yah.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Stack(
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
                              children: daftarBooking.map((tutor) {
                                final jumlah =
                                    bookingProvider.jumlahSesi[tutor.id] ?? 0;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  // key pake id tutor, biar flutter gak ketuker pas list berubah urutan/jumlah
                                  child: KartuJadwal(
                                    key: ValueKey(tutor.id),
                                    nama: tutor.nama,
                                    mapel: tutor.mapel,
                                    harga: tutor.harga,
                                    imagePath: tutor.imagePath,
                                    jumlahSesi: jumlah,
                                    // dipanggil tiap user ngetik ulang jumlah sesi di kartu ini
                                    onJumlahBerubah: (jumlahBaru) {
                                      context
                                          .read<BookingProvider>()
                                          .setJumlahSesi(tutor.id, jumlahBaru);
                                    },
                                  ),
                                );
                              }).toList(),
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
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Total',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      // total diambil dari grandTotal di provider, otomatis update
                                      Text(
                                        formatRupiah(bookingProvider.grandTotal),
                                        style: const TextStyle(
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
                                      onPressed: () {
                                        // ambil provider pake context.read, cuma manggil fungsi sekali
                                        context
                                            .read<BookingProvider>()
                                            .konfirmasiBooking();
                                        // ganti SnackBar jadi popup sukses dengan icon centang
                                        _tampilkanPopupSukses(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF3A5BA0),
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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