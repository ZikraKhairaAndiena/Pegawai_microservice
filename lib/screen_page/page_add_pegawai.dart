import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // For date formatting

class PageAddPegawai extends StatefulWidget {
  @override
  _PageAddPegawaiState createState() => _PageAddPegawaiState();
}

class _PageAddPegawaiState extends State<PageAddPegawai> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController namaController = TextEditingController();
  TextEditingController tglLahirController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController noHpController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? selectedJenisKelamin;
  String? selectedStatus;
  bool _isPasswordVisible = false;

  final String baseUrl = 'http://172.21.96.1:7070';

  Future<void> addPegawai() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('$baseUrl/AddDataPegawai.php'),
        body: {
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
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add pegawai")),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
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
        title: Text('Add Pegawai', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.lightBlue[100],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding to the body
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildHeaderText(),
              SizedBox(height: 20),
              _buildTextField(namaController, 'Nama Pegawai', Icons.person),
              SizedBox(height: 10),
              _buildDateField(),
              SizedBox(height: 10),
              _buildDropdownField('Jenis Kelamin', ['Laki-laki', 'Perempuan'], selectedJenisKelamin, (value) {
                setState(() {
                  selectedJenisKelamin = value;
                });
              }),
              SizedBox(height: 10),
              _buildTextField(emailController, 'Email', Icons.email),
              SizedBox(height: 10),
              _buildTextField(noHpController, 'No HP', Icons.phone),
              SizedBox(height: 10),
              _buildTextField(alamatController, 'Alamat', Icons.home),
              SizedBox(height: 10),
              _buildPasswordField(),
              SizedBox(height: 10),
              _buildDropdownField('Status Pegawai', ['Pegawai Tetap', 'Non Pegawai Tetap'], selectedStatus, (value) {
                setState(() {
                  selectedStatus = value;
                });
              }),
              SizedBox(height: 20),
              _buildAddButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderText() {
    return Text(
      'Tambah Pegawai',
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: Colors.blue[900],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blue[700]),
        hintText: label,
        hintStyle: TextStyle(color: Colors.blue[300]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.blue[400]!, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.blue[500]!, width: 2.5),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      controller: tglLahirController,
      readOnly: true,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.calendar_today, color: Colors.blue[700]),
        hintText: 'Tanggal Lahir (YYYY-MM-DD)',
        hintStyle: TextStyle(color: Colors.blue[300]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.blue[400]!, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.blue[500]!, width: 2.5),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
      onTap: () => _selectDate(context),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select Tanggal Lahir';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock, color: Colors.blue[700]),
        hintText: 'Password',
        hintStyle: TextStyle(color: Colors.blue[300]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.blue[400]!, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.blue[500]!, width: 2.5),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.blue[700],
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownField(String label, List<String> items, String? selectedValue, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.arrow_drop_down, color: Colors.blue[700]),
        hintText: label,
        hintStyle: TextStyle(color: Colors.blue[300]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.blue[400]!, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.blue[500]!, width: 2.5),
        ),
      ),
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: TextStyle(color: Colors.blue[700])),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return 'Please select $label';
        }
        return null;
      },
    );
  }

  Widget _buildAddButton() {
    return ElevatedButton(
      onPressed: addPegawai,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(
        'Add Pegawai',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.blue),
      ),
    );
  }
}
