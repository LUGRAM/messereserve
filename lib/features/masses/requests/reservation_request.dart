class ReservationRequest {
  // ===== Messe =====
  final int massServiceId;
  final String scheduledDate;
  final String scheduledTime;

  // ===== Lieux =====
  final int paroisseId;
  final int? pastorId;

  // ===== Demandeur =====
  final String requesterNom;
  final String requesterPrenom;
  final String requesterNationalite;
  final String requesterTelephone;

  // ===== Bénéficiaire =====
  final String? beneficiaryNom;
  final String? beneficiaryPrenom;
  final String? beneficiaryDateDeces; // YYYY-MM-DD (REQUiem)

  ReservationRequest({
    required this.massServiceId,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.paroisseId,
    this.pastorId,

    required this.requesterNom,
    required this.requesterPrenom,
    required this.requesterNationalite,
    required this.requesterTelephone,

    this.beneficiaryNom,
    this.beneficiaryPrenom,
    this.beneficiaryDateDeces,
  });

  Map<String, dynamic> toJson() {
    return {
      "mass_service_id": massServiceId,
      "scheduled_date": scheduledDate,
      "scheduled_time": scheduledTime,

      "paroisse_id": paroisseId,
      "pastor_id": pastorId,

      "requester": {
        "nom": requesterNom,
        "prenom": requesterPrenom,
        "nationalite": requesterNationalite,
        "telephone": requesterTelephone,
      },

      "beneficiary": beneficiaryNom != null
          ? {
        "nom": beneficiaryNom,
        "prenom": beneficiaryPrenom,
        "date_deces": beneficiaryDateDeces,
      }
          : null,
    };
  }
}
