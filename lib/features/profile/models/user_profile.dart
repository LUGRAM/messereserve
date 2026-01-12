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
}
