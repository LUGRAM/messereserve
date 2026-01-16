class UserProfile {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? photo;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.photo,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      photo: json['photo'],
    );
  }

  /// Retourne l'URL complète de la photo si elle existe
  String? get photoUrl {
    if (photo == null || photo!.isEmpty) return null;

    // Si l'URL est déjà complète
    if (photo!.startsWith('http')) return photo;

    // Sinon, construire l'URL complète
    return 'https://admin.itmaster-africa.com/storage/$photo';
  }
}