class ReservationRequest {
  final int massServiceId;

  final String scheduledDate; // format YYYY-MM-DD
  final String scheduledTime; // format HH:mm

  final int? pastorId;        // optionnel
  final String? beneficiary;  // nom du défunt (requiem uniquement)

  ReservationRequest({
    required this.massServiceId,
    required this.scheduledDate,
    required this.scheduledTime,
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
    };
  }
}
