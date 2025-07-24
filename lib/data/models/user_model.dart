import 'package:ambition_delivery/data/models/location_model.dart';

import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel(
      {required super.id,
      required super.name,
      required super.email,
      required super.profile,
      required super.phone,
      required super.location});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? json['_id'],
      name: json['name'],
      email: json['email'],
      profile: json['profile'],
      phone: json['phone'],
      location: LocationModel.fromJson(json['location']),
    );
  }

  factory UserModel.fromEntity(User entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      profile: entity.profile,
      phone: entity.phone,
      location: LocationModel.fromEntity(entity.location),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'profile': profile,
      'phone': phone,
      'location': LocationModel.fromEntity(location).toJson(),
    };
  }

  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      profile: profile,
      phone: phone,
      location: LocationModel.fromEntity(location).toEntity(),
    );
  }

  static List<UserModel> fromJsonList(List list) {
    return list.map((item) => UserModel.fromJson(item)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<UserModel> list) {
    return list.map((item) => item.toJson()).toList();
  }
}
