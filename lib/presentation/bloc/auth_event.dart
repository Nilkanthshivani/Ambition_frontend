part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignUpEvent extends AuthEvent {
  final Map<String, dynamic> user;

  const SignUpEvent({required this.user});

  @override
  List<Object> get props => [user];
}

class DriverSignUpEvent extends AuthEvent {
  final Map<String, dynamic> driver;

  const DriverSignUpEvent({required this.driver});

  @override
  List<Object> get props => [driver];
}

class SendUserLoginOtpEvent extends AuthEvent {
  final Map<String, dynamic> otp;
  const SendUserLoginOtpEvent({required this.otp});
  @override
  List<Object> get props => [otp];
}

class ResendUserLoginOtpEvent extends AuthEvent {
  final Map<String, dynamic> otp;
  const ResendUserLoginOtpEvent({required this.otp});
  @override
  List<Object> get props => [otp];
}

class VerifyUserLoginOtpEvent extends AuthEvent {
  final Map<String, dynamic> otp;
  const VerifyUserLoginOtpEvent({required this.otp});
  @override
  List<Object> get props => [otp];
}

class FetchVehiclesEvent extends AuthEvent {}

class FetchCurrentLocationEvent extends AuthEvent {}

class InvalidFormEvent extends AuthEvent {
  final String message;
  const InvalidFormEvent({required this.message});

  @override
  List<Object> get props => [message];
}

class SignOutEvent extends AuthEvent {}

class GetUserEvent extends AuthEvent {}

class UpdateUserEvent extends AuthEvent {
  final Map<String, dynamic> user;

  const UpdateUserEvent({required this.user});

  @override
  List<Object> get props => [user];
}

class DeleteUserEvent extends AuthEvent {}

class VerifyOtpEvent extends AuthEvent {
  final Map<String, dynamic> otp;

  const VerifyOtpEvent({required this.otp});

  @override
  List<Object> get props => [otp];
}

class ResendOtpEvent extends AuthEvent {
  final Map<String, dynamic> otp;

  const ResendOtpEvent({required this.otp});

  @override
  List<Object> get props => [otp];
}

class VerifyDriverOtpEvent extends AuthEvent {
  final Map<String, dynamic> otp;

  const VerifyDriverOtpEvent({required this.otp});

  @override
  List<Object> get props => [otp];
}

class ResendDriverOtpEvent extends AuthEvent {
  final Map<String, dynamic> otp;

  const ResendDriverOtpEvent({required this.otp});

  @override
  List<Object> get props => [otp];
}

class SendPasswordResetOtpByEmailEvent extends AuthEvent {
  final String email;

  const SendPasswordResetOtpByEmailEvent({required this.email});

  @override
  List<Object> get props => [email];
}

class ResendPasswordResetOtpByEmailEvent extends AuthEvent {
  final String email;

  const ResendPasswordResetOtpByEmailEvent({required this.email});

  @override
  List<Object> get props => [email];
}

class VerifyPasswordResetOtpEvent extends AuthEvent {
  final Map<String, dynamic> otp;

  const VerifyPasswordResetOtpEvent({required this.otp});

  @override
  List<Object> get props => [otp];
}

class UpdatePasswordEvent extends AuthEvent {
  final Map<String, dynamic> password;

  const UpdatePasswordEvent({required this.password});

  @override
  List<Object> get props => [password];
}

class SendDriverPasswordResetOtpByEmailEvent extends AuthEvent {
  final String email;

  const SendDriverPasswordResetOtpByEmailEvent({required this.email});

  @override
  List<Object> get props => [email];
}

class ResendDriverPasswordResetOtpByEmailEvent extends AuthEvent {
  final String email;

  const ResendDriverPasswordResetOtpByEmailEvent({required this.email});

  @override
  List<Object> get props => [email];
}

class VerifyDriverPasswordResetOtpEvent extends AuthEvent {
  final Map<String, dynamic> otp;

  const VerifyDriverPasswordResetOtpEvent({required this.otp});

  @override
  List<Object> get props => [otp];
}

class UpdateDriverPasswordEvent extends AuthEvent {
  final Map<String, dynamic> password;

  const UpdateDriverPasswordEvent({required this.password});

  @override
  List<Object> get props => [password];
}

class DeleteAuthEvent extends AuthEvent {
  final String userType;
  final String phoneNumber;

  const DeleteAuthEvent({required this.userType, required this.phoneNumber});

  @override
  List<Object> get props => [userType, phoneNumber];
}

class SendUserTempOtpEvent extends AuthEvent {
  final Map<String, dynamic> otp;

  const SendUserTempOtpEvent({required this.otp});

  @override
  List<Object> get props => [otp];
}

class ResendUserTempOtpEvent extends AuthEvent {
  final Map<String, dynamic> otp;

  const ResendUserTempOtpEvent({required this.otp});

  @override
  List<Object> get props => [otp];
}

class VerifyUserTempOtpEvent extends AuthEvent {
  final Map<String, dynamic> otp;

  const VerifyUserTempOtpEvent({required this.otp});

  @override
  List<Object> get props => [otp];
}

class SendDriverTempOtpEvent extends AuthEvent {
  final Map<String, dynamic> otp;

  const SendDriverTempOtpEvent({required this.otp});

  @override
  List<Object> get props => [otp];
}

class ResendDriverTempOtpEvent extends AuthEvent {
  final Map<String, dynamic> otp;

  const ResendDriverTempOtpEvent({required this.otp});

  @override
  List<Object> get props => [otp];
}

class VerifyDriverTempOtpEvent extends AuthEvent {
  final Map<String, dynamic> otp;

  const VerifyDriverTempOtpEvent({required this.otp});

  @override
  List<Object> get props => [otp];
}

class SendDriverLoginOtpEvent extends AuthEvent {
  final Map<String, dynamic> otp;
  const SendDriverLoginOtpEvent({required this.otp});
  @override
  List<Object> get props => [otp];
}

class ResendDriverLoginOtpEvent extends AuthEvent {
  final Map<String, dynamic> otp;
  const ResendDriverLoginOtpEvent({required this.otp});
  @override
  List<Object> get props => [otp];
}

class VerifyDriverLoginOtpEvent extends AuthEvent {
  final Map<String, dynamic> otp;
  const VerifyDriverLoginOtpEvent({required this.otp});
  @override
  List<Object> get props => [otp];
}

class SignInWithEmailEvent extends AuthEvent {
  final String email;
  final String password;
  final String latitude;
  final String longitude;

  const SignInWithEmailEvent({
    required this.email,
    required this.password,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props => [email, password, latitude, longitude];
}

class SignInWithGoogleEvent extends AuthEvent {
  final String idToken;
  final String latitude;
  final String longitude;

  const SignInWithGoogleEvent({
    required this.idToken,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props => [idToken, latitude, longitude];
}
