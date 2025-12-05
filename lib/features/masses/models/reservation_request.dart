class ReservationRequest {
  final int massServiceId;

  final String scheduledDate; // YYYY-MM-DD
  final String scheduledTime; // HH:mm

  final int? pastorId;
  final String? beneficiary;
  final int paroisseId;       // obligatoire

  ReservationRequest({
    required this.massServiceId,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.paroisseId,
    this.pastorId,
    this.beneficiary,
  });

  Map<String, dynamic> toJson() {
    return {
      "mass_service_id": massServiceId,
      "scheduled_date": scheduledDate,
      "scheduled_time": scheduledTime,
      "pastor_id": pastorId,
      "beneficiary": beneficiary,
      "paroisse_id": paroisseId
    };
  }
}
