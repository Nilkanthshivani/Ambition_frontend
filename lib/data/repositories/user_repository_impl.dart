import 'dart:convert';

import 'package:ambition_delivery/data/datasources/remote_data_source.dart';
import 'package:ambition_delivery/data/models/location_model.dart';
import 'package:ambition_delivery/data/models/user_model.dart';
import 'package:ambition_delivery/domain/entities/location_entity.dart';
import 'package:ambition_delivery/domain/entities/user.dart';

import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final RemoteDataSource userRemoteDataSource;

  UserRepositoryImpl({
    required this.userRemoteDataSource,
  });

  @override
  Future<Map<String, dynamic>> createUser(Map<String, dynamic> user) async {
    return await userRemoteDataSource.createUser(user);
  }

  @override
  Future<void> deleteUser(String id) async {
    await userRemoteDataSource.deleteUser(id);
  }

  @override
  Future<void> deleteUserByPhoneNumber(String phoneNumber) async {
    await userRemoteDataSource.deleteUserByPhoneNumber(phoneNumber);
  }

  @override
  Future<User?> getUser(String id) async {
    final resp = await userRemoteDataSource.getUser(id);
    if (resp.statusCode == 200) {
      print("objectToJson${resp.data}");
      return UserModel.fromJson(resp.data).toEntity();
    } else {
      return null;
    }
  }

  @override
  Future<User> updateUser(String id, Map<String, dynamic> user) async {
    final resp = await userRemoteDataSource.updateUser(id, user);
    if (resp.statusCode == 200) {
      return UserModel.fromJson(resp.data).toEntity();
    } else {
      throw Exception('Failed to update user');
    }
  }

  @override
  Future<List<User>> getUsers() async {
    final resp = await userRemoteDataSource.getUsers();
    return (jsonDecode(resp.data) as List)
        .map((e) => UserModel.fromJson(e).toEntity())
        .toList();
  }

  @override
  Future<Map<String, dynamic>> sendUserLoginOtp(
      Map<String, dynamic> data) async {
    final resp = await userRemoteDataSource.sendUserLoginOtp(data);
    return resp.data;
  }

  @override
  Future<Map<String, dynamic>> resendUserLoginOtp(
      Map<String, dynamic> data) async {
    final resp = await userRemoteDataSource.resendUserLoginOtp(data);
    return resp.data;
  }

  @override
  Future<Map<String, dynamic>> verifyUserLoginOtp(
      Map<String, dynamic> data) async {
    final resp = await userRemoteDataSource.verifyUserLoginOtp(data);
    return resp.data;
  }

  @override
  Future<Map<String, dynamic>> resendOtp(Map<String, dynamic> otp) async {
    final resp = await userRemoteDataSource.resendOtp(otp);
    return resp.data;
  }

  @override
  Future<Map<String, dynamic>> verifyOtp(Map<String, dynamic> otp) async {
    final resp = await userRemoteDataSource.verifyOtp(otp);
    return resp.data;
  }

  @override
  Future<LocationEntity?> getUserLocation(String id) async {
    final resp = await userRemoteDataSource.getUserLocation(id);
    if (resp.statusCode == 200) {
      return LocationModel.fromJson(resp.data).toEntity();
    } else {
      return null;
    }
  }

  @override
  Future<void> updateUserLocation(
      String id, Map<String, dynamic> location) async {
    await userRemoteDataSource.updateUserLocation(id, location);
  }

  @override
  Future<Map<String, dynamic>> resendOtpByEmail(
      Map<String, dynamic> data) async {
    final resp = await userRemoteDataSource.resendOtpByEmail(data);
    return resp.data;
  }

  @override
  Future<Map<String, dynamic>> sendOtpByEmail(Map<String, dynamic> data) async {
    final resp = await userRemoteDataSource.sendOtpByEmail(data);
    return resp.data;
  }

  @override
  Future<Map<String, dynamic>> updatePassword(Map<String, dynamic> data) async {
    final resp = await userRemoteDataSource.updatePassword(data);
    return resp.data;
  }

  @override
  Future<Map<String, dynamic>> verifyOtpByEmail(
      Map<String, dynamic> data) async {
    final resp = await userRemoteDataSource.verifyOtpByEmail(data);
    return resp.data;
  }

  @override
  Future<Map<String, dynamic>> sendUserTempOtp(
      Map<String, dynamic> data) async {
    final resp = await userRemoteDataSource.sendUserTempOtp(data);
    return resp.data;
  }

  @override
  Future<Map<String, dynamic>> verifyUserTempOtp(
      Map<String, dynamic> data) async {
    final resp = await userRemoteDataSource.verifyUserTempOtp(data);
    return resp.data;
  }

  @override
  Future<Map<String, dynamic>> resendUserTempOtp(
      Map<String, dynamic> data) async {
    final resp = await userRemoteDataSource.resendUserTempOtp(data);
    return resp.data;
  }

  @override
  Future<Map<String, dynamic>> signInWithEmail({
    required String email,
    required String password,
    required String latitude,
    required String longitude,
  }) async {
    final resp = await userRemoteDataSource.signInWithEmail(
      email: email,
      password: password,
      latitude: latitude,
      longitude: longitude,
    );
    return resp.data;
  }

  @override
  Future<Map<String, dynamic>> signInWithGoogle({
    required String idToken,
    required String latitude,
    required String longitude,
  }) async {
    final resp = await userRemoteDataSource.signInWithGoogle(
      idToken: idToken,
      latitude: latitude,
      longitude: longitude,
    );
    return resp.data;
  }
}
