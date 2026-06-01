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
  final bool withChoir;

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
    this.withChoir = false,
  });

  Map<String, dynamic> toJson() {
    return {
      // ===== Messe =====
      "paroisse_id": paroisseId,
      "messe_id": massServiceId,
      "pretre_id": pastorId,
      "date_messe": scheduledDate,
      "heure_messe": scheduledTime,
      "with_choir": withChoir ? 1 : 0,

      // ===== Demandeur =====
      "nom": requesterNom,
      "prenom": requesterPrenom,
      "nationalite": requesterNationalite,
      "telephone": requesterTelephone,

      // ===== Défunt (optionnel) =====
      "defunt_nom": beneficiaryNom,
      "defunt_prenom": beneficiaryPrenom,
      "defunt_date_deces": beneficiaryDateDeces,
    };
  }
}
