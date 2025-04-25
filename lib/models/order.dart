import 'package:flutter/material.dart';
import 'package:test_ease/models/labs_test.dart';

class Order {
  final String? id;
  final String userId;
  final String address;
  final TimeOfDay time;
  final DateTime selectedDate;
  final List<LabsTest> tests;
  final String? paymentStatus;
  final String? status;
  final int price;

  Order({
    required this.address,
    this.paymentStatus,
    required this.price,
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
      price: json['totalPrice'],
      tests: (json['tests'] as List).map((test) => LabsTest.fromJson(test)).toList(),
      userId: json['userId'],
      time: TimeOfDay.fromDateTime(DateTime.parse(json['time'])),
      selectedDate: DateTime.parse(json['selectedDate']),
      status: json['status']?.toString(),
      paymentStatus: json['paymentStatus']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    "address": address,
    "price": price,
    "tests": tests.map((test) => test.toJson()).toList(),
    "userId": userId,
    "time": "${time.hour}:${time.minute}", // Convert TimeOfDay to string
    "selectedDate": selectedDate.toIso8601String(),
    "paymentStatus": paymentStatus,
    "status": status,
  };
}
