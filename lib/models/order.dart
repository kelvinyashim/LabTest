class Order {
  final String? id;
  final String userId;
  final String address;
  final Object tests;
  final String? paymentStatus;
  final String? status;
  final int price;

  Order({
    required this.address,
    this.paymentStatus,
    required this.price,
    required this.tests,
    required this.userId,
    this.id,
    this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id']?.toString(),
      address: json['selectedAdress'],
      price: json['price'],
      tests: json['tests'],
      userId: json['userId'],
      status: json['status']?.toString(),
      paymentStatus: json['paymentStatus']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    "address": address,
    "price": price,
    "tests": tests,
    "userId": userId,
  };
}
