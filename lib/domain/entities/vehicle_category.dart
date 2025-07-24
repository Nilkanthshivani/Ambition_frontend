import 'package:ambition_delivery/domain/entities/vehicle_fares.dart';

enum VehicleCategoryEnum { car, van, truck }

class VehicleCategory {
  final String id;
  final String name;
  final String vehicleType;
  final int passengerCapacity;
  final VehicleFares? fares;

  static var car;

  VehicleCategory({
    required this.id,
    required this.name,
    required this.vehicleType,
    required this.passengerCapacity,
    required this.fares,
  });

  static fromJson(json) {}
}
