import 'package:ambition_delivery/domain/usecases/create_user.dart';
import 'package:ambition_delivery/domain/usecases/delete_driver.dart';
import 'package:ambition_delivery/domain/usecases/delete_driver_by_phone_number.dart';
import 'package:ambition_delivery/domain/usecases/delete_phone_number_user_type_usecase.dart';
import 'package:ambition_delivery/domain/usecases/delete_user.dart';
import 'package:ambition_delivery/domain/usecases/delete_user_by_phone_number.dart';
import 'package:ambition_delivery/domain/usecases/fetch_current_location.dart';
import 'package:ambition_delivery/domain/usecases/get_local_user.dart';
import 'package:ambition_delivery/domain/usecases/get_otp_phone_number_user_type_usecase.dart';
import 'package:ambition_delivery/domain/usecases/get_user.dart';
import 'package:ambition_delivery/domain/usecases/resend_driver_login_otp_usecase.dart';
import 'package:ambition_delivery/domain/usecases/resend_driver_temp_otp_usecase.dart';
import 'package:ambition_delivery/domain/usecases/resend_user_login_otp_usecase.dart';
import 'package:ambition_delivery/domain/usecases/send_driver_login_otp_usecase.dart';
import 'package:ambition_delivery/domain/usecases/send_driver_temp_otp_usecase.dart';
import 'package:ambition_delivery/domain/usecases/send_user_login_otp_usecase.dart';
import 'package:ambition_delivery/domain/usecases/resend_driver_otp_usecase.dart';
import 'package:ambition_delivery/domain/usecases/resend_otp_by_email_usecase.dart';
import 'package:ambition_delivery/domain/usecases/resend_otp_to_driver_by_email_usecase.dart';
import 'package:ambition_delivery/domain/usecases/resend_otp_usecase.dart';
import 'package:ambition_delivery/domain/usecases/resend_user_temp_otp_usecase.dart';
import 'package:ambition_delivery/domain/usecases/save_driver_locally.dart';
import 'package:ambition_delivery/domain/usecases/save_otp_phone_number_user_type_usecase.dart';
import 'package:ambition_delivery/domain/usecases/save_token.dart';
import 'package:ambition_delivery/domain/usecases/save_user_locally.dart';
import 'package:ambition_delivery/domain/usecases/send_otp_by_email_usecase.dart';
import 'package:ambition_delivery/domain/usecases/send_otp_to_driver_by_email_usecase.dart';
import 'package:ambition_delivery/domain/usecases/send_user_temp_otp_usecase.dart';
import 'package:ambition_delivery/domain/usecases/update_driver_password_usecase.dart';
import 'package:ambition_delivery/domain/usecases/update_password_usecase.dart';
import 'package:ambition_delivery/domain/usecases/update_user.dart';
import 'package:ambition_delivery/domain/usecases/verify_driver_login_otp_usecase.dart';
import 'package:ambition_delivery/domain/usecases/verify_driver_otp_usecase.dart';
import 'package:ambition_delivery/domain/usecases/verify_driver_temp_otp_usecase.dart';
import 'package:ambition_delivery/domain/usecases/verify_otp_by_email_usecase.dart';
import 'package:ambition_delivery/domain/usecases/verify_otp_for_driver_by_email_usecase.dart';
import 'package:ambition_delivery/domain/usecases/verify_otp_usecase.dart';
import 'package:ambition_delivery/domain/usecases/verify_user_login_otp_usecase.dart';
import 'package:ambition_delivery/domain/usecases/verify_user_temp_otp_usecase.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../domain/entities/vehicle.dart';
import '../../domain/usecases/create_driver.dart';
import '../../domain/usecases/get_all_vehicles.dart';
import '../../domain/usecases/logout_locally.dart';
import '../../domain/usecases/sign_in_with_email.dart';
import '../../domain/usecases/sign_in_with_google.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CreateUser createUser;
  final UpdateUser updateUser;
  final DeleteUser deleteUser;
  final DeleteUserByPhoneNumber deleteUserByPhoneNumber;
  final DeleteDriver deleteDriver;
  final DeleteDriverByPhoneNumber deleteDriverByPhoneNumber;
  final CreateDriver createDriver;
  final SendDriverLoginOtpUsecase sendDriverLoginOtpUsecase;
  final ResendDriverLoginOtpUsecase resendDriverLoginOtpUsecase;
  final VerifyDriverLoginOtpUsecase verifyDriverLoginOtpUsecase;
  final SendDriverTempOtpUsecase sendDriverTempOtpUsecase;
  final ResendDriverTempOtpUsecase resendDriverTempOtpUsecase;
  final VerifyDriverTempOtpUsecase verifyDriverTempOtpUsecase;
  final GetUser getUser;
  final SendUserLoginOtpUsecase sendUserLoginOtpUsecase;
  final ResendUserLoginOtpUsecase resendUserLoginOtpUsecase;
  final VerifyUserLoginOtpUsecase verifyUserLoginOtpUsecase;
  final GetAllVehicles getAllVehicles;
  final SaveDriverLocally saveDriverLocally;
  final SaveUserLocally saveUserLocally;
  final SaveToken saveToken;
  final LogoutLocally logoutLocally;
  final FetchCurrentLocation fetchCurrentLocation;
  final GetLocalUser getLocalUser;
  final VerifyOtpUsecase verifyOtpUsecase;
  final VerifyDriverOtpUsecase verifyDriverOtpUsecase;
  final ResendOtpUsecase resendOtpUsecase;
  final ResendDriverOtpUsecase resendDriverOtpUsecase;
  final SaveOtpPhoneNumberUserTypeUsecase saveOtpPhoneNumberUserTypeUsecase;
  final GetOtpPhoneNumberUserTypeUsecase getOtpPhoneNumberUserTypeUsecase;
  final DeletePhoneNumberUserTypeUsecase deletePhoneNumberUserTypeUsecase;

  final ResendOtpByEmailUsecase resendOtpByEmailUsecase;
  final ResendOtpToDriverByEmailUsecase resendOtpToDriverByEmailUsecase;
  final SendOtpByEmailUsecase sendOtpByEmailUsecase;
  final SendOtpToDriverByEmailUsecase sendOtpToDriverByEmailUsecase;
  final UpdateDriverPasswordUsecase updateDriverPasswordUsecase;
  final UpdatePasswordUsecase updatePasswordUsecase;
  final VerifyOtpForDriverByEmailUsecase verifyOtpForDriverByEmailUsecase;
  final VerifyOtpByEmailUsecase verifyOtpByEmailUsecase;

  final SendUserTempOtpUsecase sendUserTempOtpUsecase;
  final VerifyUserTempOtpUsecase verifyUserTempOtpUsecase;
  final ResendUserTempOtpUsecase resendUserTempOtpUsecase;
  final SignInWithEmail signInWithEmail;
  final SignInWithGoogle signInWithGoogle;

  AuthBloc({
    required this.createUser,
    required this.updateUser,
    required this.deleteUser,
    required this.deleteUserByPhoneNumber,
    required this.deleteDriver,
    required this.deleteDriverByPhoneNumber,
    required this.createDriver,
    required this.sendDriverLoginOtpUsecase,
    required this.resendDriverLoginOtpUsecase,
    required this.verifyDriverLoginOtpUsecase,
    required this.sendDriverTempOtpUsecase,
    required this.resendDriverTempOtpUsecase,
    required this.verifyDriverTempOtpUsecase,
    required this.getUser,
    required this.sendUserLoginOtpUsecase,
    required this.resendUserLoginOtpUsecase,
    required this.verifyUserLoginOtpUsecase,
    required this.getAllVehicles,
    required this.saveDriverLocally,
    required this.saveUserLocally,
    required this.saveToken,
    required this.logoutLocally,
    required this.fetchCurrentLocation,
    required this.getLocalUser,
    required this.verifyOtpUsecase,
    required this.verifyDriverOtpUsecase,
    required this.resendOtpUsecase,
    required this.resendDriverOtpUsecase,
    required this.saveOtpPhoneNumberUserTypeUsecase,
    required this.getOtpPhoneNumberUserTypeUsecase,
    required this.deletePhoneNumberUserTypeUsecase,
    required this.resendOtpByEmailUsecase,
    required this.resendOtpToDriverByEmailUsecase,
    required this.sendOtpByEmailUsecase,
    required this.sendOtpToDriverByEmailUsecase,
    required this.updateDriverPasswordUsecase,
    required this.updatePasswordUsecase,
    required this.verifyOtpForDriverByEmailUsecase,
    required this.verifyOtpByEmailUsecase,
    required this.sendUserTempOtpUsecase,
    required this.verifyUserTempOtpUsecase,
    required this.resendUserTempOtpUsecase,
    required this.signInWithEmail,
    required this.signInWithGoogle,
  }) : super(AuthInitial()) {
    on<SignUpEvent>(_onSignUp);
    on<SendUserLoginOtpEvent>(_onSendUserLoginOtp);
    on<ResendUserLoginOtpEvent>(_onResendUserLoginOtp);
    on<VerifyUserLoginOtpEvent>(_onVerifyUserLoginOtp);
    on<SignOutEvent>(_onSignOut);
    on<InvalidFormEvent>(_onInvalidForm);
    on<FetchVehiclesEvent>(_onFetchVehicles);
    on<DriverSignUpEvent>(_onDriverSignUp);
    on<SendDriverLoginOtpEvent>(_onSendDriverLoginOtp);
    on<ResendDriverLoginOtpEvent>(_onResendDriverLoginOtp);
    on<VerifyDriverLoginOtpEvent>(_onVerifyDriverLoginOtp);
    on<SendDriverTempOtpEvent>(_onSendDriverTempOtp);
    on<ResendDriverTempOtpEvent>(_onResendDriverTempOtp);
    on<VerifyDriverTempOtpEvent>(_onVerifyDriverTempOtp);
    on<FetchCurrentLocationEvent>(_onFetchCurrentLocation);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<VerifyDriverOtpEvent>(_onVerifyDriverOtp);
    on<ResendOtpEvent>(_onResendOtp);
    on<ResendDriverOtpEvent>(_onResendDriverOtp);
    on<DeleteAuthEvent>(_onAuthDeleted);
    on<SendPasswordResetOtpByEmailEvent>(_onSendPasswordResetOtpByEmail);
    on<ResendPasswordResetOtpByEmailEvent>(_onResendPasswordResetOtpByEmail);
    on<VerifyPasswordResetOtpEvent>(_onVerifyPasswordResetOtp);
    on<UpdatePasswordEvent>(_onUpdatePassword);
    on<SendDriverPasswordResetOtpByEmailEvent>(
        _onSendDriverPasswordResetOtpByEmail);
    on<ResendDriverPasswordResetOtpByEmailEvent>(
        _onResendDriverPasswordResetOtpByEmail);
    on<VerifyDriverPasswordResetOtpEvent>(_onVerifyDriverPasswordResetOtp);
    on<UpdateDriverPasswordEvent>(_onUpdateDriverPassword);
    on<SendUserTempOtpEvent>(_onSendUserTempOtp);
    on<VerifyUserTempOtpEvent>(_onVerifyUserTempOtp);
    on<ResendUserTempOtpEvent>(_onResendUserTempOtp);
    on<SignInWithEmailEvent>(_onSignInWithEmail);
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
  }

  //getter for current user id
  String? get currentUserId => getLocalUser()?['id'];

  Future<void> _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final usr = await createUser(event.user);
      await saveUserLocally(usr['user']);
      emit(AuthSuccess());
    } on DioException catch (e) {
      if (e.response != null) {
        emit(AuthFailure(error: e.response!.data.toString()));
      } else {
        emit(AuthFailure(error: e.message ?? 'An error occurred'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onDriverSignUp(
      DriverSignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final driver = await createDriver(event.driver);
      await saveDriverLocally(driver['driver']);
      emit(AuthSuccess());
    } on DioException catch (e) {
      if (e.response != null) {
        emit(AuthFailure(error: e.response!.data.toString()));
      } else {
        emit(AuthFailure(error: e.message ?? 'An error occurred'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onFetchCurrentLocation(
      FetchCurrentLocationEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final position = await fetchCurrentLocation();
      emit(AuthLocationLoaded(position: position));
    } on DioException catch (e) {
      if (e.response != null) {
        emit(AuthFailure(error: e.response!.data.toString()));
      } else {
        emit(AuthFailure(error: e.message ?? 'An error occurred'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onSendUserLoginOtp(
      SendUserLoginOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await sendUserLoginOtpUsecase(event.otp);
      emit(UserLoginOtpSent());
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.data['type'] == "USER_NOT_FOUND") {
          emit(AuthUserNotFoundError());
        } else if (e.response!.data['type'] == "USER_DISABLED") {
          emit(AuthUserDisabledError());
        } else if (e.response!.data['type'] == "DRIVER_NOT_FOUND") {
          emit(AuthDriverNotFoundError());
        } else if (e.response!.data['type'] == "DRIVER_DISABLED") {
          emit(AuthDriverDisabledError());
        } else {
          emit(AuthFailure(error: e.response!.data.toString()));
        }
      } else {
        emit(AuthFailure(error: e.message ?? 'An error occurred'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onResendUserLoginOtp(
      ResendUserLoginOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await resendUserLoginOtpUsecase(event.otp);
      emit(UserLoginOtpResent());
    } on DioException catch (e) {
      if (e.response != null) {
        emit(AuthFailure(error: e.response!.data.toString()));
      } else {
        emit(AuthFailure(error: e.message ?? 'An error occurred'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onVerifyUserLoginOtp(
      VerifyUserLoginOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final usr = await verifyUserLoginOtpUsecase(event.otp);
      await saveUserLocally(usr['user']);
      emit(AuthSuccess());
    } on DioException catch (e) {
      if (e.response != null) {
        emit(OtpFailed(error: e.response!.data.toString()));
      } else {
        emit(OtpFailed(error: e.message ?? 'An error occurred'));
      }
    } catch (e) {
      emit(OtpFailed(error: e.toString()));
    }
  }

  // Future<void> _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
  //   emit(AuthLoading());
  //   try {
  //     final usr = await loginUser(event.credentials);
  //     await saveUserLocally(usr['user']);
  //     await saveToken(usr['token']);
  //     emit(AuthSuccess());
  //   } on DioException catch (e) {
  //     if (e.response != null) {
  //       if (e.response!.data['type'] == "USER_NOT_FOUND") {
  //         emit(AuthUserNotFoundError());
  //       } else if (e.response!.data['type'] == "USER_DISABLED") {
  //         emit(AuthUserDisabledError());
  //       } else if (e.response!.data['type'] == "DRIVER_NOT_FOUND") {
  //         emit(AuthDriverNotFoundError());
  //       } else if (e.response!.data['type'] == "DRIVER_DISABLED") {
  //         emit(AuthDriverDisabledError());
  //       } else {
  //         emit(AuthFailure(error: e.response!.data.toString()));
  //       }
  //     } else {
  //       emit(AuthFailure(error: e.message ?? 'An error occurred'));
  //     }
  //   } catch (e) {
  //     emit(AuthFailure(error: e.toString()));
  //   }
  // }

  // Future<void> _onDriverSignIn(
  //     DriverSignInEvent event, Emitter<AuthState> emit) async {
  //   emit(AuthLoading());
  //   try {
  //     final driver = await loginDriver(event.credentials);
  //     await saveDriverLocally(driver['driver']);
  //     await saveToken(driver['token']);
  //     emit(AuthSuccess());
  //   } on DioException catch (e) {
  //     if (e.response != null) {
  //       emit(AuthFailure(error: e.response!.data.toString()));
  //     } else {
  //       emit(AuthFailure(error: e.message ?? 'An error occurred'));
  //     }
  //   } catch (e) {
  //     emit(AuthFailure(error: e.toString()));
  //   }
  // }

  Future<void> _onSendDriverLoginOtp(
      SendDriverLoginOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await sendDriverLoginOtpUsecase(event.otp);
      emit(DriverLoginOtpSent());
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.data['type'] == "USER_NOT_FOUND") {
          emit(AuthUserNotFoundError());
        } else if (e.response!.data['type'] == "USER_DISABLED") {
          emit(AuthUserDisabledError());
        } else if (e.response!.data['type'] == "DRIVER_NOT_FOUND") {
          emit(AuthDriverNotFoundError());
        } else if (e.response!.data['type'] == "DRIVER_DISABLED") {
          emit(AuthDriverDisabledError());
        } else {
          emit(AuthFailure(error: e.response!.data.toString()));
        }
      } else {
        emit(AuthFailure(error: e.message ?? 'An error occurred'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onResendDriverLoginOtp(
      ResendDriverLoginOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await resendDriverLoginOtpUsecase(event.otp);
      emit(DriverLoginOtpResent());
    } on DioException catch (e) {
      if (e.response != null) {
        emit(AuthFailure(error: e.response!.data.toString()));
      } else {
        emit(AuthFailure(error: e.message ?? 'An error occurred'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onVerifyDriverLoginOtp(
      VerifyDriverLoginOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final driver = await verifyDriverLoginOtpUsecase(event.otp);
      await saveDriverLocally(driver['driver']);
      emit(AuthSuccess());
    } on DioException catch (e) {
      if (e.response != null) {
        emit(OtpFailed(error: e.response!.data.toString()));
      } else {
        emit(OtpFailed(error: e.message ?? 'An error occurred'));
      }
    } catch (e) {
      emit(OtpFailed(error: e.toString()));
    }
  }

  Future<void> _onSendDriverTempOtp(
      SendDriverTempOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await sendDriverTempOtpUsecase(event.otp);
      emit(DriverTempOtpSent());
    } on DioException catch (e) {
      if (e.response != null) {
        emit(AuthFailure(error: e.response!.data.toString()));
      } else {
        emit(AuthFailure(error: e.message ?? 'An error occurred'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onResendDriverTempOtp(
      ResendDriverTempOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await resendDriverTempOtpUsecase(event.otp);
      emit(DriverTempOtpResent());
    } on DioException catch (e) {
      if (e.response != null) {
        emit(AuthFailure(error: e.response!.data.toString()));
      } else {
        emit(AuthFailure(error: e.message ?? 'An error occurred'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onVerifyDriverTempOtp(
      VerifyDriverTempOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await verifyDriverTempOtpUsecase(event.otp);
      emit(DriverTempOtpVerified());
    } on DioException catch (e) {
      if (e.response != null) {
        emit(OtpFailed(error: e.response!.data.toString()));
      } else {
        emit(OtpFailed(error: e.message ?? 'An error occurred'));
      }
    } catch (e) {
      emit(OtpFailed(error: e.toString()));
    }
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await logoutLocally();
      emit(AuthSignedOut());
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  void _onInvalidForm(InvalidFormEvent event, Emitter<AuthState> emit) {
    emit(AuthFailure(error: event.message));
  }

  Future<void> _onFetchVehicles(
      FetchVehiclesEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final vehicles = await getAllVehicles();
      emit(AuthVehiclesLoaded(vehicles: vehicles));
    } on DioException catch (e) {
      if (e.response != null) {
        emit(AuthFailure(error: e.response!.data.toString()));
      } else {
        emit(AuthFailure(error: e.message ?? 'An error occurred'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onVerifyOtp(
      VerifyOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await verifyOtpUsecase(event.otp);
      await deletePhoneNumberUserTypeUsecase();
      emit(OtpVerified());
    } on DioException catch (e) {
      if (e.response != null) {
        emit(OtpFailed(error: e.response!.data.toString()));
      } else {
        emit(OtpFailed(error: e.message ?? 'An error occurred'));
      }
    } catch (e) {
      emit(OtpFailed(error: e.toString()));
    }
  }

  Future<void> _onVerifyDriverOtp(
      VerifyDriverOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await verifyDriverOtpUsecase(event.otp);
      await deletePhoneNumberUserTypeUsecase();
      emit(OtpVerified());
    } on DioException catch (e) {
      if (e.response != null) {
        emit(OtpFailed(error: e.response!.data.toString()));
      } else {
        emit(OtpFailed(error: e.message ?? 'An error occurred'));
      }
    } catch (e) {
      emit(OtpFailed(error: e.toString()));
    }
  }

  Future<void> _onResendOtp(
      ResendOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await resendOtpUsecase(event.otp);
      emit(OtpSent());
    } on DioException catch (e) {
      if (e.response != null) {
        emit(OtpFailed(error: e.response!.data.toString()));
      } else {
        emit(OtpFailed(error: e.message ?? 'An error occurred'));
      }
    } catch (e) {
      emit(OtpFailed(error: e.toString()));
    }
  }

  Future<void> _onResendDriverOtp(
      ResendDriverOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await resendDriverOtpUsecase(event.otp);
      emit(OtpSent());
    } on DioException catch (e) {
      if (e.response != null) {
        emit(OtpFailed(error: e.response!.data.toString()));
      } else {
        emit(OtpFailed(error: e.message ?? 'An error occurred'));
      }
    } catch (e) {
      emit(OtpFailed(error: e.toString()));
    }
  }

  Future<void> _onAuthDeleted(
      DeleteAuthEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      if (event.userType == 'passenger') {
        await deleteUserByPhoneNumber(event.phoneNumber);
      } else {
        await deleteDriverByPhoneNumber(event.phoneNumber);
      }
      await deletePhoneNumberUserTypeUsecase();
      emit(AuthDeleted());
    } on DioException catch (e) {
      if (e.response != null) {
        emit(AuthFailure(error: e.response!.data.toString()));
      } else {
        emit(AuthFailure(error: e.message ?? 'An error occurred'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onSendPasswordResetOtpByEmail(
      SendPasswordResetOtpByEmailEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await sendOtpByEmailUsecase({'email': event.email});
      emit(PasswordResetOtpSent());
    } on DioException catch (e) {
      if (e.response != null) {
        emit(AuthFailure(error: e.response!.data.toString()));
      } else {
        emit(AuthFailure(error: e.message ?? 'An error occurred'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onResendPasswordResetOtpByEmail(
      ResendPasswordResetOtpByEmailEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await resendOtpByEmailUsecase({'email': event.email});
      emit(PasswordResetOtpResent());
    } on DioException catch (e) {
      if (e.response != null) {
        emit(AuthFailure(error: e.response!.data.toString()));
      } else {
        emit(AuthFailure(error: e.message ?? 'An error occurred'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onVerifyPasswordResetOtp(
      VerifyPasswordResetOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await verifyOtpByEmailUsecase(event.otp);
      emit(PasswordResetOtpVerified());
    } on DioException catch (e) {
      if (e.response != null) {
        emit(OtpFailed(error: e.response!.data.toString()));
      } else {
        emit(OtpFailed(error: e.message ?? 'An error occurred'));
      }
    } catch (e) {
      emit(OtpFailed(error: e.toString()));
    }
  }

  Future<void> _onUpdatePassword(
      UpdatePasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await updatePasswordUsecase(event.password);
      emit(PasswordUpdated());
    } on DioException catch (e) {
      if (e.response != null) {
        emit(AuthFailure(error: e.response!.data.toString()));
      } else {
        emit(AuthFailure(error: e.message ?? 'An error occurred'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onSendDriverPasswordResetOtpByEmail(
      SendDriverPasswordResetOtpByEmailEvent event,
      Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await sendOtpToDriverByEmailUsecase({'email': event.email});
      emit(DriverPasswordResetOtpSent());
    } on DioException catch (e) {
      if (e.response != null) {
        emit(AuthFailure(error: e.response!.data.toString()));
      } else {
        emit(AuthFailure(error: e.message ?? 'An error occurred'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onResendDriverPasswordResetOtpByEmail(
      ResendDriverPasswordResetOtpByEmailEvent event,
      Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await resendOtpToDriverByEmailUsecase({'email': event.email});
      emit(DriverPasswordResetOtpResent());
    } on DioException catch (e) {
      if (e.response != null) {
        emit(AuthFailure(error: e.response!.data.toString()));
      } else {
        emit(AuthFailure(error: e.message ?? 'An error occurred'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onVerifyDriverPasswordResetOtp(
      VerifyDriverPasswordResetOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await verifyOtpForDriverByEmailUsecase(event.otp);
      emit(DriverPasswordResetOtpVerified());
    } on DioException catch (e) {
      if (e.response != null) {
        emit(OtpFailed(error: e.response!.data.toString()));
      } else {
        emit(OtpFailed(error: e.message ?? 'An error occurred'));
      }
    } catch (e) {
      emit(OtpFailed(error: e.toString()));
    }
  }

  Future<void> _onUpdateDriverPassword(
      UpdateDriverPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await updateDriverPasswordUsecase(event.password);
      emit(DriverPasswordUpdated());
    } on DioException catch (e) {
      if (e.response != null) {
        emit(AuthFailure(error: e.response!.data.toString()));
      } else {
        emit(AuthFailure(error: e.message ?? 'An error occurred'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onSendUserTempOtp(
      SendUserTempOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await sendUserTempOtpUsecase(event.otp);
      emit(UserTempOtpSent());
    } on DioException catch (e) {
      if (e.response != null) {
        emit(AuthFailure(error: e.response!.data.toString()));
      } else {
        emit(AuthFailure(error: e.message ?? 'An error occurred'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onVerifyUserTempOtp(
      VerifyUserTempOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await verifyUserTempOtpUsecase(event.otp);
      emit(UserTempOtpVerified());
    } on DioException catch (e) {
      if (e.response != null) {
        emit(OtpFailed(error: e.response!.data.toString()));
      } else {
        emit(OtpFailed(error: e.message ?? 'An error occurred'));
      }
    } catch (e) {
      emit(OtpFailed(error: e.toString()));
    }
  }

  Future<void> _onResendUserTempOtp(
      ResendUserTempOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await resendUserTempOtpUsecase(event.otp);
      emit(UserTempOtpResent());
    } on DioException catch (e) {
      if (e.response != null) {
        emit(AuthFailure(error: e.response!.data.toString()));
      } else {
        emit(AuthFailure(error: e.message ?? 'An error occurred'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onSignInWithEmail(
      SignInWithEmailEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final result = await signInWithEmail(
        email: event.email,
        password: event.password,
        latitude: event.latitude,
        longitude: event.longitude,
      );
      await saveToken(result['token']);
      await saveUserLocally(result['user']); // Match OTP login flow
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onSignInWithGoogle(
      SignInWithGoogleEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final result = await signInWithGoogle(
        idToken: event.idToken,
        latitude: event.latitude,
        longitude: event.longitude,
      );
      final user = result['user'];
      // Removed phone check to allow Google login without phone
      await saveToken(result['token']);
      await saveUserLocally(user);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }
}
