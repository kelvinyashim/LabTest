class TestCatalogue {
  TestCatalogue({this.id, required this.name, this.description});
  String? id;
  final String name;
  String? description;

  factory TestCatalogue.fromJson(Map<String, dynamic> json) {
    return TestCatalogue(
        id: json['_id']?.toString(),
        name: json['name'] ?? "",
        description: json['description'] ?? "");
  }

  Map<String, dynamic> toJson() => {"name": name, "description": description};
}


