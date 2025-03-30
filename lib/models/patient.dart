import 'package:test_ease/models/contact_info.dart';

class Patient {
    Patient({
        this.id,
        required this.name,
        required this.email,
        required this.contactInfo,
        required this.password,
        
    });

    final String? id;
    final String name;
    final String email;
    final String password;
    final ContactInfo? contactInfo;
    

    factory Patient.fromJson(Map<String, dynamic> json){ 
        return Patient(
            id: json["_id"]?.toString(),
            name: json["name"] ?? "",
            email: json["email"] ?? "",
            password: json["password"] ?? "",
            contactInfo:ContactInfo.fromJson(json["contactInfo"]),
            
        );
    }

    Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "password": password,
        "contactInfo": contactInfo?.toJson(),
    };

}
