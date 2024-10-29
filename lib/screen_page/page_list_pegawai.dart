import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tugas_microservice_pegawai/screen_page/page_add_pegawai.dart';
import 'package:tugas_microservice_pegawai/screen_page/page_detail_pegawai.dart';
import 'package:tugas_microservice_pegawai/screen_page/page_edit_pegawai.dart';
import 'dart:convert';

import '../model/model_pegawai.dart';

class PageListPegawai extends StatefulWidget {
  @override
  _PageListPegawaiState createState() => _PageListPegawaiState();
}

class _PageListPegawaiState extends State<PageListPegawai> {
  List<Datum> pegawai = [];
  bool isLoading = true;

  final String baseUrl = 'http://172.21.96.1:7070';

  @override
  void initState() {
    super.initState();
    fetchPegawai();
  }

  Future<void> fetchPegawai() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse('$baseUrl/getPegawai.php'));
      if (response.statusCode == 200) {
        final modelPegawai = modelPegawaiFromJson(response.body);
        setState(() {
          pegawai = modelPegawai.data;
        });
      } else {
        _showErrorSnackBar('Failed to load pegawai: ${response.reasonPhrase}');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to load pegawai: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red[300]),
    );
  }

  void navigateToAddPegawaiScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PageAddPegawai()),
    );

    if (result == true) {
      fetchPegawai();
    }
  }

  void navigateToEditPegawaiScreen(Datum pegawaiItem) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PageEditPegawai(pegawai: pegawaiItem)),
    );

    if (result == true) {
      fetchPegawai();
    }
  }

  void navigateToDetailPegawaiScreen(Datum pegawaiItem) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PageDetailPegawai(pegawai: pegawaiItem)),
    );
  }

  void deletePegawaiDialog(Datum pegawaiItem) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Delete Pegawai',
            style: TextStyle(color: Colors.green[900], fontWeight: FontWeight.bold),
          ),
          content: Text('Are you sure you want to delete this pegawai?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Colors.green[700])),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final response = await http.post(
                    Uri.parse('$baseUrl/DeleteDataPegawai.php'),
                    body: {'id': pegawaiItem.id.toString()},
                  );

                  if (response.statusCode == 200) {
                    var responseData = json.decode(response.body);
                    if (responseData['VALUE'] == 1) {
                      fetchPegawai();
                      Navigator.pop(context);
                    } else {
                      _showErrorSnackBar(responseData['MESSAGE']);
                    }
                  } else {
                    _showErrorSnackBar('Failed to delete pegawai: ${response.reasonPhrase}');
                  }
                } catch (e) {
                  _showErrorSnackBar('Failed to delete pegawai: $e');
                }
              },
              child: Text('Delete', style: TextStyle(color: Colors.red[400])),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent[100],
        title: Text(
          'List Pegawai',
          style: TextStyle(color: Colors.green[900], fontWeight: FontWeight.bold, fontSize: 24),
        ),
        iconTheme: IconThemeData(color: Colors.green[900]),
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.green[700]))
          : pegawai.isEmpty
          ? Center(
        child: Text(
          'No pegawai found.',
          style: TextStyle(color: Colors.green[700], fontSize: 18, fontWeight: FontWeight.w500),
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: pegawai.length,
        itemBuilder: (context, index) {
          final pegawaiItem = pegawai[index];
          return Card(
            color: Colors.white,
            elevation: 8,
            margin: EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              title: Text(
                pegawaiItem.namaPegawai,
                style: TextStyle(
                  color: Colors.green[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                pegawaiItem.email,
                style: TextStyle(color: Colors.green[700], fontSize: 16),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.green[700]),
                    onPressed: () => navigateToEditPegawaiScreen(pegawaiItem),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red[400]),
                    onPressed: () => deletePegawaiDialog(pegawaiItem),
                  ),
                ],
              ),
              onTap: () => navigateToDetailPegawaiScreen(pegawaiItem),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddPegawaiScreen,
        backgroundColor: Colors.green[400],
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
