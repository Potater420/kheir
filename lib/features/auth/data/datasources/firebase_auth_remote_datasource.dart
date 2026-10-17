import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_exception.dart';
import '../models/user_model.dart';
import 'auth_remote_datasource.dart';

/// Firebase Auth for the account, Firestore (`users/{uid}`) for the profile.
class FirebaseAuthRemoteDataSource implements AuthRemoteDataSource {
  FirebaseAuthRemoteDataSource({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  })  : _auth = auth,
        _firestore = firestore;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return _loadProfile(user);
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user == null) throw const FailureException(UnknownFailure());
      return await _loadProfile(user);
    } catch (error) {
      throw FailureException(_toFailure(error));
    }
  }

  @override
  Future<UserModel> register({
    required String fullName,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user == null) throw const FailureException(UnknownFailure());

      final cleanPhone = phone?.trim();
      final profile = UserModel(
        id: user.uid,
        fullName: fullName.trim(),
        email: email.trim(),
        phone: (cleanPhone == null || cleanPhone.isEmpty) ? null : cleanPhone,
      );

      try {
        await user.updateDisplayName(profile.fullName);
        await _users.doc(user.uid).set({
          ...profile.toMap(),
          'createdAt': FieldValue.serverTimestamp(),
        });
      } catch (_) {
        // Never leave an account without a profile: remove it so the
        // person can try again with the same email.
        await user.delete();
        rethrow;
      }
      return profile;
    } catch (error) {
      throw FailureException(_toFailure(error));
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (error) {
      throw FailureException(_toFailure(error));
    }
  }

  /// Reads the profile document. If that fails (for example offline) the
  /// name and email stored in the Firebase account are used instead, so a
  /// profile read problem never blocks login.
  Future<UserModel> _loadProfile(User user) async {
    Map<String, dynamic>? data;
    try {
      final snapshot = await _users.doc(user.uid).get();
      data = snapshot.data();
    } on FirebaseException {
      data = null;
    }
    if (data != null) return UserModel.fromMap(user.uid, data);
    return UserModel(
      id: user.uid,
      fullName: user.displayName ?? '',
      email: user.email ?? '',
    );
  }

  Failure _toFailure(Object error) {
    if (error is FailureException) return error.failure;
    if (error is FirebaseAuthException) {
      return switch (error.code) {
        'invalid-credential' ||
        'wrong-password' ||
        'user-not-found' ||
        'invalid-email' =>
          const InvalidCredentialsFailure(),
        'email-already-in-use' => const EmailAlreadyInUseFailure(),
        'network-request-failed' => const NetworkFailure(),
        _ => const UnknownFailure(),
      };
    }
    if (error is FirebaseException && error.code == 'unavailable') {
      return const NetworkFailure();
    }
    return const UnknownFailure();
  }
}
