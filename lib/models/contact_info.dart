
class ContactInfo {
  ContactInfo({
    required this.phone,
    this.address,
    this.email,
    this.location,
    this.licenseNumber,
  });

  final String phone;
  final String? address;
  final String? email;
  final String? location;
  final String? licenseNumber;

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(
      phone: json["phone"] ?? "",
      address: json["address"],
      email: json["email"],
      location: json["location"],
      licenseNumber: json["licenseNumber"],
    );
  }

  Map<String, dynamic> toJson() => {
        "phone": phone,
        if (address != null) "address": address,
        if (email != null) "email": email,
        if (location != null) "location": location,
        if (licenseNumber != null) "licenseNumber": licenseNumber,
      };
}

