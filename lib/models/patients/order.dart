import 'package:flutter/material.dart';
import 'lab_test_order.dart'; // Make sure this path matches your file structure

class Order {
  final String? id;
  final String userId;
  final String address;
  final TimeOfDay time;
  final DateTime selectedDate;
  final List<LabTestItem> tests;
  final String? paymentStatus;
  final String? status;
  final int totalPrice;

  Order({
    required this.address,
    this.paymentStatus,
    required this.totalPrice,
    required this.tests,
    required this.userId,
    required this.time,
    required this.selectedDate,
    this.id,
    this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id']?.toString(),
      address: json['selectedAddress'],
      totalPrice: json['totalPrice'],
      tests: (json["tests"] as List?)
              ?.where((x) => x is Map<String, dynamic>)
              .map((x) => LabTestItem.fromJson(x as Map<String, dynamic>))
              .toList() ?? [],
      userId: json['userId'] ?? "",
      time: TimeOfDay.fromDateTime(DateTime.parse(json['time'])),
      selectedDate: DateTime.parse(json['selectedDate']),
      status: json['status']?.toString(),
      paymentStatus: json['paymentStatus']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        "selectedAddress": address,
        "totalPrice": totalPrice,
        "tests": tests.map((x) => x.toJson()).toList(),
        "userId": userId,
        "time": DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          time.hour,
          time.minute,
        ).toIso8601String(),
        "selectedDate": selectedDate.toIso8601String(),
      };
}
