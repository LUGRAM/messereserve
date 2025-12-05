class ParoisseModel {
  final int id;
  final String name;
  final String address;
  final String city;

  ParoisseModel({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
  });

  factory ParoisseModel.fromJson(Map<String, dynamic> json) {
    return ParoisseModel(
      id: json['id'],
      name: json['name'],
      address: json['address'] ?? '',
      city: json['city'] ?? '',
    );
  }
}
