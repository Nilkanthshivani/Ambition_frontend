// domain/entities/user.dart

import 'location_entity.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String profile;
  final String? phone;
  final LocationEntity location;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.profile,
    this.phone,
    required this.location,
  });
}
