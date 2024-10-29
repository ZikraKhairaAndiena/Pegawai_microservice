import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/model_pegawai.dart'; // Import untuk memformat tanggal

class PageDetailPegawai extends StatelessWidget {
  final Datum pegawai;

  const PageDetailPegawai({Key? key, required this.pegawai}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Pegawai'),
        backgroundColor: Colors.greenAccent[300], // Warna biru pastel
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.greenAccent[100]!, Colors.white], // Gradasi ringan
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Tambahkan SingleChildScrollView di sini
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0), // Membuat sudut card menjadi melengkung
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Nama:', pegawai.namaPegawai, Icons.person),
                  _buildDivider(),
                  _buildDetailRow('Email:', pegawai.email, Icons.email),
                  _buildDivider(),
                  _buildDetailRow('Tanggal Lahir:', DateFormat('dd MMMM yyyy').format(pegawai.tglLahir), Icons.calendar_today),
                  _buildDivider(),
                  _buildDetailRow('Jenis Kelamin:', pegawai.jenisKelamin, Icons.transgender),
                  _buildDivider(),
                  _buildDetailRow('No HP:', pegawai.noHp, Icons.phone),
                  _buildDivider(),
                  _buildDetailRow('Alamat:', pegawai.alamat, Icons.home),
                  _buildDivider(),
                  _buildDetailRow('Status:', pegawai.status, Icons.check_circle),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.greenAccent[800], size: 30), // Ikon untuk detail
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.greenAccent[800], // Warna label biru pastel
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(fontSize: 16, color: Colors.black87), // Teks lebih gelap untuk keterbacaan yang lebih baik
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey[300], // Warna pemisah yang lebih lembut
      thickness: 1,
      height: 20, // Jarak antara pemisah
    );
  }
}
