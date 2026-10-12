import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:posttest1_booking_les_privat/providers/booking_provider.dart';
import 'package:posttest1_booking_les_privat/providers/riwayat_provider.dart';
import 'package:posttest1_booking_les_privat/widgets/navBawah.dart';

// halaman Profil: data pengguna, statistik, dan riwayat booking dari RiwayatProvider
class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  // fungsi bikin satu kotak statistik (total sesi / total pengeluaran)
  Widget _buildKotakStatistik(IconData ikon, String label, String nilai) {
    // Expanded: biar dua kotak statistik bagi lebar sama rata
    return Expanded(
      // Container: kotak putih statistik
      child: Container(
        padding: const EdgeInsets.all(14),
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
        // Column: ikon, nilai, dan label ke bawah
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon: ikon penanda jenis statistik
            Icon(ikon, color: const Color(0xFF3A5BA0)),
            // SizedBox: jarak ikon dan nilai
            const SizedBox(height: 8),
            // Text: nilai statistik
            Text(
              nilai,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            // Text: nama statistik
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  // fungsi bikin satu kartu riwayat booking
  Widget _buildKartuRiwayat(RiwayatBooking riwayat) {
    // Container: bingkai kartu riwayat
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      // Row: foto, info riwayat, dan label status sebaris
      child: Row(
        children: [
          // Image.asset: foto tutor yang dibooking
          Image.asset(
            riwayat.imagePath,
            width: 56,
            height: 56,
            fit: BoxFit.cover,
          ),
          // SizedBox: jarak foto dan info
          const SizedBox(width: 12),
          // Expanded: info riwayat ngisi ruang tengah
          Expanded(
            // Column: nama, mapel, dan rincian sesi
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text: nama tutor
                Text(
                  riwayat.namaTutor,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                // Text: mapel
                Text(
                  riwayat.mapel,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                // SizedBox: jarak mapel dan rincian
                const SizedBox(height: 4),
                // Text: jumlah sesi dan total harga riwayat ini
                Text(
                  '${riwayat.jumlahSesi} sesi | ${formatRupiah(riwayat.totalHarga)}',
                  style: const TextStyle(
                    color: Color(0xFF3A5BA0),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          // Container: label status, nanti bisa dipakai buat fitur presensi
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(6),
            ),
            // Text: tulisan status
            child: const Text(
              'Terjadwal',
              style: TextStyle(
                color: Color(0xFF2E7D32),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold: kerangka halaman Profil
    return Scaffold(
      // AppBar: header atas halaman Profil
      appBar: AppBar(
        // Text: judul appBar
        title: const Text(
          'Profil',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF3A5BA0),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      // SafeArea: jaga isi halaman biar gak ketutup status bar
      body: SafeArea(
        // SingleChildScrollView: halaman bisa discroll kalau riwayatnya banyak
        child: SingleChildScrollView(
          // Padding: jarak 16 di sekeliling isi halaman
          child: Padding(
            padding: const EdgeInsets.all(16),
            // Consumer<RiwayatProvider>: dengerin RiwayatProvider, jadi riwayat
            // langsung muncul di sini abis konfirmasi booking di halaman Jadwal
            child: Consumer<RiwayatProvider>(
              builder: (context, riwayat, child) {
                // Column: kartu pengguna, statistik, dan daftar riwayat
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Container: kartu identitas pengguna warna biru
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3A5BA0),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      // Row: foto profil dan nama sebaris
                      child: const Row(
                        children: [
                          // CircleAvatar: foto profil bulat
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            // Icon: ikon orang sebagai pengganti foto
                            child: Icon(
                              Icons.person,
                              size: 34,
                              color: Color(0xFF3A5BA0),
                            ),
                          ),
                          // SizedBox: jarak foto dan nama
                          SizedBox(width: 14),
                          // Column: nama dan status pengguna
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text: nama pengguna
                              Text(
                                'Rahmat Riyadi',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // SizedBox: jarak nama dan status
                              SizedBox(height: 4),
                              // Text: status pengguna
                              Text(
                                'Siswa Les Privat',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // SizedBox: jarak kartu identitas dan statistik
                    const SizedBox(height: 16),
                    // Row: dua kotak statistik sebaris
                    Row(
                      children: [
                        _buildKotakStatistik(
                          Icons.event_note,
                          'Total Sesi',
                          '${riwayat.totalSesi} sesi',
                        ),
                        // SizedBox: jarak antar kotak statistik
                        const SizedBox(width: 12),
                        _buildKotakStatistik(
                          Icons.payments,
                          'Total Pengeluaran',
                          formatRupiah(riwayat.totalPengeluaran),
                        ),
                      ],
                    ),
                    // SizedBox: jarak statistik dan judul riwayat
                    const SizedBox(height: 24),
                    // Text: judul section riwayat
                    const Text(
                      'Riwayat Booking',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF222222),
                      ),
                    ),
                    // SizedBox: jarak judul dan daftar riwayat
                    const SizedBox(height: 12),
                    if (riwayat.daftarRiwayat.isEmpty)
                      // Text: pesan kalau belum ada riwayat
                      const Text(
                        'Belum ada booking yang dikonfirmasi.',
                        style: TextStyle(color: Colors.grey),
                      )
                    else
                      // Column: numpuk kartu riwayat ke bawah
                      Column(
                        children: riwayat.daftarRiwayat
                            .map((item) => _buildKartuRiwayat(item))
                            .toList(),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      // NavBawah: nav bawah buatan sendiri, index 2 artinya tab Profil aktif
      bottomNavigationBar: const NavBawah(indexAktif: 2),
    );
  }
}
