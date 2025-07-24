import 'package:ambition_delivery/domain/entities/custom_item.dart';
import 'package:ambition_delivery/domain/entities/item_with_qty.dart';
import 'package:ambition_delivery/domain/entities/location_entity.dart';
import 'package:ambition_delivery/domain/entities/other_requirements_entity.dart';
import 'package:ambition_delivery/domain/entities/polyline_point_entity.dart';
import 'package:ambition_delivery/domain/entities/ride_fare.dart';
import 'package:ambition_delivery/domain/entities/driver.dart';

class RideRequest {
  final String id;
  final String user;
  final String? driverId;
  final String? carDriverId;
  final String vehicleCategory;
  final String? carCategory;
  final String moveType;
  final String jobType;
  final bool isRideAndMove;
  final bool isEventJob;
  final int passengersCount;
  final LocationEntity pickupLocation;
  final LocationEntity dropoffLocation;
  final List<PolylinePointEntity> polyline;
  final num distance;
  final num time;
  final RideFare fare;
  final List<ItemWithQty> items;
  final List<CustomItem> customItems;
  final OtherRequirementsEntity requirements;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Driver? driver;

  RideRequest({
    required this.id,
    required this.user,
    this.driverId,
    this.carDriverId,
    required this.vehicleCategory,
    this.carCategory,
    required this.moveType,
    required this.jobType,
    required this.isRideAndMove,
    required this.isEventJob,
    required this.passengersCount,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.polyline,
    required this.distance,
    required this.time,
    required this.fare,
    required this.items,
    required this.customItems,
    required this.requirements,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.driver,
  });
}
