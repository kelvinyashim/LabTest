class Test {
  final String testId;
  final String labId;
  final String? name;
  final String? description;
  final int price;

  Test({required this.testId, required this.labId, required this.price, this.name, this.description, });

  factory Test.fromJson(Map<String, dynamic> json) {
    return Test(
      name: json['name']?.toString(),
      description: json['description']?.toString(),
      testId: json['testId'],
      labId: json['labId'],
      price: json['price'],
    );
  }

  Map<String,dynamic> toJson(){
    return {
          'testId': testId,
          'labId': labId,
          'price': price,
    };
  }
}
