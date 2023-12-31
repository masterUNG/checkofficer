import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final String id;
  final String user;
  final String password;
  final String name;
  final String position;
  UserModel({
    required this.id,
    required this.user,
    required this.password,
    required this.name,
    required this.position,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user': user,
      'password': password,
      'name': name,
      'position': position,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: (map['id'] ?? '') as String,
      user: (map['user'] ?? '') as String,
      password: (map['password'] ?? '') as String,
      name: (map['name'] ?? '') as String,
      position: (map['position'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
