import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class OfficerModel {
  final String id;
  final String office;
  final String lat;
  final String lng;
  OfficerModel({
    required this.id,
    required this.office,
    required this.lat,
    required this.lng,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'office': office,
      'lat': lat,
      'lng': lng,
    };
  }

  factory OfficerModel.fromMap(Map<String, dynamic> map) {
    return OfficerModel(
      id: (map['id'] ?? '') as String,
      office: (map['office'] ?? '') as String,
      lat: (map['lat'] ?? '') as String,
      lng: (map['lng'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory OfficerModel.fromJson(String source) => OfficerModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
