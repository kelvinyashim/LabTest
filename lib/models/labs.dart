import 'package:test_ease/models/contact_info.dart';

class Lab {
  final String? id;
  final String name;
  final String address;
  final String password;
  final ContactInfo contactInfo;
  final String status;

  Lab({
    this.id,
    required this.name,
    required this.address,
    required this.password,
    required this.contactInfo,
    required this.status,
  });

  factory Lab.fromJson(Map<String, dynamic> json) => Lab(
        id: json['id']?.toString(),
        name: json["name"],
        address: json["address"],
        password: json["password"],
        contactInfo: ContactInfo.fromJson(json["contactInfo"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "address": address,
        "password": password,
        "contactInfo": contactInfo.toJson(),
        "status": status,
      };
}
