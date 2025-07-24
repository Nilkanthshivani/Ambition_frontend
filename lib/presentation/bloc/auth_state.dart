part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthSignedOut extends AuthState {}

class AuthVehiclesLoaded extends AuthState {
  final List<Vehicle> vehicles;

  const AuthVehiclesLoaded({required this.vehicles});

  @override
  List<Object> get props => [vehicles];
}

class AuthLocationLoaded extends AuthState {
  final Position position;

  const AuthLocationLoaded({required this.position});

  @override
  List<Object> get props => [position];
}

class AuthFailure extends AuthState {
  final String error;

  const AuthFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class AuthDeleted extends AuthState {}

class OtpSent extends AuthState {}

class OtpVerified extends AuthState {}

class OtpFailed extends AuthState {
  final String error;

  const OtpFailed({required this.error});

  @override
  List<Object> get props => [error];
}

class UserLoginOtpSent extends AuthState {}

class UserLoginOtpResent extends AuthState {}

class UserLoginOtpVerified extends AuthState {}

class DriverLoginOtpSent extends AuthState {}

class DriverLoginOtpResent extends AuthState {}

class DriverLoginOtpVerified extends AuthState {}

class PasswordResetOtpSent extends AuthState {}

class PasswordResetOtpResent extends AuthState {}

class PasswordResetOtpVerified extends AuthState {}

class PasswordUpdated extends AuthState {}

class DriverPasswordResetOtpSent extends AuthState {}

class DriverPasswordResetOtpResent extends AuthState {}

class DriverPasswordResetOtpVerified extends AuthState {}

class DriverPasswordUpdated extends AuthState {}

class AuthUserNotFoundError extends AuthState {}

class AuthUserDisabledError extends AuthState {}

class AuthDriverNotFoundError extends AuthState {}

class AuthDriverDisabledError extends AuthState {}

class UserTempOtpSent extends AuthState {}

class UserTempOtpVerified extends AuthState {}

class UserTempOtpResent extends AuthState {}

class DriverTempOtpSent extends AuthState {}

class DriverTempOtpVerified extends AuthState {}

class DriverTempOtpResent extends AuthState {}

class AuthPhoneNumberRequired extends AuthState {
  final Map<String, dynamic> user;
  const AuthPhoneNumberRequired({required this.user});
}
