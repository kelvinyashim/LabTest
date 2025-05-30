import 'package:hive/hive.dart';

part 'labs_test.g.dart';

@HiveType(typeId: 1)
class LabsTest {
  @HiveField(0)
  final String testName;

  @HiveField(1)
  final String lab;

  @HiveField(2)
  final String address;

  @HiveField(3)
  final int price;

  @HiveField(4)
  String? labId;

  @HiveField(5)
  final String? testId;

  @HiveField(6)
  final String? id;

  LabsTest({
    required this.testName,
    required this.address,
    required this.lab,
    required this.price,
    this.labId,
    this.testId,
    this.id,
  });

  factory LabsTest.fromJson(Map<String, dynamic> json) => LabsTest(
        testId: json['testId'],
        testName: json["testName"],
        address: json["address"],
        lab: json["lab"],
        price: json["price"],
        labId: json["labId"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "testName": testName,
        "lab": lab,
        "address": address,
        "price": price,
        "testId": testId,
        "_id": id,
      };
}
