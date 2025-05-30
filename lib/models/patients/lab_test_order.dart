class LabTestItem {
  final String testId;
  final String testName;
  final int price;
  final String labName;

  LabTestItem({
    required this.testId,
    required this.testName,
    required this.price,
    required this.labName,
  });

  factory LabTestItem.fromJson(Map<String, dynamic> json) {
    return LabTestItem(
      testId: json['test']?['_id'] ?? '',
      testName: json['test']?['name'] ?? '',
      price: json['price'] ?? 0,
      labName: json['labId']?['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'testId': testId,
    };
  }
}
