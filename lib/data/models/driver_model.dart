import '../../domain/entities/driver.dart';
import 'car_model.dart';
import 'location_model.dart';

class DriverModel extends Driver {
  DriverModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.licenseCheckCode,
    required super.profile,
    required super.licenseFront,
    required super.licenseBack,
    required super.licensePlatePicture,
    required super.vehicleFrontPicture,
    required super.vehicleBackPicture,
    required super.vehicleLeftPicture,
    required super.vehicleRightPicture,
    required super.vehicleInsurancePicture,
    required super.publicLiabilityInsurancePicture,
    required super.goodsInTransitInsurancePicture,
    required super.pcoLicensePicture,
    required super.accountName,
    required super.accountNumber,
    required super.accountSortCode,
    required super.status,
    required super.location,
    required super.car,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      licenseCheckCode: json['licenseCheckCode'],
      profile: json['profile'],
      licenseFront: json['driverLicenseFront'],
      licenseBack: json['driverLicenseBack'],
      licensePlatePicture: json['licensePlatePicture'],
      vehicleFrontPicture: json['vehicleFrontPicture'],
      vehicleBackPicture: json['vehicleBackPicture'],
      vehicleLeftPicture: json['vehicleLeftPicture'],
      vehicleRightPicture: json['vehicleRightPicture'],
      vehicleInsurancePicture: json['vehicleInsurancePicture'],
      publicLiabilityInsurancePicture: json['publicLiabilityInsurancePicture'],
      goodsInTransitInsurancePicture: json['goodsInTransitInsurancePicture'],
      pcoLicensePicture: json['pcoLicensePicture'],
      accountName: json['accountName'],
      accountNumber: json['accountNumber'],
      accountSortCode: json['accountSortCode'],
      status: json['status'],
      location: LocationModel.fromJson(json['location']),
      car: (json['car'] is Map<String, dynamic>)
          ? CarModel.fromJson(json['car'])
          : CarModel.empty(),
    );
  }

  factory DriverModel.fromEntity(Driver entity) {
    return DriverModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      licenseCheckCode: entity.licenseCheckCode,
      phone: entity.phone,
      profile: entity.profile,
      licenseFront: entity.licenseFront,
      licenseBack: entity.licenseBack,
      licensePlatePicture: entity.licensePlatePicture,
      vehicleFrontPicture: entity.vehicleFrontPicture,
      vehicleBackPicture: entity.vehicleBackPicture,
      vehicleLeftPicture: entity.vehicleLeftPicture,
      vehicleRightPicture: entity.vehicleRightPicture,
      vehicleInsurancePicture: entity.vehicleInsurancePicture,
      publicLiabilityInsurancePicture: entity.publicLiabilityInsurancePicture,
      goodsInTransitInsurancePicture: entity.goodsInTransitInsurancePicture,
      pcoLicensePicture: entity.pcoLicensePicture,
      accountName: entity.accountName,
      accountNumber: entity.accountNumber,
      accountSortCode: entity.accountSortCode,
      status: entity.status,
      location: LocationModel.fromEntity(entity.location),
      car: CarModel.fromEntity(entity.car),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'licenseCheckCode': licenseCheckCode,
      'profile': profile,
      'driverLicenseFront': licenseFront,
      'driverLicenseBack': licenseBack,
      'licensePlatePicture': licensePlatePicture,
      'vehicleFrontPicture': vehicleFrontPicture,
      'vehicleBackPicture': vehicleBackPicture,
      'vehicleLeftPicture': vehicleLeftPicture,
      'vehicleRightPicture': vehicleRightPicture,
      'vehicleInsurancePicture': vehicleInsurancePicture,
      'publicLiabilityInsurancePicture': publicLiabilityInsurancePicture,
      'goodsInTransitInsurancePicture': goodsInTransitInsurancePicture,
      'pcoLicensePicture': pcoLicensePicture,
      'accountName': accountName,
      'accountNumber': accountNumber,
      'accountSortCode': accountSortCode,
      'status': status,
      'location': LocationModel.fromEntity(location).toJson(),
      'car': CarModel.fromEntity(car).toJson(),
    };
  }

  Driver toEntity() {
    return Driver(
      id: id,
      name: name,
      email: email,
      phone: phone,
      profile: profile,
      licenseCheckCode: licenseCheckCode,
      licenseFront: licenseFront,
      licenseBack: licenseBack,
      licensePlatePicture: licensePlatePicture,
      vehicleFrontPicture: vehicleFrontPicture,
      vehicleBackPicture: vehicleBackPicture,
      vehicleLeftPicture: vehicleLeftPicture,
      vehicleRightPicture: vehicleRightPicture,
      vehicleInsurancePicture: vehicleInsurancePicture,
      publicLiabilityInsurancePicture: publicLiabilityInsurancePicture,
      goodsInTransitInsurancePicture: goodsInTransitInsurancePicture,
      pcoLicensePicture: pcoLicensePicture,
      accountName: accountName,
      accountNumber: accountNumber,
      accountSortCode: accountSortCode,
      status: status,
      location: LocationModel.fromEntity(location).toEntity(),
      car: CarModel.fromEntity(car).toEntity(),
    );
  }

  static List<DriverModel> fromJsonList(List list) {
    return list.map((item) => DriverModel.fromJson(item)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<DriverModel> list) {
    return list.map((item) => item.toJson()).toList();
  }

  static List<Driver> toEntityList(List<DriverModel> list) {
    return list.map((item) => item.toEntity()).toList();
  }

  static List<DriverModel> fromEntityList(List<Driver> list) {
    return list
        .map((item) => DriverModel(
              id: item.id,
              name: item.name,
              email: item.email,
              phone: item.phone,
              licenseCheckCode: item.licenseCheckCode,
              profile: item.profile,
              licenseFront: item.licenseFront,
              licenseBack: item.licenseBack,
              licensePlatePicture: item.licensePlatePicture,
              vehicleFrontPicture: item.vehicleFrontPicture,
              vehicleBackPicture: item.vehicleBackPicture,
              vehicleLeftPicture: item.vehicleLeftPicture,
              vehicleRightPicture: item.vehicleRightPicture,
              vehicleInsurancePicture: item.vehicleInsurancePicture,
              publicLiabilityInsurancePicture:
                  item.publicLiabilityInsurancePicture,
              goodsInTransitInsurancePicture:
                  item.goodsInTransitInsurancePicture,
              pcoLicensePicture: item.pcoLicensePicture,
              accountName: item.accountName,
              accountNumber: item.accountNumber,
              accountSortCode: item.accountSortCode,
              status: item.status,
              location: item.location,
              car: CarModel.fromEntity(item.car),
            ))
        .toList();
  }
}
