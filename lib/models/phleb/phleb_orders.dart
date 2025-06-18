import 'package:test_ease/models/patients/lab_test_order.dart';

class PhlebOrders {
  final String? id;
  final String userName;
  final String phone;
  final String selectedAddress;
  final DateTime time;
  final List<LabTestItem> tests;
  final int totalPrice;
  final String paymentStatus;
  final String? status;

  PhlebOrders({
    this.id,
    this.status,
    required this.userName,
    required this.phone,
    required this.selectedAddress,
    required this.time,
    required this.tests,
    required this.totalPrice,
    required this.paymentStatus,
  });

  factory PhlebOrders.fromJson(Map<String, dynamic> json) {
    return PhlebOrders(
      id: json['id'],
      userName: json['userName'],
      phone: json['phone'],
      selectedAddress: json['selectedAddress'],
      time: DateTime.parse(json['time']),
      status: json['status'],
      tests:
          (json['tests'] as List)
              .map((test) => LabTestItem.fromJson(test))
              .toList(),
      totalPrice: json['totalPrice'],
      paymentStatus: json['paymentStatus'],
    );
    
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'phone': phone,
      'selectedAddress': selectedAddress,
      'time': time.toIso8601String(),
      'tests': tests.map((t) => t.toJson()).toList(),
      'totalPrice': totalPrice,
      'paymentStatus': paymentStatus,
    };
  }
}
