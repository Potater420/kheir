import 'package:equatable/equatable.dart';

/// The signed-in person, as the rest of the app sees them.
/// It knows nothing about Firebase or any other backend.
class AppUser extends Equatable {
  const AppUser({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    this.type = '',
  });

  final String id;
  final String fullName;
  final String email;
  final String? phone;

  /// donor, volunteer, admin or super_admin (as sent by the API).
  final String type;

  @override
  List<Object?> get props => [id, fullName, email, phone, type];
}