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
    if (photo!.startsWith('http')) return photo;

    // On nettoie les éventuels antislashes envoyés par le JSON
    final cleanPath = photo!.replaceAll(r'\/', '/');

    return 'https://admin.itmaster-africa.com/storage/$cleanPath';
  }
}