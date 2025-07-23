import 'package:ambition_delivery/data/repositories/instruction_repository_impl.dart';
import 'package:ambition_delivery/data/repositories/payment_repository_impl.dart';
import 'package:ambition_delivery/data/repositories/repeat_job_repository_impl.dart';
import 'package:ambition_delivery/domain/usecases/create_payment_sheet.dart';
import 'package:ambition_delivery/domain/usecases/create_repeat_job.dart';
import 'package:ambition_delivery/domain/usecases/delete_driver.dart';
import 'package:ambition_delivery/domain/usecases/delete_driver_by_phone_number.dart';
import 'package:ambition_delivery/domain/usecases/delete_phone_number_user_type_usecase.dart';
import 'package:ambition_delivery/domain/usecases/delete_repeat_job.dart';
import 'package:ambition_delivery/domain/usecases/delete_user_by_phone_number.dart';
import 'package:ambition_delivery/domain/usecases/get_driver.dart';
import 'package:ambition_delivery/domain/usecases/get_instructions_by_user_type.dart';
import 'package:ambition_delivery/domain/usecases/get_otp_phone_number_user_type_usecase.dart';
import 'package:ambition_delivery/domain/usecases/get_repeat_jobs.dart';
import 'package:ambition_delivery/domain/usecases/get_vehicle_categories_by_passengers.dart';
import 'package:ambition_delivery/domain/usecases/is_driver.dart';
import 'package:ambition_delivery/domain/usecases/is_passenger.dart';
import 'package:ambition_delivery/domain/usecases/present_payment_sheet.dart';
import 'package:ambition_delivery/domain/usecases/resend_driver_login_otp_usecase.dart';
import 'package:ambition_delivery/domain/usecases/resend_driver_otp_usecase.dart';
import 'package:ambition_delivery/domain/usecases/resend_driver_temp_otp_usecase.dart';
import 'package:ambition_delivery/domain/usecases/resend_otp_by_email_usecase.dart';
import 'package:ambition_delivery/domain/usecases/resend_otp_to_driver_by_email_usecase.dart';
import 'package:ambition_delivery/domain/usecases/resend_otp_usecase.dart';
import 'package:ambition_delivery/domain/usecases/resend_user_login_otp_usecase.dart';
import 'package:ambition_delivery/domain/usecases/resend_user_temp_otp_usecase.dart';
import 'package:ambition_delivery/domain/usecases/save_otp_phone_number_user_type_usecase.dart';
import 'package:ambition_delivery/domain/usecases/send_driver_login_otp_usecase.dart';
import 'package:ambition_delivery/domain/usecases/send_driver_temp_otp_usecase.dart';
import 'package:ambition_delivery/domain/usecases/send_otp_by_email_usecase.dart';
import 'package:ambition_delivery/domain/usecases/send_otp_to_driver_by_email_usecase.dart';
import 'package:ambition_delivery/domain/usecases/send_user_temp_otp_usecase.dart';
import 'package:ambition_delivery/domain/usecases/update_driver.dart';
import 'package:ambition_delivery/domain/usecases/update_driver_password_usecase.dart';
import 'package:ambition_delivery/domain/usecases/update_password_usecase.dart';
import 'package:ambition_delivery/domain/usecases/verify_driver_login_otp_usecase.dart';
import 'package:ambition_delivery/domain/usecases/verify_driver_otp_usecase.dart';
import 'package:ambition_delivery/domain/usecases/verify_driver_temp_otp_usecase.dart';
import 'package:ambition_delivery/domain/usecases/verify_otp_by_email_usecase.dart';
import 'package:ambition_delivery/domain/usecases/verify_otp_for_driver_by_email_usecase.dart';
import 'package:ambition_delivery/domain/usecases/verify_otp_usecase.dart';
import 'package:ambition_delivery/domain/usecases/verify_user_login_otp_usecase.dart';
import 'package:ambition_delivery/domain/usecases/verify_user_temp_otp_usecase.dart';
import 'package:dio/dio.dart';
import 'package:ambition_delivery/utils/consts.dart';
import 'package:ambition_delivery/configs/error_interceptor.dart';
import 'package:ambition_delivery/data/datasources/remote_data_source.dart';
import 'package:ambition_delivery/data/datasources/local_data_source.dart';
import 'package:ambition_delivery/data/repositories/user_repository_impl.dart';
import 'package:ambition_delivery/data/repositories/driver_repository_impl.dart';
import 'package:ambition_delivery/data/repositories/vehicle_respository_impl.dart';
import 'package:ambition_delivery/data/repositories/vehicle_category_repository_impl.dart';
import 'package:ambition_delivery/data/repositories/item_repository_impl.dart';
import 'package:ambition_delivery/data/repositories/ride_request_repository_impl.dart';
import 'package:ambition_delivery/data/repositories/chat_repository_impl.dart';
import 'package:ambition_delivery/data/repositories/local_data_repository_impl.dart';
import 'package:ambition_delivery/domain/usecases/create_user.dart';
import 'package:ambition_delivery/domain/usecases/update_user.dart';
import 'package:ambition_delivery/domain/usecases/delete_user.dart';
import 'package:ambition_delivery/domain/usecases/get_user.dart';
import 'package:ambition_delivery/domain/usecases/send_user_login_otp_usecase.dart';
import 'package:ambition_delivery/domain/usecases/get_all_vehicles.dart';
import 'package:ambition_delivery/domain/usecases/create_driver.dart';
import 'package:ambition_delivery/domain/usecases/save_driver_locally.dart';
import 'package:ambition_delivery/domain/usecases/save_user_locally.dart';
import 'package:ambition_delivery/domain/usecases/save_token.dart';
import 'package:ambition_delivery/domain/usecases/logout_locally.dart';
import 'package:ambition_delivery/domain/usecases/fetch_current_location.dart';
import 'package:ambition_delivery/domain/usecases/get_local_user.dart';
import 'package:ambition_delivery/domain/usecases/get_all_items.dart';
import 'package:ambition_delivery/domain/usecases/get_vehicle_categories_by_items.dart';
import 'package:ambition_delivery/domain/usecases/create_ride_request.dart';
import 'package:ambition_delivery/domain/usecases/update_ride_request.dart';
import 'package:ambition_delivery/domain/usecases/cancel_ride_request.dart';
import 'package:ambition_delivery/domain/usecases/complete_ride_request.dart';
import 'package:ambition_delivery/domain/usecases/get_pending_ride_requests_by_driver_car_category.dart';
import 'package:ambition_delivery/domain/usecases/get_ongoing_ride_request_by_user_id.dart';
import 'package:ambition_delivery/domain/usecases/delete_ride_request.dart';
import 'package:ambition_delivery/domain/usecases/get_ongoing_ride_request_by_driver_id.dart';
import 'package:ambition_delivery/domain/usecases/get_closed_ride_requests_by_driver_id.dart';
import 'package:ambition_delivery/domain/usecases/get_closed_ride_requests_by_user_id.dart';
import 'package:ambition_delivery/domain/usecases/get_polyline_points.dart';
import 'package:ambition_delivery/domain/usecases/get_driver_location.dart';
import 'package:ambition_delivery/domain/usecases/update_driver_location.dart';
import 'package:ambition_delivery/domain/usecases/get_user_location.dart';
import 'package:ambition_delivery/domain/usecases/update_user_location.dart';
import 'package:ambition_delivery/domain/usecases/get_chat_messages_by_id.dart';
import 'package:ambition_delivery/domain/usecases/get_conversation_by_id.dart';
import 'package:ambition_delivery/domain/usecases/send_message.dart';
import 'package:ambition_delivery/domain/usecases/sign_in_with_email.dart';
import 'package:ambition_delivery/domain/usecases/sign_in_with_google.dart';

import '../main.dart';

Future<void> setupDependencies() async {
  final options = BaseOptions(
    baseUrl: Consts.baseUrl,
    contentType: Headers.jsonContentType,
    validateStatus: (status) {
      return status != null;
    },
  );

  final dio = Dio(options);
  dio.interceptors.addAll([
    LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      responseHeader: true,
    ),
    ErrorInterceptor(),
  ]);

  // Setup data sources
  final dataSource = RemoteDataSource(dio: dio, baseUrl: Consts.baseUrl);
  final localDataSource = LocalDataSource(sharedPreferences!);

  // Setup repositories
  final userRepository = UserRepositoryImpl(userRemoteDataSource: dataSource);
  final driverRepository = DriverRepositoryImpl(remoteDataSource: dataSource);
  final vehicleRepository =
      VehicleRespositoryImpl(vehicleRemoteDataSource: dataSource);
  final vehicleCategoryRepository =
      VehicleCategoryRepositoryImpl(remoteDataSource: dataSource);
  final localDataRepository =
      LocalDataRepositoryImpl(localDataSource: localDataSource);
  final itemsRepository = ItemRepositoryImpl(dataSource);
  final rideRequestRepository =
      RideRequestRepositoryImpl(remoteDataSource: dataSource);
  final chatRepository = ChatRepositoryImpl(remoteDataSource: dataSource);
  final repeatJobRepository =
      RepeatJobRepositoryImpl(remoteDataSource: dataSource);
  final paymentRepository = PaymentRepositoryImpl(dataSource: dataSource);
  final instructionRepository =
      InstructionRepositoryImpl(remoteDataSource: dataSource);

  // Setup use cases
  createUser = CreateUser(userRepository);
  updateUser = UpdateUser(userRepository);
  deleteUser = DeleteUser(userRepository);
  deleteUserByPhoneNumber = DeleteUserByPhoneNumber(userRepository);
  getUser = GetUser(userRepository);
  sendUserLoginOtpUsecase = SendUserLoginOtpUsecase(userRepository);
  resendUserLoginOtpUsecase = ResendUserLoginOtpUsecase(userRepository);
  verifyUserLoginOtpUsecase = VerifyUserLoginOtpUsecase(userRepository);
  signInWithEmail = SignInWithEmail(userRepository);
  signInWithGoogle = SignInWithGoogle(userRepository);
  getAllVehicles = GetAllVehicles(vehicleRepository);
  createDriver = CreateDriver(driverRepository);
  getDriver = GetDriver(driverRepository);
  updateDriver = UpdateDriver(driverRepository);
  deleteDriver = DeleteDriver(driverRepository);
  deleteDriverByPhoneNumber = DeleteDriverByPhoneNumber(driverRepository);
  isDriver = IsDriver(localDataRepository);
  isPassenger = IsPassenger(localDataRepository);
  sendDriverLoginOtpUsecase = SendDriverLoginOtpUsecase(driverRepository);
  resendDriverLoginOtpUsecase = ResendDriverLoginOtpUsecase(driverRepository);
  verifyDriverLoginOtpUsecase = VerifyDriverLoginOtpUsecase(driverRepository);
  sendDriverTempOtpUsecase = SendDriverTempOtpUsecase(driverRepository);
  resendDriverTempOtpUsecase = ResendDriverTempOtpUsecase(driverRepository);
  verifyDriverTempOtpUsecase = VerifyDriverTempOtpUsecase(driverRepository);
  saveDriverLocally = SaveDriverLocally(localDataRepository);
  saveUserLocally = SaveUserLocally(localDataRepository);
  saveToken = SaveToken(localDataRepository);
  logoutLocally = LogoutLocally(localDataRepository);
  saveOtpPhoneNumberUserTypeUsecase =
      SaveOtpPhoneNumberUserTypeUsecase(localDataRepository);
  getOtpPhoneNumberUserTypeUsecase =
      GetOtpPhoneNumberUserTypeUsecase(localDataRepository);
  deletePhoneNumberUserTypeUsecase =
      DeletePhoneNumberUserTypeUsecase(localDataRepository);
  fetchCurrentLocation = FetchCurrentLocation();
  getCurrentUser = GetLocalUser(localDataRepository);
  getAllItems = GetAllItems(itemsRepository);
  getVehicleCategoriesByItems =
      GetVehicleCategoriesByItems(vehicleCategoryRepository);
  getVehicleCategoriesByPassengers =
      GetVehicleCategoriesByPassengers(vehicleCategoryRepository);
  createRideRequest = CreateRideRequest(rideRequestRepository);
  updateRideRequest = UpdateRideRequest(rideRequestRepository);
  cancelRideRequest = CancelRideRequest(rideRequestRepository);
  completeRideRequest = CompleteRideRequest(rideRequestRepository);
  getPendingRideRequestsByDriverCarCategory =
      GetPendingRideRequestsByDriverCarCategory(rideRequestRepository);
  getOngoingRideRequestByUserId =
      GetOngoingRideRequestByUserId(rideRequestRepository);
  deleteRideRequest = DeleteRideRequest(rideRequestRepository);
  getOngoingRideRequestByDriverId =
      GetOngoingRideRequestByDriverId(rideRequestRepository);
  getClosedRideRequestsByDriverId =
      GetClosedRideRequestsByDriverId(rideRequestRepository);
  getClosedRideRequestsByUserId =
      GetClosedRideRequestsByUserId(rideRequestRepository);
  getPolylinePoints = GetPolylinePoints(rideRequestRepository);
  getDriverLocation = GetDriverLocation(driverRepository);
  updateDriverLocation = UpdateDriverLocation(driverRepository);
  getUserLocation = GetUserLocation(userRepository);
  updateUserLocation = UpdateUserLocation(userRepository);
  getChatMessagesById = GetChatMessagesById(chatRepository);
  getConversationById = GetConversationById(chatRepository);
  sendMessage = SendMessage(chatRepository);
  createRepeatJob = CreateRepeatJob(repeatJobRepository);
  deleteRepeatJob = DeleteRepeatJob(repeatJobRepository);
  getRepeatJobs = GetRepeatJobs(repeatJobRepository);
  createPaymentSheet = CreatePaymentSheet(paymentRepository);
  presentPaymentSheet = PresentPaymentSheet(paymentRepository);
  getInstructionsByUserType = GetInstructionsByUserType(instructionRepository);

  verifyOtpUsecase = VerifyOtpUsecase(userRepository);
  verifyDriverOtpUsecase = VerifyDriverOtpUsecase(driverRepository);
  resendOtpUsecase = ResendOtpUsecase(userRepository);
  resendDriverOtpUsecase = ResendDriverOtpUsecase(driverRepository);

  sendOtpByEmailUsecase = SendOtpByEmailUsecase(userRepository);
  sendOtpToDriverByEmailUsecase =
      SendOtpToDriverByEmailUsecase(driverRepository);
  resendOtpByEmailUsecase = ResendOtpByEmailUsecase(userRepository);
  resendOtpToDriverByEmailUsecase =
      ResendOtpToDriverByEmailUsecase(driverRepository);
  updateDriverPasswordUsecase = UpdateDriverPasswordUsecase(driverRepository);
  updatePasswordUsecase = UpdatePasswordUsecase(userRepository);

  verifyOtpByEmailUsecase = VerifyOtpByEmailUsecase(userRepository);
  verifyOtpForDriverByEmailUsecase =
      VerifyOtpForDriverByEmailUsecase(driverRepository);
  sendUserTempOtpUsecase = SendUserTempOtpUsecase(userRepository);
  verifyUserTempOtpUsecase = VerifyUserTempOtpUsecase(userRepository);
  resendUserTempOtpUsecase = ResendUserTempOtpUsecase(userRepository);
}

// Declare use cases as global variables to be used in other parts of the app
late CreateUser createUser;
late UpdateUser updateUser;
late DeleteUser deleteUser;
late DeleteUserByPhoneNumber deleteUserByPhoneNumber;
late GetUser getUser;
late SendUserLoginOtpUsecase sendUserLoginOtpUsecase;
late ResendUserLoginOtpUsecase resendUserLoginOtpUsecase;
late VerifyUserLoginOtpUsecase verifyUserLoginOtpUsecase;
late SignInWithEmail signInWithEmail;
late SignInWithGoogle signInWithGoogle;
late GetAllVehicles getAllVehicles;
late CreateDriver createDriver;
late GetDriver getDriver;
late UpdateDriver updateDriver;
late DeleteDriver deleteDriver;
late DeleteDriverByPhoneNumber deleteDriverByPhoneNumber;
late IsDriver isDriver;
late IsPassenger isPassenger;
late SendDriverLoginOtpUsecase sendDriverLoginOtpUsecase;
late ResendDriverLoginOtpUsecase resendDriverLoginOtpUsecase;
late VerifyDriverLoginOtpUsecase verifyDriverLoginOtpUsecase;
late SendDriverTempOtpUsecase sendDriverTempOtpUsecase;
late ResendDriverTempOtpUsecase resendDriverTempOtpUsecase;
late VerifyDriverTempOtpUsecase verifyDriverTempOtpUsecase;
late SaveDriverLocally saveDriverLocally;
late SaveUserLocally saveUserLocally;
late SaveToken saveToken;
late LogoutLocally logoutLocally;
late SaveOtpPhoneNumberUserTypeUsecase saveOtpPhoneNumberUserTypeUsecase;
late GetOtpPhoneNumberUserTypeUsecase getOtpPhoneNumberUserTypeUsecase;
late DeletePhoneNumberUserTypeUsecase deletePhoneNumberUserTypeUsecase;
late FetchCurrentLocation fetchCurrentLocation;
late GetLocalUser getCurrentUser;
late GetAllItems getAllItems;
late GetVehicleCategoriesByItems getVehicleCategoriesByItems;
late GetVehicleCategoriesByPassengers getVehicleCategoriesByPassengers;
late CreateRideRequest createRideRequest;
late UpdateRideRequest updateRideRequest;
late CancelRideRequest cancelRideRequest;
late CompleteRideRequest completeRideRequest;
late GetPendingRideRequestsByDriverCarCategory
    getPendingRideRequestsByDriverCarCategory;
late GetOngoingRideRequestByUserId getOngoingRideRequestByUserId;
late DeleteRideRequest deleteRideRequest;
late GetOngoingRideRequestByDriverId getOngoingRideRequestByDriverId;
late GetClosedRideRequestsByDriverId getClosedRideRequestsByDriverId;
late GetClosedRideRequestsByUserId getClosedRideRequestsByUserId;
late GetPolylinePoints getPolylinePoints;
late GetDriverLocation getDriverLocation;
late UpdateDriverLocation updateDriverLocation;
late GetUserLocation getUserLocation;
late UpdateUserLocation updateUserLocation;
late GetChatMessagesById getChatMessagesById;
late GetConversationById getConversationById;
late SendMessage sendMessage;
late CreateRepeatJob createRepeatJob;
late DeleteRepeatJob deleteRepeatJob;
late GetRepeatJobs getRepeatJobs;
late CreatePaymentSheet createPaymentSheet;
late PresentPaymentSheet presentPaymentSheet;
late GetInstructionsByUserType getInstructionsByUserType;

late VerifyOtpUsecase verifyOtpUsecase;
late VerifyDriverOtpUsecase verifyDriverOtpUsecase;
late ResendOtpUsecase resendOtpUsecase;
late ResendDriverOtpUsecase resendDriverOtpUsecase;
late SendOtpByEmailUsecase sendOtpByEmailUsecase;
late SendOtpToDriverByEmailUsecase sendOtpToDriverByEmailUsecase;
late ResendOtpByEmailUsecase resendOtpByEmailUsecase;
late ResendOtpToDriverByEmailUsecase resendOtpToDriverByEmailUsecase;
late UpdateDriverPasswordUsecase updateDriverPasswordUsecase;
late UpdatePasswordUsecase updatePasswordUsecase;
late VerifyOtpByEmailUsecase verifyOtpByEmailUsecase;
late VerifyOtpForDriverByEmailUsecase verifyOtpForDriverByEmailUsecase;

late SendUserTempOtpUsecase sendUserTempOtpUsecase;
late VerifyUserTempOtpUsecase verifyUserTempOtpUsecase;
late ResendUserTempOtpUsecase resendUserTempOtpUsecase;
