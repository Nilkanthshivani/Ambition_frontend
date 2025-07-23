import '../repositories/user_repository.dart';

class SignInWithEmail {
  final UserRepository repository;
  SignInWithEmail(this.repository);

  Future<Map<String, dynamic>> call({
    required String email,
    required String password,
    required String latitude,
    required String longitude,
  }) {
    return repository.signInWithEmail(
      email: email,
      password: password,
      latitude: latitude,
      longitude: longitude,
    );
  }
} 