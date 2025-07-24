import 'package:ambition_delivery/data/models/vehicle_fares_model.dart';

import '../../domain/entities/vehicle_category.dart';

class VehicleCategoryModel extends VehicleCategory {
  VehicleCategoryModel({
    required super.id,
    required super.name,
    required super.vehicleType,
    required super.passengerCapacity,
    required super.fares,
  });

  factory VehicleCategoryModel.fromJson(Map<String, dynamic> json) {
    return VehicleCategoryModel(
      id: json['_id'],
      name: json['name'],
      vehicleType: json['vehicleType'],
      passengerCapacity: json['passengerCapacity'],
      fares: json['fares'] != null
          ? VehicleFaresModel.fromJson(json['fares'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': super.id,
      'name': super.name,
      'vehicleType': super.vehicleType,
      'passengerCapacity': super.passengerCapacity,
      'fares': super.fares != null
          ? VehicleFaresModel.fromEntity(super.fares!).toJson()
          : null,
    };
  }

  VehicleCategory toEntity() {
    return VehicleCategory(
      id: super.id,
      name: super.name,
      vehicleType: super.vehicleType,
      passengerCapacity: super.passengerCapacity,
      fares: super.fares != null
          ? VehicleFaresModel.fromEntity(super.fares!).toEntity()
          : null,
    );
  }

// From entity to model
  static VehicleCategoryModel fromEntity(VehicleCategory entity) {
    return VehicleCategoryModel(
      id: entity.id,
      name: entity.name,
      vehicleType: entity.vehicleType,
      passengerCapacity: entity.passengerCapacity,
      fares: entity.fares != null
          ? VehicleFaresModel.fromEntity(entity.fares!).toEntity()
          : null,
    );
  }

  static List<VehicleCategoryModel> fromJsonList(List list) {
    return list.map((item) => VehicleCategoryModel.fromJson(item)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(
      List<VehicleCategoryModel> list) {
    return list.map((item) => item.toJson()).toList();
  }

  static VehicleCategoryModel empty() {
    return VehicleCategoryModel(
      id: '',
      name: '',
      vehicleType: '',
      passengerCapacity: 0,
      fares: null,
    );
  }
}
