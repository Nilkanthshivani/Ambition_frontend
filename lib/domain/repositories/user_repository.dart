// domain/repositories/user_repository.dart
import 'package:ambition_delivery/domain/entities/location_entity.dart';

import '../entities/user.dart';

abstract class UserRepository {
  Future<Map<String, dynamic>> createUser(Map<String, dynamic> user);
  Future<List<User>> getUsers();
  Future<Map<String, dynamic>> sendUserLoginOtp(Map<String, dynamic> data);
  Future<Map<String, dynamic>> resendUserLoginOtp(Map<String, dynamic> data);
  Future<Map<String, dynamic>> verifyUserLoginOtp(Map<String, dynamic> data);
  Future<Map<String, dynamic>> verifyOtp(Map<String, dynamic> otp);
  Future<Map<String, dynamic>> resendOtp(Map<String, dynamic> otp);
  Future<Map<String, dynamic>> updatePassword(Map<String, dynamic> data);
  Future<Map<String, dynamic>> sendOtpByEmail(Map<String, dynamic> data);
  Future<Map<String, dynamic>> resendOtpByEmail(Map<String, dynamic> data);
  Future<Map<String, dynamic>> verifyOtpByEmail(Map<String, dynamic> data);
  Future<Map<String, dynamic>> sendUserTempOtp(Map<String, dynamic> data);
  Future<Map<String, dynamic>> verifyUserTempOtp(Map<String, dynamic> data);
  Future<Map<String, dynamic>> resendUserTempOtp(Map<String, dynamic> data);
  Future<User?> getUser(String id);
  Future<User> updateUser(String id, Map<String, dynamic> user);
  Future<void> deleteUser(String id);
  Future<void> deleteUserByPhoneNumber(String phoneNumber);
  Future<LocationEntity?> getUserLocation(String id);
  Future<void> updateUserLocation(String id, Map<String, dynamic> location);
  Future<Map<String, dynamic>> signInWithEmail({
    required String email,
    required String password,
    required String latitude,
    required String longitude,
  });
  Future<Map<String, dynamic>> signInWithGoogle({
    required String idToken,
    required String latitude,
    required String longitude,
  });
}
