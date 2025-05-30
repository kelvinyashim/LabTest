import 'package:test_ease/models/patients/contact_info.dart';

class Phleb {
  Phleb({
    required this.name,
    required this.contactInfo,
    required this.password,
    required this.associatedLab,
    this.role,
    this.status,
  });
  final String name;
  final String password;
  final String? role;
  final String? status;
  final ContactInfo contactInfo;
  final String associatedLab;

  factory Phleb.fromJson(Map<String, dynamic> json) {
    return Phleb(
      password: json['password'] ?? '',
      role: json['role'],
      contactInfo: ContactInfo.fromJson(json['contactInfo']),
      associatedLab: json['associatedLab'],
      name: json['name'],
      status: json['status']
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "password": password,
    "contactInfo": contactInfo.toJson(),
    "associatedLab": associatedLab
  };
}
