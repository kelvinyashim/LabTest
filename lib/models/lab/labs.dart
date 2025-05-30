import 'package:test_ease/models/patients/contact_info.dart';

class Lab {
  final String? id;
  final String name;
  final String address;
  final ContactInfo contactInfo;
  final String? price;
  final String? status;
  final String? password;

  Lab({
    this.id,
    this.price,
    required this.name,
    required this.address,
    required this.contactInfo,
     this.status,
     this.password
  });

  factory Lab.fromJson(Map<String, dynamic> json) => Lab(
        id: json['_id']?.toString(),
        name: json["name"],
        address: json["address"] ?? 'Some Address', 
        contactInfo: ContactInfo.fromJson(json["contactInfo"]),
        status: json["status"] ?? 'Some Status',
        price: json["price"] ?? 'Some Price',
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "address": address,
        "contactInfo": contactInfo.toJson(),
        "password": password 
      };
}
