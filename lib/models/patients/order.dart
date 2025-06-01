import 'package:flutter/material.dart';
import 'package:test_ease/models/patients/lab_test_order.dart';

class Order {
  final String? id;
  final String? phlebotomistId;
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
    this.phlebotomistId,
    this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id']?.toString(),
      phlebotomistId: json['phlebotomistId']?.toString(),
      address: json['selectedAddress'],
      totalPrice: json['totalPrice'] ?? 0,
      tests:
          json["tests"] == null
              ? []
              : List<LabTestItem>.from(
                json["tests"].map((x) => LabTestItem.fromJson(x)),
              ),
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
    "tests": tests.map((test) => test.toJson()).toList(),
    "userId": userId,
    "time":
        DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          time.hour,
          time.minute,
        ).toIso8601String(),
    "selectedDate": selectedDate.toIso8601String(),
  };
}
