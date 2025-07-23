import '../repositories/user_repository.dart';

class SignInWithGoogle {
  final UserRepository repository;
  SignInWithGoogle(this.repository);

  Future<Map<String, dynamic>> call({
    required String idToken,
    required String latitude,
    required String longitude,
  }) {
    return repository.signInWithGoogle(
      idToken: idToken,
      latitude: latitude,
      longitude: longitude,
    );
  }
} 