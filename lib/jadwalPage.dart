import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:posttest1_booking_les_privat/widgets/kartuJadwal.dart';
import 'package:posttest1_booking_les_privat/widgets/navBawah.dart';
import 'package:posttest1_booking_les_privat/providers/booking_provider.dart';
import 'package:posttest1_booking_les_privat/providers/riwayat_provider.dart';

class JadwalPage extends StatelessWidget {
  const JadwalPage({super.key});

  // popup sukses: icon centang hijau + total bayar, nutup sendiri abis 1.5 detik
  void _tampilkanPopupSukses(BuildContext context, int total) {
    showDialog(
      context: context,
      barrierDismissible: false, // biar gak ketutup gara-gara pencet luar dialog
      builder: (dialogContext) {
        // auto nutup dialognya sendiri abis 1.5 detik
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (dialogContext.mounted) {
            Navigator.of(dialogContext).pop();
          }
        });
        // Dialog: kotak popup di tengah layar dengan sudut membulat
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          // Padding: jarak dalam popup
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
            // Column: nyusun ikon centang, judul, dan keterangan ke bawah
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Container: lingkaran hijau tempat ikon centang
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4CAF50),
                    shape: BoxShape.circle,
                  ),
                  // Icon: tanda centang putih
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                // SizedBox: jarak antara ikon dan judul
                const SizedBox(height: 16),
                // Text: judul popup
                const Text(
                  'Booking Berhasil!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // SizedBox: jarak antara judul dan total
                const SizedBox(height: 6),
                // Text: total bayar yang diambil pake context.read sebelum keranjang dikosongin
                Text(
                  'Total bayar ${formatRupiah(total)}\nCek riwayatnya di halaman Profil',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
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
    // context.watch: halaman ini ikut rebuild tiap kali isi keranjang berubah
    final bookingProvider = context.watch<BookingProvider>();
    final daftarBooking = bookingProvider.daftarBooking;

    // Scaffold: kerangka halaman Jadwal
    return Scaffold(
      // AppBar: header atas halaman Jadwal
      appBar: AppBar(
        // Text: judul appBar
        title: const Text(
          'Jadwal Les',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF3A5BA0),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      // SafeArea: jaga isi halaman biar gak ketutup status bar
      body: SafeArea(
        // Column: judul section di atas, isi keranjang di bawahnya
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padding: jarak di sekitar judul section
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
              // Text: judul section
              child: Text(
                'Sesi yang Mau Dibooking',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF222222),
                ),
              ),
            ),
            // Expanded: isi keranjang ngisi sisa layar di bawah judul
            Expanded(
              // kalau keranjang kosong tampilin pesan, kalau ada isinya tampilin kartu + panel total
              child: daftarBooking.isEmpty
                  // Center: taruh pesan kosong di tengah
                  ? Center(
                      // Padding: jarak di sekitar pesan kosong
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        // Column: ikon dan teks pesan kosong
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Icon: ikon kalender abu-abu
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 48,
                              color: Colors.grey.shade400,
                            ),
                            // SizedBox: jarak antara ikon dan teks
                            const SizedBox(height: 12),
                            // Text: pesan keranjang masih kosong
                            const Text(
                              'Belum ada sesi yang dipilih.\nPencet "Booking Sekarang" di Beranda dulu yah.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    )
                  // Stack: numpuk daftar kartu (belakang) sama panel total (depan)
                  : Stack(
                      children: [
                        // SingleChildScrollView: lapisan belakang, daftar kartu bisa discroll
                        SingleChildScrollView(
                          // Padding: bottom 120 biar kartu terakhir gak ketutup panel total
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                              bottom: 120,
                            ),
                            // Column: numpuk kartu jadwal ke bawah
                            child: Column(
                              children: daftarBooking.map((tutor) {
                                final jumlah =
                                    bookingProvider.jumlahSesi[tutor.id] ?? 0;
                                // Padding: jarak antar kartu jadwal
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  // KartuJadwal: widget kartu buatan sendiri, key pake id biar gak ketuker
                                  child: KartuJadwal(
                                    key: ValueKey(tutor.id),
                                    nama: tutor.nama,
                                    mapel: tutor.mapel,
                                    harga: tutor.harga,
                                    imagePath: tutor.imagePath,
                                    jumlahSesi: jumlah,
                                    sisaSlot: tutor.sisaSlot,
                                    // pencet + : nambah sesi, slot tutor berkurang
                                    onTambah: () {
                                      context
                                          .read<BookingProvider>()
                                          .tambahSesi(tutor);
                                    },
                                    // pencet - : ngurangin sesi, slot tutor balik lagi
                                    onKurang: () {
                                      context
                                          .read<BookingProvider>()
                                          .kurangiSesi(tutor);
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        // Positioned: lapisan depan, panel total dikunci di bawah
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          // Container: panel total putih dengan bayangan ke atas
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade300,
                                  blurRadius: 10,
                                  offset: const Offset(0, -3),
                                ),
                              ],
                            ),
                            // Row: info total di kiri, tombol konfirmasi di kanan
                            child: Row(
                              children: [
                                // Expanded: bagian info total
                                Expanded(
                                  // Column: label "Total" dan nominalnya
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Text: label total
                                      const Text(
                                        'Total',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      // SizedBox: jarak label dan nominal
                                      const SizedBox(height: 4),
                                      // Text: total dari grandTotal provider, otomatis update
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
                                // SizedBox: jarak antara total dan tombol
                                const SizedBox(width: 16),
                                // Expanded: flex 2 artinya tombol dapet lebar 2x lipat
                                Expanded(
                                  flex: 2,
                                  // SizedBox: ngatur tinggi tombol
                                  child: SizedBox(
                                    height: 46,
                                    // ElevatedButton: tombol konfirmasi booking
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // context.read: ambil provider sekali aja, gak dengerin perubahan
                                        final booking =
                                            context.read<BookingProvider>();
                                        final riwayat =
                                            context.read<RiwayatProvider>();
                                        // total diambil dulu sebelum keranjang dikosongin
                                        final total = booking.grandTotal;
                                        riwayat.simpanDariKeranjang(
                                          booking.daftarBooking,
                                          booking.jumlahSesi,
                                        );
                                        booking.konfirmasiBooking();
                                        _tampilkanPopupSukses(context, total);
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
                                      // Row: ikon dan teks tombol sebaris
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Icon: ikon kalender centang
                                          Icon(Icons.event_available, size: 20),
                                          // SizedBox: jarak ikon dan teks
                                          SizedBox(width: 8),
                                          // Text: label tombol
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
      // NavBawah: nav bawah buatan sendiri, index 1 artinya tab Jadwal aktif
      bottomNavigationBar: const NavBawah(indexAktif: 1),
    );
  }
}