class ReservationModel {
  final String reference;
  final String massTitle;
  final String date;
  final String time;
  final String status;
  final String? pastorName;

  ReservationModel({
    required this.reference,
    required this.massTitle,
    required this.date,
    required this.time,
    required this.status,
    this.pastorName,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      reference: json["reference"],
      massTitle: json["mass_title"],
      date: json["date"],
      time: json["time"],
      status: json["status"],
      pastorName: json["pastor_name"],
    );
  }
}
