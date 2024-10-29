import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tugas_microservice_pegawai/screen_page/page_login.dart';
import '../model/model_register.dart';
import '../utils/session_manager.dart';

class PageRegisterApi extends StatefulWidget {
  const PageRegisterApi({super.key});

  @override
  State<PageRegisterApi> createState() => _PageRegisterApiState();
}

class _PageRegisterApiState extends State<PageRegisterApi> {
  TextEditingController txtNamaPegawai = TextEditingController();
  TextEditingController txtTglLahir = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtNoHP = TextEditingController();
  TextEditingController txtAlamat = TextEditingController();
  TextEditingController txtPassword = TextEditingController();

  String? selectedJenisKelamin;
  String? selectedStatus;
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  bool isLoading = false;
  bool _obscureText = true;

  Future<ModelRegister?> registerAccount() async {
    try {
      setState(() {
        isLoading = true;
      });

      http.Response response = await http.post(
        Uri.parse('http://172.21.96.1:7070/RegisterPegawai.php'),
        body: {
          "nama_pegawai": txtNamaPegawai.text,
          "tgl_lahir": txtTglLahir.text,
          "jenis_kelamin": selectedJenisKelamin,
          "email": txtEmail.text,
          "no_hp": txtNoHP.text,
          "alamat": txtAlamat.text,
          "password": txtPassword.text,
          "status": selectedStatus,
        },
      );

      ModelRegister data = modelRegisterFromJson(response.body);
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${data.message}')),
        );
        if (data.value == 1) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => PageLoginApi()),
                (route) => false,
          );
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent[100],
        title: Text(
          'Create Your Account',
          style: TextStyle(color: Colors.green[900], fontSize: 20, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.green[900]),
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            key: keyForm,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeaderText(),
                  SizedBox(height: 20),
                  _buildTextFormField('Nama Pegawai', txtNamaPegawai, Icons.person),
                  SizedBox(height: 10),
                  _buildTextFormField(
                    'Tanggal Lahir (YYYY-MM-DD)',
                    txtTglLahir,
                    Icons.calendar_today,
                    onTap: () async {
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (selectedDate != null) {
                        txtTglLahir.text = "${selectedDate.toLocal()}".split(' ')[0];
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  _buildDropdownField('Jenis Kelamin', ['Laki-laki', 'Perempuan'], (value) => selectedJenisKelamin = value, selectedJenisKelamin),
                  SizedBox(height: 10),
                  _buildTextFormField('Email', txtEmail, Icons.email),
                  SizedBox(height: 10),
                  _buildTextFormField('No. HP', txtNoHP, Icons.phone),
                  SizedBox(height: 10),
                  _buildTextFormField('Alamat', txtAlamat, Icons.location_on),
                  SizedBox(height: 10),
                  _buildPasswordFormField(),
                  SizedBox(height: 10),
                  _buildDropdownField('Status Pegawai', ['Pegawai Tetap', 'Non Pegawai Tetap'], (value) => selectedStatus = value, selectedStatus),
                  SizedBox(height: 20),
                  _buildRegisterButton(),
                  SizedBox(height: 15),
                  _buildLoginRedirectText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderText() {
    return Text(
      'Register',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: Colors.green[900],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildTextFormField(String hint, TextEditingController controller, IconData icon, {bool obscureText = false, VoidCallback? onTap}) {
    return TextFormField(
      validator: (val) => val!.isEmpty ? "Field ini tidak boleh kosong" : null,
      controller: controller,
      obscureText: obscureText,
      readOnly: onTap != null,
      onTap: onTap,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.green[700]),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.green[300]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildPasswordFormField() {
    return TextFormField(
      validator: (val) => val!.isEmpty ? "Field ini tidak boleh kosong" : null,
      controller: txtPassword,
      obscureText: _obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock, color: Colors.green[700]),
        hintText: 'Password',
        hintStyle: TextStyle(color: Colors.green[300]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.green[700],
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
    );
  }

  Widget _buildDropdownField(String hint, List<String> items, Function(String?) onChanged, String? selectedValue) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.arrow_drop_down, color: Colors.green[700]),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.green[300]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      value: selectedValue,
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item, style: TextStyle(color: Colors.green[700])),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? "Pilih $hint" : null,
    );
  }

  Widget _buildRegisterButton() {
    return isLoading
        ? Center(child: CircularProgressIndicator(color: Colors.green[700]))
        : ElevatedButton(
      onPressed: () {
        if (keyForm.currentState?.validate() == true && selectedJenisKelamin != null && selectedStatus != null) {
          registerAccount();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lengkapi semua field')),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15),
        backgroundColor: Colors.lightGreen[400],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text('Register', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }

  Widget _buildLoginRedirectText() {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PageLoginApi())),
      child: Text(
        'Sudah punya akun? Login di sini',
        style: TextStyle(fontSize: 16, color: Colors.green[700], decoration: TextDecoration.underline),
        textAlign: TextAlign.center,
      ),
    );
  }
}
