class PastorModel {
  final int id;
  final String nom;
  final String telephone;
  final String photo;

  PastorModel({
    required this.id,
    required this.nom,
    required this.telephone,
    required this.photo,
  });

  factory PastorModel.fromJson(Map<String, dynamic> json) {
    return PastorModel(
      id: json["id"],
      nom: json["nom"],
      telephone: json["telephone"] ?? "",
      photo: json["photo"] ?? "",
    );
  }
}