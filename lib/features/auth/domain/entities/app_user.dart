import 'package:equatable/equatable.dart';

/// The signed-in person, as the rest of the app sees them.
/// It knows nothing about Firebase or any other backend.
class AppUser extends Equatable {
  const AppUser({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
  });

  final String id;
  final String fullName;
  final String email;
  final String? phone;

  @override
  List<Object?> get props => [id, fullName, email, phone];
}
