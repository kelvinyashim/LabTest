class LabsTest {
  final String testName;
  final String lab;
  final String address;
  final int price;
  const LabsTest(
      {required this.testName,
      required this.address,
      required this.lab,
      required this.price});

  factory LabsTest.fromJson(Map<String, dynamic> json) => LabsTest(
      testName: json["testName"],
      address: json["address"],
      lab: json["lab"],
      price: json["price"]);


      Map<String,dynamic> toJson() =>{
        "testName": testName,
        "lab": lab,
        "address": address,
        "price": price



      };
}
