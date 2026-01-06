class UserProfile {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      avatar: json['avatar'],
    );
  }
}
