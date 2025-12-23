class ReservationModel {
  final String reference;
  final String massTitle;
  final String date;
  final String time;
  final String status;
  final String? pastorName;
  final String? paroisseName;
  final int? amount;
  final String? operator;

  ReservationModel({
    required this.reference,
    required this.massTitle,
    required this.date,
    required this.time,
    required this.status,
    this.pastorName,
    this.paroisseName,
    this.amount,
    this.operator
  });

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
  }
}
