import 'package:flutter/material.dart';

// widget kartu satu sesi di halaman Jadwal, dipisah file biar JadwalPage gak kepanjangan
class KartuJadwal extends StatelessWidget {
  final String nama;
  final String mapel;
  final String harga;
  final String imagePath;
  final int jumlahSesi; // jumlah sesi tutor ini di keranjang, dari BookingProvider
  final int sisaSlot; // sisa kuota tutor, buat nentuin tombol + masih bisa dipencet apa nggak
  final VoidCallback onTambah; // dipanggil pas pencet +
  final VoidCallback onKurang; // dipanggil pas pencet -

  const KartuJadwal({
    super.key,
    required this.nama,
    required this.mapel,
    required this.harga,
    required this.imagePath,
    required this.jumlahSesi,
    required this.sisaSlot,
    required this.onTambah,
    required this.onKurang,
  });

  @override
  Widget build(BuildContext context) {
    // Container: bingkai kartu jadwal putih dengan sudut membulat
    return Container(
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
      // Row: foto, info tutor, dan tombol jumlah sesi sebaris
      child: Row(
        children: [
          // Image.asset: foto tutor dari assets
          Image.asset(
            imagePath,
            width: 70,
            height: 70,
            fit: BoxFit.cover,
          ),
          // SizedBox: jarak foto dan info
          const SizedBox(width: 12),
          // Expanded: info tutor ngisi ruang tengah
          Expanded(
            // Column: nama, mapel, harga, dan sisa slot ke bawah
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text: nama tutor
                Text(
                  nama,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                // SizedBox: jarak nama dan mapel
                const SizedBox(height: 4),
                // Text: mapel tutor
                Text(
                  mapel,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                // SizedBox: jarak mapel dan harga
                const SizedBox(height: 6),
                // Text: harga per sesi
                Text(
                  harga,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3A5BA0),
                    fontSize: 14,
                  ),
                ),
                // SizedBox: jarak harga dan sisa slot
                const SizedBox(height: 4),
                // Text: sisa slot, kalau 0 tulisannya jadi "Slot penuh"
                Text(
                  sisaSlot > 0 ? 'Sisa slot: $sisaSlot sesi' : 'Slot penuh',
                  style: TextStyle(
                    color: sisaSlot > 0 ? Colors.orange : Colors.red,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // SizedBox: jarak info dan tombol jumlah
          const SizedBox(width: 8),
          // Column: tombol tambah, angka, dan tombol kurang disusun atas bawah
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // IconButton: tambah 1 sesi, jadi abu-abu (onPressed null) kalau slot habis
              IconButton(
                onPressed: sisaSlot > 0 ? onTambah : null,
                icon: const Icon(Icons.add_circle),
                color: const Color(0xFF3A5BA0),
                visualDensity: VisualDensity.compact,
              ),
              // Text: jumlah sesi tutor ini di keranjang
              Text(
                '$jumlahSesi',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // IconButton: kurangi 1 sesi, kalau tinggal 1 terus dikurangin tutor keluar dari jadwal
              IconButton(
                onPressed: onKurang,
                icon: const Icon(Icons.remove_circle_outline),
                color: Colors.redAccent,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ],
      ),
    );
  }
}