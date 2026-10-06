import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:posttest1_booking_les_privat/jadwalPage.dart';
import 'package:posttest1_booking_les_privat/providers/booking_provider.dart';

void main() {
  runApp(
    // ChangeNotifierProvider: bikin dan sediain satu instance BookingProvider
    // ke seluruh widget di bawahnya, jadi Home dan Jadwal bisa akses state yang sama
    ChangeNotifierProvider(
      create: (_) => BookingProvider(),
      child: const BookingLesPrivatApp(),
    ),
  );
}

// Kelas utama aplikasi Booking Les Privat, titik masuk yang dijalankan oleh fungsi main().
class BookingLesPrivatApp extends StatelessWidget {
  const BookingLesPrivatApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp: bungkus akar aplikasi Booking Les Privat, atur judul, tema warna, dan halaman awal (HomePage).
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

// HomePage diubah dari StatelessWidget jadi StatefulWidget, soalnya butuh setState()
// buat searchQuery. Ini state lokal yang cuma dipakai halaman ini sendiri, beda
// sama data booking yang dikelola bareng-bareng pakai BookingProvider
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
    // context.watch bikin HomePage ikut rebuild tiap kali BookingProvider berubah
    final bookingProvider = context.watch<BookingProvider>();

    // filter daftar tutor sesuai searchQuery, dicocokin ke nama atau mapel
    final daftarTutor = bookingProvider.daftarTutor.where((tutor) {
      final keyword = searchQuery.toLowerCase();
      return tutor.nama.toLowerCase().contains(keyword) ||
          tutor.mapel.toLowerCase().contains(keyword);
    }).toList();

    // Scaffold: kerangka halaman Home, menampung appBar judul, body daftar tutor, dan bottomNavigationBar.
    return Scaffold(
      appBar: AppBar(
        // Text: judul "Booking Les Privat" yang tampil di header appBar halaman Home.
        title: const Text(
          'Booking Les Privat',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF3A5BA0),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      // SafeArea: menjaga search bar dan daftar tutor tidak tertutup status bar atau notch layar.
      body: SafeArea(
        // SingleChildScrollView: mengizinkan halaman Home discroll agar seluruh kartu tutor tetap bisa dilihat.
        child: SingleChildScrollView(
          // Padding: memberi jarak 16 di sekeliling search bar, judul section, dan daftar kartu tutor.
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            // Column: menyusun search bar, judul "Tutor Tersedia", dan daftar kartu tutor secara vertikal.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container: bingkai search bar dengan latar putih dan sudut membulat.
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  // Row: menempatkan kolom pencarian dan ikon search berdampingan dalam satu baris.
                  child: Row(
                    children: [
                      // Expanded: melebarkan kolom pencarian mengisi sisa ruang di samping ikon search.
                      Expanded(
                        // TextField: tempat pengguna mengetik kata kunci, onChanged update searchQuery lewat setState
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
                      // Icon: ikon kaca pembesar penanda kolom di sampingnya adalah fitur pencarian.
                      const Icon(Icons.search, color: Color(0xFF3A5BA0)),
                    ],
                  ),
                ),
                // SizedBox: jarak kosong antara search bar dan judul section "Tutor Tersedia".
                const SizedBox(height: 24),
                // Text: judul section yang menandai awal daftar kartu tutor di bawahnya.
                const Text(
                  'Tutor Tersedia',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF222222),
                  ),
                ),
                // SizedBox: jarak kosong antara judul section dan kartu tutor pertama.
                const SizedBox(height: 12),
                // kalau hasil pencarian kosong, kasih tau usernya daripada nampilin kosong aja
                if (daftarTutor.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      'Tutor tidak ditemukan',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                else
                  // Column: menumpuk seluruh kartu tutor hasil filter secara vertikal berurutan.
                  Column(
                    children:
                        daftarTutor.map((tutor) => _buildKartuTutor(tutor)).toList(),
                  ),
              ],
            ),
          ),
        ),
      ),
      // nav bawah Home, index 0 artinya tab Beranda yang lagi aktif
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        selectedIndex: 0,
        onDestinationSelected: (index) {
          // kalau pencet Jadwal, buka halaman JadwalPage di atas Home
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const JadwalPage()),
            );
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Beranda'),
          NavigationDestination(
            icon: Icon(Icons.calendar_today),
            label: 'Jadwal',
          ),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  // Widget kartu tutor: dibangun dari Container, Text, dan Icon untuk menampilkan info satu tutor.
  Widget _buildKartuTutor(TutorData tutor) {
    // Container: bingkai satu kartu tutor dengan latar putih dan sudut membulat.
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      // Row: menempatkan foto placeholder di kiri dan info tutor di kanan secara berdampingan.
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image.asset: foto tutor, ambil dari folder assets
          Image.asset(
            tutor.imagePath,
            width: 70,
            height: 70,
            fit: BoxFit.cover,
          ),
          // SizedBox: jarak horizontal antara foto placeholder dan kolom informasi tutor.
          const SizedBox(width: 12),
          // Expanded: melebarkan kolom info tutor mengisi sisa ruang di samping foto placeholder.
          Expanded(
            // Column: menumpuk nama, mapel, harga, dan tombol booking tutor secara vertikal.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text: menampilkan nama tutor dengan gaya tebal agar menonjol di kartu.
                Text(
                  tutor.nama,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                // SizedBox: jarak kecil antara nama tutor dan mapel yang diajarkan.
                const SizedBox(height: 4),
                // Text: menampilkan mapel yang diajarkan tutor dengan warna abu-abu, lebih kecil dari nama.
                Text(
                  tutor.mapel,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                // SizedBox: jarak kecil antara mapel dan harga per sesi.
                const SizedBox(height: 6),
                // Text: menampilkan harga per sesi tutor dengan warna aksen tema agar mudah dilihat.
                Text(
                  tutor.harga,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3A5BA0),
                    fontSize: 14,
                  ),
                ),
                // SizedBox: jarak vertikal antara harga dan tombol booking di bawahnya.
                const SizedBox(height: 10),
                // GestureDetector: biar Container di bawah ini bisa dipencet kayak tombol
                GestureDetector(
                  onTap: () {
                    // context.read dipake di dalam callback, cuma manggil fungsi sekali
                    // (beda sama context.watch yang dipake buat dengerin terus-terusan)
                    context.read<BookingProvider>().tambahSesi(tutor.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${tutor.nama} ditambahkan ke Jadwal'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  // Container: dibentuk menyerupai tombol "Booking Sekarang" berwarna aksen dengan sudut membulat.
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3A5BA0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    // Text: label "Booking Sekarang" pada tombol.
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