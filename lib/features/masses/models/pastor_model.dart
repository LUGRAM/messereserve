class PastorModel {
  final int id;
  final String name;
  final String image;
  final String? phone;

  PastorModel({
    required this.id,
    required this.name,
    required this.image,
    this.phone,
  });
}
