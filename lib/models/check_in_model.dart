import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CheckInModel {
  final String id;
  final String idUser;
  final String idOffice;
  final String dataCheck;
  final String checkIn;
  final String checkOut;
  CheckInModel({
    required this.id,
    required this.idUser,
    required this.idOffice,
    required this.dataCheck,
    required this.checkIn,
    required this.checkOut,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'idUser': idUser,
      'idOffice': idOffice,
      'dataCheck': dataCheck,
      'checkIn': checkIn,
      'checkOut': checkOut,
    };
  }

  factory CheckInModel.fromMap(Map<String, dynamic> map) {
    return CheckInModel(
      id: (map['id'] ?? '') as String,
      idUser: (map['idUser'] ?? '') as String,
      idOffice: (map['idOffice'] ?? '') as String,
      dataCheck: (map['dataCheck'] ?? '') as String,
      checkIn: (map['checkIn'] ?? '') as String,
      checkOut: (map['checkOut'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CheckInModel.fromJson(String source) => CheckInModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
