import 'package:flutter/material.dart';

class KartuJadwal extends StatelessWidget {
  // data yang dikirim dari JadwalPage, biar tiap kartu isinya beda
  final String nama;
  final String mapel;
  final String harga;
  final String imagePath;
  final int jumlahSesi; // jumlah sesi tutor ini, diambil dari BookingProvider
  final ValueChanged<int> onJumlahBerubah; // dipanggil pas input diketik ulang

  const KartuJadwal({
    super.key,
    required this.nama,
    required this.mapel,
    required this.harga,
    required this.imagePath,
    required this.jumlahSesi,
    required this.onJumlahBerubah,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Row(
        children: [
          // foto tutor dari assets
          Image.asset(
            imagePath,
            width: 70,
            height: 70,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 12),
          // info tutor, pakai Expanded biar ngisi ruang tengah
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  mapel,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Text(
                  harga,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3A5BA0),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // input jumlah sesi, keyboardnya angka. pake initialValue bukan controller
          // soalnya tiap kartu nggak butuh controller sendiri, cukup baca dari provider
          SizedBox(
            width: 48,
            height: 48,
            child: TextFormField(
              key: ValueKey('jumlah-$nama'),
              initialValue: jumlahSesi.toString(),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              // tiap user ganti angka, parse ke int terus lempar ke JadwalPage
              onChanged: (value) {
                final jumlahBaru = int.tryParse(value) ?? 0;
                onJumlahBerubah(jumlahBaru);
              },
              decoration: InputDecoration(
                hintText: '1',
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}