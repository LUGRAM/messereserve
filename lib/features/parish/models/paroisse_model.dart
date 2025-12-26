class ParoisseModel {
  final int id;
  final String nom;
  final String address;
  final String? logo;

  ParoisseModel({
    required this.id,
    required this.nom,
    required this.address,
    this.logo,
  });

  factory ParoisseModel.fromJson(Map<String, dynamic> json) {
    return ParoisseModel(
      id: json['id'],
      nom: json['nom'],
      address: json['address'] ?? '',
      logo: json['logo'],
    );
  }
}
