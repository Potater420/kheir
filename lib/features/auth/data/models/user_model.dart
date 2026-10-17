import '../../domain/entities/app_user.dart';

/// An [AppUser] that can be read from and written to a plain map
/// (a Firestore document now, JSON from the API later).
class UserModel extends AppUser {
  const UserModel({
    required super.id,
    required super.fullName,
    required super.email,
    super.phone,
  });

  factory UserModel.fromMap(String id, Map<String, dynamic> map) {
    return UserModel(
      id: id,
      fullName: map['fullName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      if (phone != null) 'phone': phone,
    };
  }
}
