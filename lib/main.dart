import 'package:flutter/material.dart';

void main() {
  runApp(const BookingLesPrivatApp());
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

// Data dummy tutor: menyimpan informasi nama, mapel, harga, dan warna foto placeholder untuk tiap tutor.
class TutorData {
  final String nama;
  final String mapel;
  final String harga;
  final Color warnaFoto;

  const TutorData({
    required this.nama,
    required this.mapel,
    required this.harga,
    required this.warnaFoto,
  });
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy daftar tutor yang ditampilkan di halaman Home.
    final List<TutorData> daftarTutor = [
      const TutorData(
        nama: 'Andi Pratama',
        mapel: 'Matematika SMA',
        harga: 'Rp75.000 / sesi',
        warnaFoto: Color(0xFFB3C7F7),
      ),
      const TutorData(
        nama: 'Siti Nurhaliza',
        mapel: 'Bahasa Inggris',
        harga: 'Rp65.000 / sesi',
        warnaFoto: Color(0xFFF7C6B3),
      ),
      const TutorData(
        nama: 'Budi Santoso',
        mapel: 'Fisika SMA',
        harga: 'Rp80.000 / sesi',
        warnaFoto: Color(0xFFB3F7C6),
      ),
      const TutorData(
        nama: 'Rina Wulandari',
        mapel: 'Kimia SMA',
        harga: 'Rp70.000 / sesi',
        warnaFoto: Color(0xFFF7E3B3),
      ),
      const TutorData(
        nama: 'Dedi Firmansyah',
        mapel: 'Bahasa Indonesia',
        harga: 'Rp60.000 / sesi',
        warnaFoto: Color(0xFFD7B3F7),
      ),
    ];

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
                        // TextField: tempat pengguna mengetik kata kunci nama tutor atau mata pelajaran.
                        child: TextField(
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
                // Column: menumpuk seluruh kartu tutor dari data dummy secara vertikal berurutan.
                Column(
                  children: daftarTutor
                      .map((tutor) => _buildKartuTutor(tutor))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
      // Container: bingkai bottom navigation bar dengan latar putih dan bayangan tipis di bagian atas.
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        // Row: mensejajarkan tiga menu navigasi Beranda, Jadwal, dan Profil secara horizontal.
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildMenuNavigasi(Icons.home, 'Beranda'),
            _buildMenuNavigasi(Icons.calendar_today, 'Jadwal'),
            _buildMenuNavigasi(Icons.person, 'Profil'),
          ],
        ),
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
          // Container: kotak foto placeholder tutor berwarna solid dengan sudut membulat.
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: tutor.warnaFoto,
              borderRadius: BorderRadius.circular(12),
            ),
            // Icon: ikon orang sebagai placeholder foto tutor karena belum memakai gambar asli.
            child: const Icon(Icons.person, color: Colors.white, size: 36),
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
                // Container: dibentuk menyerupai tombol "Booking Sekarang" berwarna aksen dengan sudut membulat.
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A5BA0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  // Text: label "Booking Sekarang" pada tombol, statis tanpa aksi tap.
                  child: const Text(
                    'Booking Sekarang',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
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

  // Widget menu navigasi bawah: dibangun dari Column berisi Icon dan Text untuk satu menu.
  Widget _buildMenuNavigasi(IconData icon, String label) {
    // Column: menumpuk ikon di atas label teks untuk satu item menu navigasi.
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Icon: simbol visual menu navigasi, membedakan Beranda, Jadwal, dan Profil.
        Icon(icon, color: const Color(0xFF3A5BA0)),
        // SizedBox: jarak kecil antara ikon dan label teks menu di bawahnya.
        const SizedBox(height: 4),
        // Text: nama menu navigasi (Beranda/Jadwal/Profil) yang tampil di bawah ikon.
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF3A5BA0)),
        ),
      ],
    );
  }
}
