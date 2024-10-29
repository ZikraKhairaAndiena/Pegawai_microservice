// To parse this JSON data, do
//
//     final modelPegawai = modelPegawaiFromJson(jsonString);

import 'dart:convert';

ModelPegawai modelPegawaiFromJson(String str) => ModelPegawai.fromJson(json.decode(str));

String modelPegawaiToJson(ModelPegawai data) => json.encode(data.toJson());

class ModelPegawai {
  bool isSuccess;
  String message;
  List<Datum> data;

  ModelPegawai({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ModelPegawai.fromJson(Map<String, dynamic> json) => ModelPegawai(
    isSuccess: json["isSuccess"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String id;
  String namaPegawai;
  DateTime tglLahir;
  String jenisKelamin;
  String email;
  String noHp;
  String alamat;
  String password;
  String status;

  Datum({
    required this.id,
    required this.namaPegawai,
    required this.tglLahir,
    required this.jenisKelamin,
    required this.email,
    required this.noHp,
    required this.alamat,
    required this.password,
    required this.status,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    namaPegawai: json["nama_pegawai"],
    tglLahir: DateTime.parse(json["tgl_lahir"]),
    jenisKelamin: json["jenis_kelamin"],
    email: json["email"],
    noHp: json["no_hp"],
    alamat: json["alamat"],
    password: json["password"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nama_pegawai": namaPegawai,
    "tgl_lahir": "${tglLahir.year.toString().padLeft(4, '0')}-${tglLahir.month.toString().padLeft(2, '0')}-${tglLahir.day.toString().padLeft(2, '0')}",
    "jenis_kelamin": jenisKelamin,
    "email": email,
    "no_hp": noHp,
    "alamat": alamat,
    "password": password,
    "status": status,
  };
}
