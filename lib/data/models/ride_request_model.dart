import 'package:ambition_delivery/data/models/item_with_qty_model.dart';
import 'package:ambition_delivery/data/models/location_model.dart';
import 'package:ambition_delivery/data/models/polyline_point_model.dart';
import 'package:ambition_delivery/data/models/ride_fare_model.dart';
import 'package:ambition_delivery/domain/entities/driver.dart';
import 'package:ambition_delivery/domain/entities/ride_request.dart';
import 'package:ambition_delivery/domain/entities/car.dart';
import 'package:ambition_delivery/domain/entities/location_entity.dart';
import 'package:ambition_delivery/domain/entities/vehicle_category.dart';

import 'custom_item_model.dart';
import 'other_requirements_model.dart';
import 'driver_model.dart';

class RideRequestModel extends RideRequest {
  RideRequestModel(
      {required super.id,
      required super.user,
      required super.driverId,
      required super.carDriverId,
      required super.vehicleCategory,
      required super.carCategory,
      required super.moveType,
      required super.jobType,
      required super.isRideAndMove,
      required super.isEventJob,
      required super.passengersCount,
      required super.pickupLocation,
      required super.dropoffLocation,
      required super.polyline,
      required super.distance,
      required super.time,
      required super.fare,
      required super.items,
      required super.customItems,
      required super.requirements,
      required super.status,
      required super.createdAt,
      required super.updatedAt,
      required super.driver});

  factory RideRequestModel.fromJson(Map<String, dynamic> json) {
    return RideRequestModel(
      id: json['_id'],
      user: json['user'],
      driverId: json['driverId'],
      carDriverId: json['carDriverId'],
      vehicleCategory: json['vehicleCategory'],
      carCategory: json['carCategory'],
      moveType: json['moveType'],
      jobType: json['jobType'],
      isRideAndMove: json['isRideAndMove'],
      isEventJob: json['isEventJob'],
      passengersCount: json['passengersCount'],
      pickupLocation: LocationModel.fromJson(json['pickupLocation']),
      dropoffLocation: LocationModel.fromJson(json['dropoffLocation']),
      polyline: json['polylinePoints'].runtimeType == String
          ? []
          : (json['polylinePoints'] as List)
              .map((e) => PolylinePointModel.fromJson(e))
              .toList(),
      distance: json['distance'],
      time: json['time'],
      fare: RideFareModel.fromJson(json['fare']),
      items: (json['items'] as List)
          .map((e) => ItemWithQtyModel.fromJson(e))
          .toList(),
      customItems: (json['customItems'] as List)
          .map((e) => CustomItemModel.fromJson(e))
          .toList(),
      requirements: OtherRequirementsModel.fromJson(json['requirements']),
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']).toLocal(),
      updatedAt: DateTime.parse(json['updatedAt']).toLocal(),
      driver: json['driver'] != null && json['driver'] is Map<String, dynamic>
          ? DriverModel.fromJson(json['driver']).toEntity()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': super.id,
      'user': super.user,
      'driverId': super.driverId,
      'carDriverId': super.carDriverId,
      'vehicleCategory': super.vehicleCategory,
      'carCategory': super.carCategory,
      'moveType': super.moveType,
      'jobType': super.jobType,
      'isRideAndMove': super.isRideAndMove,
      'isEventJob': super.isEventJob,
      'passengersCount': super.passengersCount,
      'pickupLocation': (super.pickupLocation as LocationModel).toJson(),
      'dropoffLocation': (super.dropoffLocation as LocationModel).toJson(),
      'distance': super.distance,
      'time': super.time,
      'fare': (super.fare as RideFareModel).toJson(),
      'items':
          super.items.map((e) => (e as ItemWithQtyModel).toJson()).toList(),
      'customItems': super
          .customItems
          .map((e) => (e as CustomItemModel).toJson())
          .toList(),
      'requirements': (super.requirements as OtherRequirementsModel).toJson(),
      'status': super.status,
      'createdAt': super.createdAt.toIso8601String(),
      'updatedAt': super.updatedAt.toIso8601String(),
    };
  }

  RideRequest toEntity() {
    return RideRequest(
      id: super.id,
      user: super.user,
      driverId: super.driverId,
      carDriverId: super.carDriverId,
      vehicleCategory: super.vehicleCategory,
      carCategory: super.carCategory,
      moveType: super.moveType,
      jobType: super.jobType,
      isRideAndMove: super.isRideAndMove,
      isEventJob: super.isEventJob,
      passengersCount: super.passengersCount,
      pickupLocation: super.pickupLocation,
      dropoffLocation: super.dropoffLocation,
      polyline: super.polyline,
      distance: super.distance,
      time: super.time,
      fare: super.fare,
      items: super.items,
      customItems: super.customItems,
      requirements: super.requirements,
      status: super.status,
      createdAt: super.createdAt,
      updatedAt: super.updatedAt,
      driver: super.driver,
    );
  }

  factory RideRequestModel.fromEntity(RideRequest entity) {
    return RideRequestModel(
      id: entity.id,
      user: entity.user,
      driverId: entity.driverId,
      carDriverId: entity.carDriverId,
      vehicleCategory: entity.vehicleCategory,
      carCategory: entity.carCategory,
      moveType: entity.moveType,
      jobType: entity.jobType,
      isRideAndMove: entity.isRideAndMove,
      isEventJob: entity.isEventJob,
      passengersCount: entity.passengersCount,
      pickupLocation: entity.pickupLocation,
      dropoffLocation: entity.dropoffLocation,
      polyline: entity.polyline,
      distance: entity.distance,
      time: entity.time,
      fare: entity.fare,
      items: entity.items,
      customItems: entity.customItems,
      requirements: entity.requirements,
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      driver: entity.driver,
    );
  }

  static List<RideRequestModel> fromJsonList(List list) {
    return list.map((item) => RideRequestModel.fromJson(item)).toList();
  }

  static List<Map<String, dynamic>> fromEntityList(List list) {
    return list.map((item) => (item as RideRequestModel).toJson()).toList();
  }

  static List<RideRequest> toEntityList(List list) {
    return list.map((item) => (item as RideRequestModel).toEntity()).toList();
  }
}
