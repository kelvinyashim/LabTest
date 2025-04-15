
class ContactInfo {
  ContactInfo({
    required this.phone,
    this.address,
    this.email,
    this.location,
  });

  final String phone;
  final List<String>? address;
  final String? email;
  final String? location;
 

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
      var addressList = json["address"];
  List<String>? address = [];
  if (addressList != null) {
    address = List<String>.from(addressList.map((x) => x.toString()));
  }
  
    return ContactInfo(
      phone: json["phone"] ?? "",
      address: address,
      email: json["email"],
      location: json["location"],
    );
  }

  Map<String, dynamic> toJson() => {
        "phone": phone,
        if (address != null) "address": address,
        if (email != null) "email": email,
        if (location != null) "location": location,
      };
}

