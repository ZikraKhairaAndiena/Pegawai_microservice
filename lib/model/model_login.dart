// To parse this JSON data, do
//
//     final modelLogin = modelLoginFromJson(jsonString);

import 'dart:convert';

ModelLogin modelLoginFromJson(String str) => ModelLogin.fromJson(json.decode(str));

String modelLoginToJson(ModelLogin data) => json.encode(data.toJson());

class ModelLogin {
  int value;
  String message;
  String id;
  String namaPegawai;
  String email;

  ModelLogin({
    required this.value,
    required this.message,
    required this.id,
    required this.namaPegawai,
    required this.email,
  });

  factory ModelLogin.fromJson(Map<String, dynamic> json) => ModelLogin(
    value: json["value"],
    message: json["message"],
    id: json["id"],
    namaPegawai: json["nama_pegawai"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "message": message,
    "id": id,
    "nama_pegawai": namaPegawai,
    "email": email,
  };
}
