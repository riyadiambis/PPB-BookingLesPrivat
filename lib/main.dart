import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:posttest1_booking_les_privat/providers/booking_provider.dart';
import 'package:posttest1_booking_les_privat/providers/riwayat_provider.dart';
import 'package:posttest1_booking_les_privat/widgets/navBawah.dart';

void main() {
  runApp(
    // MultiProvider: tempat daftarin beberapa provider sekaligus di akar aplikasi
    MultiProvider(
      providers: [
        // ChangeNotifierProvider: bikin instance BookingProvider (data tutor + keranjang booking)
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        // ChangeNotifierProvider: bikin instance RiwayatProvider (riwayat booking yang udah dikonfirmasi)
        ChangeNotifierProvider(create: (_) => RiwayatProvider()),
      ],
      child: const BookingLesPrivatApp(),
    ),
  );
}

// Kelas utama aplikasi Booking Les Privat, titik masuk yang dijalankan oleh fungsi main().
class BookingLesPrivatApp extends StatelessWidget {
  const BookingLesPrivatApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp: bungkus akar aplikasi, atur judul, tema warna, dan halaman awal (HomePage).
    return MaterialApp(
      title: 'Booking Les Privat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF3A5BA0),
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
        fontFamily: 'Roboto',
      ),
      home: const HomePage(),
    );
  }
}

// HomePage pake StatefulWidget soalnya butuh setState() buat searchQuery.
// searchQuery itu state lokal yang cuma dipakai halaman ini, beda sama data
// tutor dan keranjang yang dipakai bareng lewat BookingProvider
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // searchQuery: state lokal buat nyimpen kata kunci yang lagi diketik
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // Scaffold: kerangka halaman Home, isinya appBar, body daftar tutor, dan nav bawah.
    return Scaffold(
      // AppBar: header atas halaman Beranda warna biru
      appBar: AppBar(
        // Text: judul "Booking Les Privat" di tengah appBar
        title: const Text(
          'Booking Les Privat',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF3A5BA0),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      // SafeArea: jaga isi halaman biar gak ketutup status bar atau notch
      body: SafeArea(
        // SingleChildScrollView: halaman bisa discroll biar semua kartu tutor kelihatan
        child: SingleChildScrollView(
          // Padding: jarak 16 di sekeliling isi halaman
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            // Column: nyusun search bar, judul section, dan daftar tutor ke bawah
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container: bingkai search bar putih dengan sudut membulat
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  // Row: kolom pencarian dan ikon search sebaris
                  child: Row(
                    children: [
                      // Expanded: kolom pencarian ngisi sisa ruang di samping ikon
                      Expanded(
                        // TextField: tempat ngetik kata kunci, onChanged update searchQuery pake setState
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: 'Cari tutor atau mapel...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      // Icon: ikon kaca pembesar penanda fitur pencarian
                      const Icon(Icons.search, color: Color(0xFF3A5BA0)),
                    ],
                  ),
                ),
                // SizedBox: jarak antara search bar dan judul section
                const SizedBox(height: 24),
                // Text: judul section daftar tutor
                const Text(
                  'Tutor Tersedia',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF222222),
                  ),
                ),
                // SizedBox: jarak antara judul section dan kartu tutor pertama
                const SizedBox(height: 12),
                // Consumer<BookingProvider>: dengerin perubahan BookingProvider,
                // jadi pas slot tutor berkurang daftar ini langsung rebuild
                Consumer<BookingProvider>(
                  builder: (context, booking, child) {
                    // yang ditampilin cuma tutor yang slotnya masih ada dan cocok sama pencarian
                    final keyword = searchQuery.toLowerCase();
                    final tutorTampil = booking.daftarTutor.where((tutor) {
                      return tutor.sisaSlot > 0 &&
                          (tutor.nama.toLowerCase().contains(keyword) ||
                              tutor.mapel.toLowerCase().contains(keyword));
                    }).toList();

                    // kalau hasilnya kosong, kasih tau user daripada layar kosong
                    if (tutorTampil.isEmpty) {
                      // Padding: jarak atas bawah buat pesan kosong
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        // Text: pesan tutor gak ketemu atau slotnya udah penuh semua
                        child: Text(
                          'Tutor tidak ditemukan atau slot sudah penuh',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }

                    // Column: numpuk kartu tutor hasil filter ke bawah
                    return Column(
                      children: tutorTampil
                          .map((tutor) => _buildKartuTutor(tutor))
                          .toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      // NavBawah: widget nav bawah buatan sendiri, index 0 artinya tab Beranda aktif
      bottomNavigationBar: const NavBawah(indexAktif: 0),
    );
  }

  // fungsi bikin satu kartu tutor di Beranda
  Widget _buildKartuTutor(TutorData tutor) {
    // Container: bingkai kartu tutor putih dengan sudut membulat
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      // Row: foto di kiri, info tutor di kanan
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image.asset: foto tutor dari folder assets
          Image.asset(
            tutor.imagePath,
            width: 70,
            height: 70,
            fit: BoxFit.cover,
          ),
          // SizedBox: jarak antara foto dan info tutor
          const SizedBox(width: 12),
          // Expanded: kolom info ngisi sisa ruang di samping foto
          Expanded(
            // Column: numpuk nama, mapel, harga, sisa slot, dan tombol booking
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text: nama tutor tebal biar menonjol
                Text(
                  tutor.nama,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                // SizedBox: jarak kecil antara nama dan mapel
                const SizedBox(height: 4),
                // Text: mapel yang diajarin tutor, warna abu
                Text(
                  tutor.mapel,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                // SizedBox: jarak kecil antara mapel dan harga
                const SizedBox(height: 6),
                // Text: harga per sesi warna aksen tema
                Text(
                  tutor.harga,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3A5BA0),
                    fontSize: 14,
                  ),
                ),
                // SizedBox: jarak kecil antara harga dan sisa slot
                const SizedBox(height: 4),
                // Text: sisa kuota sesi tutor ini, berkurang tiap dibooking
                Text(
                  'Sisa slot: ${tutor.sisaSlot} sesi',
                  style: const TextStyle(color: Colors.orange, fontSize: 12),
                ),
                // SizedBox: jarak antara sisa slot dan tombol booking
                const SizedBox(height: 10),
                // GestureDetector: biar Container di bawah bisa dipencet kayak tombol
                GestureDetector(
                  onTap: () {
                    // context.read dipake di callback, cuma manggil fungsi sekali
                    // (beda sama Consumer/context.watch yang dengerin terus)
                    context.read<BookingProvider>().tambahSesi(tutor);
                    // ScaffoldMessenger: nampilin SnackBar notif kecil di bawah
                    ScaffoldMessenger.of(context).showSnackBar(
                      // SnackBar: notif tutor masuk ke Jadwal
                      SnackBar(
                        // Text: isi notif
                        content: Text('${tutor.nama} ditambahkan ke Jadwal'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  // Container: dibentuk kayak tombol "Booking Sekarang"
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3A5BA0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    // Text: label tombol
                    child: const Text(
                      'Booking Sekarang',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}