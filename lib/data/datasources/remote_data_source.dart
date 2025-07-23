import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:ambition_delivery/data/models/instruction_model.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class RemoteDataSource {
  final Dio dio;

  final String baseUrl;

  RemoteDataSource({required this.dio, required this.baseUrl});

  Future<Map<String, dynamic>> createUser(Map<String, dynamic> user) async {
    final formData = FormData.fromMap({
      'name': user['name'],
      'email': user['email'],
      'phone': user['phone'],
      "latitude": user['latitude'],
      "longitude": user['longitude'],
      if (user['profile'] != null)
        "profile": MultipartFile.fromFileSync(user['profile'].path,
            filename: user['profile'].path.split('/').last,
            contentType: MediaType('image', 'jpeg')),
    });
    final response = await dio.post('${baseUrl}users', data: formData);
    if (response.statusCode == 201) {
      return response.data;
    } else {
      throw Exception('Failed to create user');
    }
  }

  Future<Response> updateUser(String id, Map<String, dynamic> user) async {
    final formData = FormData.fromMap({});
    if (user['profile'] != null) {
      formData.files.add(MapEntry(
        'profile',
        MultipartFile.fromFileSync(user['profile'].path,
            filename: user['profile'].path.split('/').last,
            contentType: MediaType('image', 'jpeg')),
      ));
    }
    if (user['name'] != null) {
      formData.fields.add(MapEntry('name', user['name']));
    }
    if (user['email'] != null) {
      formData.fields.add(MapEntry('email', user['email']));
    }
    if (user['phone'] != null) {
      formData.fields.add(MapEntry('phone', user['phone']));
    }
    final response = await dio.put(
      '${baseUrl}users/$id',
      data: formData,
    );
    return response;
  }

  Future<Response> deleteUser(String id) async {
    final response = await dio.delete(
      '${baseUrl}users/$id',
    );
    return response;
  }

  //delete by phone number
  Future<Response> deleteUserByPhoneNumber(String phoneNumber) async {
    final response = await dio.delete(
      '${baseUrl}users/byPhone/$phoneNumber',
    );
    return response;
  }

  Future<Response> getUser(String id) async {
    final response = await dio.get(
      '${baseUrl}users/byId/$id',
      options: Options(
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      ),
    );
    return response;
  }

  Future<Response> getUsers() async {
    final response = await dio.get(
      '${baseUrl}users',
    );
    return response;
  }

  //Get user location by user id
  Future<Response> getUserLocation(String id) async {
    final response = await dio.get(
      '${baseUrl}users/location/$id',
    );
    return response;
  }

  //update user location by user id
  Future<Response> updateUserLocation(
      String id, Map<String, dynamic> location) async {
    final response = await dio.put(
      '${baseUrl}users/location/$id',
      data: location,
    );
    return response;
  }

  Future<Response> sendUserLoginOtp(Map<String, dynamic> data) async {
    final response = await dio.post(
      '${baseUrl}users/send-user-login-otp',
      data: data,
    );
    return response;
  }

  Future<Response> resendUserLoginOtp(Map<String, dynamic> data) async {
    final response = await dio.post(
      '${baseUrl}users/resend-user-login-otp',
      data: data,
    );
    return response;
  }

  Future<Response> verifyUserLoginOtp(Map<String, dynamic> data) async {
    final response = await dio.post(
      '${baseUrl}users/verify-user-login-otp',
      data: data,
    );
    return response;
  }

  // Create User Temp OTP
  Future<Response> sendUserTempOtp(Map<String, dynamic> data) async {
    print('Sending user temp OTP with data: $data');
    final response = await dio.post(
      '${baseUrl}users/temp-otp',
      data: data,
    );
    return response;
  }

  // Verify User Temp OTP
  Future<Response> verifyUserTempOtp(Map<String, dynamic> data) async {
    final response = await dio.post(
      '${baseUrl}users/verify-temp-otp',
      data: data,
    );
    return response;
  }

  // Resend User Temp OTP
  Future<Response> resendUserTempOtp(Map<String, dynamic> data) async {
    final response = await dio.post(
      '${baseUrl}users/resend-temp-otp',
      data: data,
    );
    return response;
  }

  // Update password
  Future<Response> updatePassword(Map<String, dynamic> data) async {
    final response = await dio.post(
      '${baseUrl}users/update-password',
      data: data,
    );
    return response;
  }

  // Send OTP to email's associated phone
  Future<Response> sendOtpByEmail(Map<String, dynamic> data) async {
    final response = await dio.post(
      '${baseUrl}users/send-otp',
      data: data,
    );
    return response;
  }

  // Resend OTP to email's associated phone
  Future<Response> resendOtpByEmail(Map<String, dynamic> data) async {
    final response = await dio.post(
      '${baseUrl}users/resend-otp-email',
      data: data,
    );
    return response;
  }

  // Verify OTP by email
  Future<Response> verifyOtpByEmail(Map<String, dynamic> data) async {
    final response = await dio.post(
      '${baseUrl}users/verify-otp-email',
      data: data,
    );
    return response;
  }

  Future<Response> verifyOtp(Map<String, dynamic> otp) async {
    final response = await dio.post(
      '${baseUrl}users/verify-otp',
      data: otp,
    );
    return response;
  }

  Future<Response> resendOtp(Map<String, dynamic> otp) async {
    final response = await dio.post(
      '${baseUrl}users/resend-otp',
      data: otp,
    );
    return response;
  }


Future<Response> createDriver(Map<String, dynamic> driver) async {
  FormData formData = FormData.fromMap({
    'name': driver['name'],
    'email': driver['email'],
    'password': driver['password'],
    'phone': driver['phone'],
    "latitude": driver['latitude'],
    "longitude": driver['longitude'],
    "vehicleCategory": driver['vehicleCategory'],
    "licenseCheckCode": driver['licenseCheckCode'],
    "accountName": driver['accountName'],
    "accountNumber": driver['accountNumber'],
    "accountSortCode": driver['accountSortCode'],
    "carMake": driver['carMake'],
    "carModel": driver['carModel'],
    "carYear": driver['carYear'],
    "carPlate": driver['carPlate'],
    "carColor": driver['carColor'],
    'profile': MultipartFile.fromFileSync(driver['profile'].path,
        filename: driver['profile'].path.split('/').last,
        contentType: MediaType('image', 'jpeg')),
    'driverLicenseFront': MultipartFile.fromFileSync(
        driver['driverLicenseFront'].path,
        filename: driver['driverLicenseFront'].path.split('/').last,
        contentType: MediaType('image', 'jpeg')),
    'driverLicenseBack': MultipartFile.fromFileSync(
        driver['driverLicenseBack'].path,
        filename: driver['driverLicenseBack'].path.split('/').last,
        contentType: MediaType('image', 'jpeg')),
    "licensePlatePicture": MultipartFile.fromFileSync(
        driver['licensePlatePicture'].path,
        filename: driver['licensePlatePicture'].path.split('/').last,
        contentType: MediaType('image', 'jpeg')),
    "vehicleFrontPicture": MultipartFile.fromFileSync(
        driver['vehicleFrontPicture'].path,
        filename: driver['vehicleFrontPicture'].path.split('/').last,
        contentType: MediaType('image', 'jpeg')),
    "vehicleBackPicture": MultipartFile.fromFileSync(
        driver['vehicleBackPicture'].path,
        filename: driver['vehicleBackPicture'].path.split('/').last,
        contentType: MediaType('image', 'jpeg')),
    "vehicleLeftPicture": MultipartFile.fromFileSync(
        driver['vehicleLeftPicture'].path,
        filename: driver['vehicleLeftPicture'].path.split('/').last,
        contentType: MediaType('image', 'jpeg')),
    "vehicleRightPicture": MultipartFile.fromFileSync(
        driver['vehicleRightPicture'].path,
        filename: driver['vehicleRightPicture'].path.split('/').last,
        contentType: MediaType('image', 'jpeg')),
    "vehicleInsurancePicture": MultipartFile.fromFileSync(
        driver['vehicleInsurancePicture'].path,
        filename: driver['vehicleInsurancePicture'].path.split('/').last,
        contentType: MediaType('image', 'jpeg')),
    "publicLiabilityInsurancePicture": MultipartFile.fromFileSync(
        driver['publicLiabilityInsurancePicture'].path,
        filename: driver['publicLiabilityInsurancePicture'].path.split('/').last,
        contentType: MediaType('image', 'jpeg')),
    if (driver['goodsInTransitInsurancePicture'] != null)
      'goodsInTransitInsurancePicture': MultipartFile.fromFileSync(
          driver['goodsInTransitInsurancePicture'].path,
          filename: driver['goodsInTransitInsurancePicture'].path.split('/').last,
          contentType: MediaType('image', 'jpeg')),
    if (driver['pcoLicensePicture'] != null)
      'pcoLicensePicture': MultipartFile.fromFileSync(
          driver['pcoLicensePicture'].path,
          filename: driver['pcoLicensePicture'].path.split('/').last,
          contentType: MediaType('image', 'jpeg')),
  });

  // Build a simulated JSON-like request for logging
  Map<String, dynamic> simulatedRequestBody = {};

  // Add text fields
  for (var field in formData.fields) {
    simulatedRequestBody[field.key] = field.value;
  }

  // Add files with metadata
  for (var file in formData.files) {
    simulatedRequestBody[file.key] = {
      'filename': file.value.filename,
      'contentType': file.value.contentType.toString(),
    };
  }

  // Pretty print as JSON using Flutter's `log`
  final encoder = JsonEncoder.withIndent('  ');
  final prettyBody = encoder.convert(simulatedRequestBody);
  log('Sending driver creation request:\n$prettyBody', name: 'createDriver');

  // Send the request
  final response = await dio.post(
    '${baseUrl}drivers',
    data: formData,
  );

  return response;
}




//   Future<Response> createDriver(Map<String, dynamic> driver) async {
//     FormData formData = FormData.fromMap({
//       'name': driver['name'],
//       'email': driver['email'],
//       'password': driver['password'],
//       'phone': driver['phone'],
//       "latitude": driver['latitude'],
//       "longitude": driver['longitude'],
//       "vehicleCategory": driver['vehicleCategory'],
//       "licenseCheckCode": driver['licenseCheckCode'],
//       "accountName": driver['accountName'],
//       "accountNumber": driver['accountNumber'],
//       "accountSortCode": driver['accountSortCode'],
//       "carMake": driver['carMake'],
//       "carModel": driver['carModel'],
//       "carYear": driver['carYear'],
//       "carPlate": driver['carPlate'],
//       "carColor": driver['carColor'],
//       'profile': MultipartFile.fromFileSync(driver['profile'].path,
//           filename: driver['profile'].path.split('/').last,
//           contentType: MediaType('image', 'jpeg')),
//       'driverLicenseFront': MultipartFile.fromFileSync(
//           driver['driverLicenseFront'].path,
//           filename: driver['driverLicenseFront'].path.split('/').last,
//           contentType: MediaType('image', 'jpeg')),
//       'driverLicenseBack': MultipartFile.fromFileSync(
//           driver['driverLicenseBack'].path,
//           filename: driver['driverLicenseBack'].path.split('/').last,
//           contentType: MediaType('image', 'jpeg')),
//       "licensePlatePicture": MultipartFile.fromFileSync(
//           driver['licensePlatePicture'].path,
//           filename: driver['licensePlatePicture'].path.split('/').last,
//           contentType: MediaType('image', 'jpeg')),
//       "vehicleFrontPicture": MultipartFile.fromFileSync(
//           driver['vehicleFrontPicture'].path,
//           filename: driver['vehicleFrontPicture'].path.split('/').last,
//           contentType: MediaType('image', 'jpeg')),
//       "vehicleBackPicture": MultipartFile.fromFileSync(
//           driver['vehicleBackPicture'].path,
//           filename: driver['vehicleBackPicture'].path.split('/').last,
//           contentType: MediaType('image', 'jpeg')),
//       "vehicleLeftPicture": MultipartFile.fromFileSync(
//           driver['vehicleLeftPicture'].path,
//           filename: driver['vehicleLeftPicture'].path.split('/').last,
//           contentType: MediaType('image', 'jpeg')),
//       "vehicleRightPicture": MultipartFile.fromFileSync(
//           driver['vehicleRightPicture'].path,
//           filename: driver['vehicleRightPicture'].path.split('/').last,
//           contentType: MediaType('image', 'jpeg')),
//       "vehicleInsurancePicture": MultipartFile.fromFileSync(
//           driver['vehicleInsurancePicture'].path,
//           filename: driver['vehicleInsurancePicture'].path.split('/').last,
//           contentType: MediaType('image', 'jpeg')),
//       "publicLiabilityInsurancePicture": MultipartFile.fromFileSync(
//           driver['publicLiabilityInsurancePicture'].path,
//           filename:
//               driver['publicLiabilityInsurancePicture'].path.split('/').last,
//           contentType: MediaType('image', 'jpeg')),
//       if (driver['goodsInTransitInsurancePicture'] != null)
//         'goodsInTransitInsurancePicture': MultipartFile.fromFileSync(
//             driver['goodsInTransitInsurancePicture'].path,
//             filename:
//                 driver['goodsInTransitInsurancePicture'].path.split('/').last,
//             contentType: MediaType('image', 'jpeg')),
//       if (driver['pcoLicensePicture'] != null)
//         'pcoLicensePicture': MultipartFile.fromFileSync(
//             driver['pcoLicensePicture'].path,
//             filename: driver['pcoLicensePicture'].path.split('/').last,
//             contentType: MediaType('image', 'jpeg')),
//     });
//  print('Creating driver with data: $formData');
//     final response = await dio.post(
//       '${baseUrl}drivers',
//       data: formData,
//     );
//     return response;
//   }

  Future<Response> updateDriver(String id, Map<String, dynamic> driver) async {
    FormData formData = FormData.fromMap({});
    if (driver['profile'] != null) {
      formData.files.add(MapEntry(
        'profile',
        MultipartFile.fromFileSync(driver['profile'].path,
            filename: driver['profile'].path.split('/').last,
            contentType: MediaType('image', 'jpeg')),
      ));
    }
    if (driver['name'] != null) {
      formData.fields.add(MapEntry('name', driver['name']));
    }
    if (driver['email'] != null) {
      formData.fields.add(MapEntry('email', driver['email']));
    }
    if (driver['phone'] != null) {
      formData.fields.add(MapEntry('phone', driver['phone']));
    }
    if (driver['vehicleCategory'] != null) {
      formData.fields
          .add(MapEntry('vehicleCategory', driver['vehicleCategory']));
    }
    if (driver['licenseCheckCode'] != null) {
      formData.fields
          .add(MapEntry('licenseCheckCode', driver['licenseCheckCode']));
    }
    if (driver['accountName'] != null) {
      formData.fields.add(MapEntry('accountName', driver['accountName']));
    }
    if (driver['accountNumber'] != null) {
      formData.fields.add(MapEntry('accountNumber', driver['accountNumber']));
    }
    if (driver['accountSortCode'] != null) {
      formData.fields
          .add(MapEntry('accountSortCode', driver['accountSortCode']));
    }
    if (driver['carMake'] != null) {
      formData.fields.add(MapEntry('carMake', driver['carMake']));
    }
    if (driver['carModel'] != null) {
      formData.fields.add(MapEntry('carModel', driver['carModel']));
    }
    if (driver['carYear'] != null) {
      formData.fields.add(MapEntry('carYear', driver['carYear']));
    }
    if (driver['carPlate'] != null) {
      formData.fields.add(MapEntry('carPlate', driver['carPlate']));
    }
    if (driver['carColor'] != null) {
      formData.fields.add(MapEntry('carColor', driver['carColor']));
    }
    if (driver['driverLicenseFront'] != null) {
      formData.files.add(MapEntry(
        'driverLicenseFront',
        MultipartFile.fromFileSync(driver['driverLicenseFront'].path,
            filename: driver['driverLicenseFront'].path.split('/').last,
            contentType: MediaType('image', 'jpeg')),
      ));
    }

    if (driver['driverLicenseBack'] != null) {
      formData.files.add(MapEntry(
        'driverLicenseBack',
        MultipartFile.fromFileSync(driver['driverLicenseBack'].path,
            filename: driver['driverLicenseBack'].path.split('/').last,
            contentType: MediaType('image', 'jpeg')),
      ));
    }

    if (driver['licensePlatePicture'] != null) {
      formData.files.add(MapEntry(
        'licensePlatePicture',
        MultipartFile.fromFileSync(driver['licensePlatePicture'].path,
            filename: driver['licensePlatePicture'].path.split('/').last,
            contentType: MediaType('image', 'jpeg')),
      ));
    }

    if (driver['vehicleFrontPicture'] != null) {
      formData.files.add(MapEntry(
        'vehicleFrontPicture',
        MultipartFile.fromFileSync(driver['vehicleFrontPicture'].path,
            filename: driver['vehicleFrontPicture'].path.split('/').last,
            contentType: MediaType('image', 'jpeg')),
      ));
    }

    if (driver['vehicleBackPicture'] != null) {
      formData.files.add(MapEntry(
        'vehicleBackPicture',
        MultipartFile.fromFileSync(driver['vehicleBackPicture'].path,
            filename: driver['vehicleBackPicture'].path.split('/').last,
            contentType: MediaType('image', 'jpeg')),
      ));
    }

    if (driver['vehicleLeftPicture'] != null) {
      formData.files.add(MapEntry(
        'vehicleLeftPicture',
        MultipartFile.fromFileSync(driver['vehicleLeftPicture'].path,
            filename: driver['vehicleLeftPicture'].path.split('/').last,
            contentType: MediaType('image', 'jpeg')),
      ));
    }

    if (driver['vehicleRightPicture'] != null) {
      formData.files.add(MapEntry(
        'vehicleRightPicture',
        MultipartFile.fromFileSync(driver['vehicleRightPicture'].path,
            filename: driver['vehicleRightPicture'].path.split('/').last,
            contentType: MediaType('image', 'jpeg')),
      ));
    }

    if (driver['vehicleInsurancePicture'] != null) {
      formData.files.add(MapEntry(
        'vehicleInsurancePicture',
        MultipartFile.fromFileSync(driver['vehicleInsurancePicture'].path,
            filename: driver['vehicleInsurancePicture'].path.split('/').last,
            contentType: MediaType('image', 'jpeg')),
      ));
    }

    if (driver['publicLiabilityInsurancePicture'] != null) {
      formData.files.add(MapEntry(
        'publicLiabilityInsurancePicture',
        MultipartFile.fromFileSync(
            driver['publicLiabilityInsurancePicture'].path,
            filename:
                driver['publicLiabilityInsurancePicture'].path.split('/').last,
            contentType: MediaType('image', 'jpeg')),
      ));
    }

    if (driver['goodsInTransitInsurancePicture'] != null) {
      formData.files.add(MapEntry(
        'goodsInTransitInsurancePicture',
        MultipartFile.fromFileSync(
            driver['goodsInTransitInsurancePicture'].path,
            filename:
                driver['goodsInTransitInsurancePicture'].path.split('/').last,
            contentType: MediaType('image', 'jpeg')),
      ));
    }

    if (driver['pcoLicensePicture'] != null) {
      formData.files.add(MapEntry(
        'pcoLicensePicture',
        MultipartFile.fromFileSync(driver['pcoLicensePicture'].path,
            filename: driver['pcoLicensePicture'].path.split('/').last,
            contentType: MediaType('image', 'jpeg')),
      ));
    }

    final response = await dio.put(
      '${baseUrl}drivers/$id',
      data: formData,
    );
    return response;
  }

  Future<Response> deleteDriver(String id) async {
    final response = await dio.delete(
      '${baseUrl}drivers/$id',
    );
    return response;
  }

  //delete by phone number
  Future<Response> deleteDriverByPhoneNumber(String phoneNumber) async {
    final response = await dio.delete(
      '${baseUrl}drivers/phone/$phoneNumber',
    );
    return response;
  }

  Future<Response> getDriver(String id) async {
    final response = await dio.get(
      '${baseUrl}drivers/$id',
    );
    return response;
  }

  //Get driver location by driver id
  Future<Response> getDriverLocation(String id) async {
    final response = await dio.get(
      '${baseUrl}drivers/location/$id',
    );
    return response;
  }

  //update driver location by driver id
  Future<Response> updateDriverLocation(
      String id, Map<String, dynamic> location) async {
    final response = await dio.put(
      '${baseUrl}drivers/location/$id',
      data: location,
    );
    return response;
  }

  Future<Response> getDrivers() async {
    final response = await dio.get(
      '${baseUrl}drivers',
    );
    return response;
  }

  Future<Response> sendDriverLoginOtp(Map<String, dynamic> data) async {
    final response = await dio.post(
      '${baseUrl}drivers/send-driver-login-otp',
      data: data,
    );
    return response;
  }

  Future<Response> resendDriverLoginOtp(Map<String, dynamic> data) async {
    final response = await dio.post(
      '${baseUrl}drivers/resend-driver-login-otp',
      data: data,
    );
    return response;
  }

  Future<Response> verifyDriverLoginOtp(Map<String, dynamic> data) async {
    final response = await dio.post(
      '${baseUrl}drivers/verify-driver-login-otp',
      data: data,
    );
    return response;
  }

  // Create User Temp OTP
  Future<Response> sendDriverTempOtp(Map<String, dynamic> data) async {
    final response = await dio.post(
      '${baseUrl}drivers/temp-otp',
      data: data,
    );
    return response;
  }

  // Verify User Temp OTP
  Future<Response> verifyDriverTempOtp(Map<String, dynamic> data) async {
    final response = await dio.post(
      '${baseUrl}drivers/verify-temp-otp',
      data: data,
    );
    return response;
  }

  // Resend User Temp OTP
  Future<Response> resendDriverTempOtp(Map<String, dynamic> data) async {
    final response = await dio.post(
      '${baseUrl}drivers/resend-temp-otp',
      data: data,
    );
    return response;
  }

  // Update driver password
  Future<Response> updateDriverPassword(Map<String, dynamic> data) async {
    final response = await dio.post(
      '${baseUrl}drivers/update-password',
      data: data,
    );
    return response;
  }

  // Send OTP to driver's associated phone by email
  Future<Response> sendOtpToDriverByEmail(Map<String, dynamic> data) async {
    final response = await dio.post(
      '${baseUrl}drivers/send-otp',
      data: data,
    );
    return response;
  }

  // Resend OTP to driver's associated phone by email
  Future<Response> resendOtpToDriverByEmail(Map<String, dynamic> data) async {
    final response = await dio.post(
      '${baseUrl}drivers/resend-otp-email',
      data: data,
    );
    return response;
  }

  // Verify OTP for driver by email
  Future<Response> verifyOtpForDriverByEmail(Map<String, dynamic> data) async {
    final response = await dio.post(
      '${baseUrl}drivers/verify-otp-email',
      data: data,
    );
    return response;
  }

  Future<Response> verifyDriverOtp(Map<String, dynamic> otp) async {
    final response = await dio.post(
      '${baseUrl}drivers/verify-otp',
      data: otp,
    );
    return response;
  }

  Future<Response> resendDriverOtp(Map<String, dynamic> otp) async {
    final response = await dio.post(
      '${baseUrl}drivers/resend-otp',
      data: otp,
    );
    return response;
  }

  Future<Response> createVehicle(Map<String, dynamic> vehicle) async {
    final response = await dio.post(
      '${baseUrl}vehicles',
      data: vehicle,
    );
    return response;
  }

  Future<Response> updateVehicle(Map<String, dynamic> vehicle) async {
    final response = await dio.put(
      '${baseUrl}vehicles/${vehicle['id']}',
      data: vehicle,
    );
    return response;
  }

  Future<Response> deleteVehicle(String id) async {
    final response = await dio.delete(
      '${baseUrl}vehicles/$id',
    );
    return response;
  }

  Future<Response> getVehicle(String id) async {
    final response = await dio.get(
      '${baseUrl}vehicles/$id',
    );
    return response;
  }

  Future<Response> getVehicles() async {
    final response = await dio.get(
      '${baseUrl}vehicles',
    );
    return response;
  }

  //Get all items
  Future<Response> getItems() async {
    final response = await dio.get(
      '${baseUrl}items',
    );
    return response;
  }

  //Get all vehicle categories
  Future<Response> getVehicleCategories() async {
    final response = await dio.get(
      '${baseUrl}vehicle-categories',
    );
    return response;
  }

  //Get vehicle category by id
  Future<Response> getVehicleCategory(String id) async {
    final response = await dio.get(
      '${baseUrl}vehicle-categories/$id',
    );
    return response;
  }

  //Get vehicle categories by items
  Future<Response> getVehicleCategoriesByItems(
      Map<String, dynamic> items) async {
    final response = await dio.post(
      '${baseUrl}vehicle-categories/items',
      data: items,
    );
    return response;
  }

  //Get vehicle categories by passenger capacity
  Future<Response> getVehicleCategoriesByPassengerCapacity(
      Map<String, dynamic> passengerCapacity) async {
    final response = await dio.post(
      '${baseUrl}vehicle-categories/passengers',
      data: passengerCapacity,
    );
    return response;
  }

  // Create vehicle category
  Future<Response> createVehicleCategory(
      Map<String, dynamic> vehicleCategory) async {
    final response = await dio.post(
      '${baseUrl}vehicle-categories',
      data: vehicleCategory,
    );
    return response;
  }

  // Update vehicle category
  Future<Response> updateVehicleCategory(
      Map<String, dynamic> vehicleCategory) async {
    final response = await dio.put(
      '${baseUrl}vehicle-categories/${vehicleCategory['id']}',
      data: vehicleCategory,
    );
    return response;
  }

  // Delete vehicle category
  Future<Response> deleteVehicleCategory(String id) async {
    final response = await dio.delete(
      '${baseUrl}vehicle-categories/$id',
    );
    return response;
  }

  //Create ride request
  Future<Response> createRideRequest(Map<String, dynamic> rideRequest) async {
    final response = await dio.post(
      '${baseUrl}ride-requests',
      data: rideRequest,
    );
    return response;
  }

  //Delete ride request
  Future<void> deleteRideRequest(String id) async {
    final response = await dio.delete(
      '${baseUrl}ride-requests/$id',
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete ride request');
    }
  }

  //Update ride request by driver id
  Future<Response> updateRideRequestByDriverId(
      Map<String, dynamic> rideRequest, String id) async {
    final response = await dio.put(
      '${baseUrl}ride-requests/$id/driver',
      data: rideRequest,
    );
    return response;
  }

  //Cancel ride request by ride id
  Future<Response> cancelRideRequest(String id) async {
    final response = await dio.put(
      '${baseUrl}ride-requests/cancel/$id',
    );
    return response;
  }

  //Complete ride request by ride id
  Future<Response> completeRideRequest(String id) async {
    final response = await dio.put(
      '${baseUrl}ride-requests/complete/$id',
    );
    return response;
  }

  //Get pending ride requests by driver car category
  Future<Response> getPendingRideRequestsByDriverCarCategory(String id) async {
    final response = await dio.get(
      '${baseUrl}ride-requests/driver/$id',
    );
    return response;
  }

  //Get ongoing ride request by user id
  Future<Response> getOngoingRideRequestByUserId(String id) async {
    final response = await dio.get(
      '${baseUrl}ride-requests/user/$id',
    );
    return response;
  }

  //Get ongoing ride request by driver id
  Future<Response> getOngoingRideRequestByDriverId(String id) async {
    final response = await dio.get(
      '${baseUrl}ride-requests/driver/ongoing/$id',
    );
    return response;
  }

  //get closed ride request by driver id
  Future<Response> getClosedRideRequestsByDriverId(String id) async {
    final response = await dio.get(
      '${baseUrl}ride-requests/driver/closed/$id',
    );
    return response;
  }

  //Get closed ride request by user id
  Future<Response> getClosedRideRequestsByUserId(String id) async {
    final response = await dio.get(
      '${baseUrl}ride-requests/user/closed/$id',
    );
    return response;
  }

  //Get polyline points between pickup and dropoff locations
  Future<Response> getPolylinePoints(Map<String, dynamic> data) async {
    final response = await dio.post(
      '${baseUrl}ride-requests/polyline',
      data: data,
    );
    return response;
  }

  //get conversation for a specific user/driver/admin
  Future<Response> getConversationById(String id) async {
    final response = await dio.get(
      '${baseUrl}chat/conversations/$id',
    );
    return response;
  }

  //get chat messages with a specific user/driver/admin
  Future<Response> getChatMessagesById(
      {required String userId, required String participantId}) async {
    final response = await dio.get(
      '${baseUrl}chat/$userId/$participantId',
    );
    return response;
  }

  //send message to a specific user/driver/admin
  Future<Response> sendMessage(Map<String, dynamic> message) async {
    final response = await dio.post(
      '${baseUrl}chat/message',
      data: message,
    );
    return response;
  }

  //Create repeat job
  Future<Response> createRepeatJob(Map<String, dynamic> repeatJob) async {
    final response = await dio.post(
      '${baseUrl}repeat-jobs',
      data: repeatJob,
    );
    return response;
  }

  //Delete repeat job
  Future<Response> deleteRepeatJob(String id) async {
    final response = await dio.delete(
      '${baseUrl}repeat-jobs/$id',
    );
    return response;
  }

  //Get repeat jobs
  Future<Response> getRepeatJobs(String userId) async {
    final response = await dio.get(
      '${baseUrl}repeat-jobs/by-user/$userId',
    );
    return response;
  }

  //create payment sheet
  Future<Response> createPaymentSheet(Map<String, dynamic> paymentSheet) async {
    final response = await dio.post(
      '${baseUrl}stripe/payment-sheet',
      data: paymentSheet,
    );
    return response;
  }

  //instructions

  Future<List<InstructionModel>> getInstructions() async {
    final response = await dio.get('${baseUrl}instructions');
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => InstructionModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load instructions');
    }
  }

  Future<InstructionModel> getInstruction(String id) async {
    final response = await dio.get('${baseUrl}instructions/$id');
    if (response.statusCode == 200) {
      return InstructionModel.fromJson(response.data);
    } else {
      throw Exception('Failed to load instruction');
    }
  }

  //get instructions by user type
  Future<List<InstructionModel>> getInstructionsByUserType(
      String userType) async {
    final response =
        await dio.get('${baseUrl}instructions//user-type/$userType');
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => InstructionModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load instructions');
    }
  }

  Future<InstructionModel> createInstruction(
      InstructionModel instruction) async {
    final response = await dio.post(
      '${baseUrl}instructions',
      data: instruction.toJson(),
    );
    if (response.statusCode == 201) {
      return InstructionModel.fromJson(response.data['instruction']);
    } else {
      throw Exception('Failed to create instruction');
    }
  }

  Future<InstructionModel> updateInstruction(
      String id, InstructionModel instruction) async {
    final response =
        await dio.put('${baseUrl}instructions/$id', data: instruction.toJson());
    if (response.statusCode == 200) {
      return InstructionModel.fromJson(response.data['instruction']);
    } else {
      throw Exception('Failed to update instruction');
    }
  }

  Future<void> deleteInstruction(String id) async {
    final response = await dio.delete('${baseUrl}instructions/$id');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete instruction');
    }
  }

  // Email sign-in API
  Future<Response> signInWithEmail({
    required String email,
    required String password,
    required String latitude,
    required String longitude,
  }) async {
    final response = await dio.post(
      'https://demo.innoplixit.com/api/users/auth/email',
      data: {
        'email': email,
        'password': password,
        'latitude': latitude,
        'longitude': longitude,
      },
    );
    return response;
  }

  // Google sign-in API
  Future<Response> signInWithGoogle({
    required String idToken,
    required String latitude,
    required String longitude,
  }) async {
    final response = await dio.post(
      'https://demo.innoplixit.com/api/users/firebase-google-login',
      data: {
        'idToken': idToken,
        'latitude': latitude,
        'longitude': longitude,
      },
    );
    return response;
  }
}
