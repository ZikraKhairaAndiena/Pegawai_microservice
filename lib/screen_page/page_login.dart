import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tugas_microservice_pegawai/screen_page/page_list_pegawai.dart';
import 'package:tugas_microservice_pegawai/screen_page/page_register.dart';
import '../model/model_login.dart';
import '../utils/session_manager.dart';

class PageLoginApi extends StatefulWidget {
  const PageLoginApi({Key? key});

  @override
  State<PageLoginApi> createState() => _PageLoginApiState();
}

class _PageLoginApiState extends State<PageLoginApi> {
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();

  GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  bool isLoading = false;
  bool _obscureText = true;

  Future<ModelLogin?> loginAccount() async {
    try {
      setState(() {
        isLoading = true;
      });
      http.Response response = await http.post(
        Uri.parse('http://172.21.96.1:7070/LoginPegawai.php'),
        body: {
          "email": txtEmail.text,
          "password": txtPassword.text,
        },
      );
      ModelLogin data = modelLoginFromJson(response.body);
      if (data.value == 1) {
        setState(() {
          isLoading = false;
          session.saveSession(data.value ?? 0, data.id ?? "", data.email ?? "");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${data.message}')));

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => PageListPegawai()),
                (route) => false,
          );
        });
      } else {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${data.message}')));
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent[100],
        title: Text(
          'Form Login',
          style: TextStyle(
            color: Colors.green[900],
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
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
                  Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.green[900],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  // Email field with icon
                  TextFormField(
                    validator: (val) {
                      return val!.isEmpty ? "Email tidak boleh kosong" : null;
                    },
                    controller: txtEmail,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email, color: Colors.green[700]),
                      hintText: 'Input Email',
                      hintStyle: TextStyle(color: Colors.green[300]),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Password field with eye icon
                  TextFormField(
                    validator: (val) {
                      return val!.isEmpty ? "Password tidak boleh kosong" : null;
                    },
                    controller: txtPassword,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock, color: Colors.green[700]),
                      hintText: 'Input Password',
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
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: isLoading
                        ? CircularProgressIndicator(color: Colors.green[700])
                        : ElevatedButton(
                      onPressed: () {
                        if (keyForm.currentState?.validate() == true) {
                          loginAccount();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Colors.green[400],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(10),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PageRegisterApi()),
            );
          },
          child: Text(
            'Anda belum punya akun? Silakan Register',
            style: TextStyle(
              fontSize: 16,
              color: Colors.green[700],
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
