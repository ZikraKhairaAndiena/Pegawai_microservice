import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../model/model_pegawai.dart';

class PageEditPegawai extends StatefulWidget {
  final Datum pegawai;

  const PageEditPegawai({required this.pegawai});

  @override
  _PageEditPegawaiState createState() => _PageEditPegawaiState();
}

class _PageEditPegawaiState extends State<PageEditPegawai> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController namaController = TextEditingController();
  TextEditingController tglLahirController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController noHpController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? selectedJenisKelamin;
  String? selectedStatus;

  final String baseUrl = 'http://172.21.96.1:7070';

  @override
  void initState() {
    super.initState();
    namaController.text = widget.pegawai.namaPegawai;
    tglLahirController.text = widget.pegawai.tglLahir.toIso8601String().substring(0, 10);
    selectedJenisKelamin = widget.pegawai.jenisKelamin;
    emailController.text = widget.pegawai.email;
    noHpController.text = widget.pegawai.noHp;
    alamatController.text = widget.pegawai.alamat;
    passwordController.text = widget.pegawai.password;
    selectedStatus = widget.pegawai.status;
  }

  Future<void> editPegawai() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('$baseUrl/EditDataPegawai.php'),
        body: {
          "id": widget.pegawai.id,
          "nama_pegawai": namaController.text,
          "tgl_lahir": tglLahirController.text,
          "jenis_kelamin": selectedJenisKelamin,
          "email": emailController.text,
          "no_hp": noHpController.text,
          "alamat": alamatController.text,
          "password": passwordController.text,
          "status": selectedStatus,
        },
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, true); // Return true to refresh the list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to edit pegawai")));
      }
    }
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        tglLahirController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Pegawai', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.lightBlue[100],
        iconTheme: IconThemeData(color: Colors.blue[900]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildHeaderText(),
              SizedBox(height: 20),
              _buildTextFormField(namaController, 'Nama Pegawai'),
              SizedBox(height: 10),
              GestureDetector(
                onTap: _selectDate,
                child: AbsorbPointer(
                  child: _buildTextFormField(tglLahirController, 'Tanggal Lahir (YYYY-MM-DD)'),
                ),
              ),
              SizedBox(height: 10),
              _buildDropdownField('Jenis Kelamin', ['Laki-laki', 'Perempuan'], (value) {
                setState(() {
                  selectedJenisKelamin = value;
                });
              }, selectedJenisKelamin),
              SizedBox(height: 10),
              _buildTextFormField(emailController, 'Email'),
              SizedBox(height: 10),
              _buildTextFormField(noHpController, 'No HP'),
              SizedBox(height: 10),
              _buildTextFormField(alamatController, 'Alamat'),
              SizedBox(height: 10),
              _buildTextFormField(passwordController, 'Password', obscureText: true),
              SizedBox(height: 10),
              _buildDropdownField('Status Pegawai', ['Pegawai Tetap', 'Non Pegawai Tetap'], (value) {
                setState(() {
                  selectedStatus = value;
                });
              }, selectedStatus),
              SizedBox(height: 20),
              _buildEditButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderText() {
    return Text(
      'Edit Pegawai',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.blue[900],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildTextFormField(TextEditingController controller, String labelText, {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.blue[700]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.blue[300]!, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.blue[500]!, width: 2.5),
        ),
      ),
      obscureText: obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownField(String hint, List<String> items, Function(String?) onChanged, String? selectedValue) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: TextStyle(color: Colors.blue[700]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.blue[300]!, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.blue[500]!, width: 2.5),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item, style: TextStyle(color: Colors.blue[700])),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return 'Please select $hint';
        }
        return null;
      },
    );
  }

  Widget _buildEditButton() {
    return ElevatedButton(
      onPressed: editPegawai,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15),
        backgroundColor: Colors.blue[400],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
      ),
      child: Text(
        'Edit Pegawai',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
      ),
    );
  }
}
