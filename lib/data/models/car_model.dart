import 'package:ambition_delivery/data/models/vehicle_category_model.dart';
import 'package:ambition_delivery/domain/entities/car.dart';

class CarModel extends Car {
  CarModel(
      {required super.category,
      required super.make,
      required super.year,
      required super.model,
      required super.color,
      required super.plate});

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      category: VehicleCategoryModel.fromJson(json['category']),
      make: json['make'],
      year: json['year'],
      model: json['model'],
      color: json['color'],
      plate: json['plate'],
    );
  }

  factory CarModel.fromEntity(Car entity) {
    return CarModel(
      category: entity.category,
      make: entity.make,
      year: entity.year,
      model: entity.model,
      color: entity.color,
      plate: entity.plate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': VehicleCategoryModel.fromEntity(category).toJson(),
      'make': make,
      'year': year,
      'model': model,
      'color': color,
      'plate': plate,
    };
  }

  Car toEntity() {
    return Car(
      category: category,
      make: make,
      year: year,
      model: model,
      color: color,
      plate: plate,
    );
  }

  static List<CarModel> fromJsonList(List list) {
    return list.map((item) => CarModel.fromJson(item)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<CarModel> list) {
    return list.map((item) => item.toJson()).toList();
  }

  static List<Car> toEntityList(List<CarModel> list) {
    return list.map((item) => item.toEntity()).toList();
  }

  static List<CarModel> fromEntityList(List<Car> list) {
    return list
        .map((item) => CarModel(
              category: item.category,
              make: item.make,
              year: item.year,
              model: item.model,
              color: item.color,
              plate: item.plate,
            ))
        .toList();
  }
}
