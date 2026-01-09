class ReservationModel {
  final String id;
  final String reference;
  final String massTitle;
  final String date;
  final String time;
  final String status;
  final String? pastorName;
  final String? paroisseName;
  final String? paymentMethod;
  final int? amount;

  ReservationModel({
    required this.id,
    required this.reference,
    required this.massTitle,
    required this.date,
    required this.time,
    required this.status,
    this.pastorName,
    this.paroisseName,
    this.paymentMethod,
    this.amount,
  });
/*
  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      reference: json["reference"] ?? "",
      massTitle: json["mass_title"] ?? "",
      date: json["date"] ?? "",
      time: json["time"] ?? "",
      status: json["status"] ?? "",
      pastorName: json["pastor_name"],
      paroisseName: json["paroisse_name"],
      amount: json['amount'],
      operator: json['operator'],
    );
  }*/

  factory ReservationModel.fromApi(Map<String, dynamic> json) {
    final pretre = json['pretre'];
    final paiement = json['paiement'];
    final messe = json['messe'];
    final paroisse = json['paroisse']; // On récupère l'objet paroisse

    return ReservationModel(
      id: json['id'].toString(),
      reference: json['reference'] ?? 'N/A',
      massTitle: messe?['title'] ?? messe?['nom'] ?? 'Messe',
      date: json['date_messe'] ?? '',
      time: json['heure_messe'] ?? '',
      status: json['statut'] ?? 'en_attente_paiement',

      // Logique demandée pour le Pasteur
      pastorName: pretre != null
          ? "${pretre['nom'] ?? ''} ${pretre['prenom'] ?? ''}".trim()
          : "Non précisé",

      // Même méthode appliquée pour la Paroisse
      paroisseName: paroisse != null
          ? "${paroisse['nom'] ?? ''}".trim()
          : "Erreur: Paroisse manquante",

      paymentMethod: paiement != null ? "${paiement['payment_method']}".trim() : null,

      amount: int.tryParse(messe?['montant']?.toString() ?? '0') ?? 0,
    );
  }}
