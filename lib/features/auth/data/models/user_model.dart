import '../../domain/entities/app_user.dart';

/// An [AppUser] that can be read from the API's JSON and saved back as JSON
/// (the cached copy kept after login).
class UserModel extends AppUser {
  const UserModel({
    required super.id,
    required super.fullName,
    required super.email,
    super.phone,
    super.type,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    if (id == null) throw const FormatException('User id missing');
    return UserModel(
      id: id.toString(),
      fullName: json['full_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'type': type,
    };
  }
}