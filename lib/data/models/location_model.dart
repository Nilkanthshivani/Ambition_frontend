import '../../domain/entities/location_entity.dart';

class LocationModel extends LocationEntity {
  LocationModel(
      {required super.type,
      required super.coordinates,
      super.name,
      super.address});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      type: json['type'],
      coordinates: List<num>.from(json['coordinates']),
      name: json['name'],
      address: json['address'],
    );
  }

  factory LocationModel.fromEntity(LocationEntity entity) {
    return LocationModel(
      type: entity.type,
      coordinates: entity.coordinates,
      name: entity.name,
      address: entity.address,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
      'name': name,
      'address': address,
    };
  }

  LocationEntity toEntity() {
    return LocationEntity(
      type: type,
      coordinates: coordinates,
      name: name,
      address: address,
    );
  }

  static List<LocationModel> fromJsonList(List list) {
    return list.map((item) => LocationModel.fromJson(item)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<LocationModel> list) {
    return list.map((item) => item.toJson()).toList();
  }
}
