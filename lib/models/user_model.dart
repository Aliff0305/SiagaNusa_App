class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String city;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone = '',
    this.city = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> j) => UserModel(
    id: '${j['id']}',
    name: '${j['name']}',
    email: '${j['email']}',
    phone: '${j['phone'] ?? ''}',
    city: '${j['city'] ?? ''}',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'city': city,
  };

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}
