import 'package:ambition_delivery/presentation/bloc/instruction_bloc.dart';
import 'package:ambition_delivery/presentation/bloc/payment_bloc.dart';
import 'package:ambition_delivery/presentation/bloc/repeat_job_bloc.dart';
import 'package:ambition_delivery/presentation/widgets/dismiss_focus_overlay.dart';
import 'package:ambition_delivery/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ambition_delivery/presentation/bloc/auth_bloc.dart';
import 'package:ambition_delivery/presentation/bloc/ride_request_bloc.dart';
import 'package:ambition_delivery/presentation/bloc/socket_bloc.dart';
import 'package:ambition_delivery/presentation/bloc/profile_bloc.dart';
import 'package:ambition_delivery/presentation/bloc/driver_profile_bloc.dart';
import 'package:ambition_delivery/presentation/bloc/chat_bloc.dart';
import 'di/dependency_injection.dart';
import 'presentation/bloc/vehicle_categories_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            createUser: createUser,
            updateUser: updateUser,
            deleteUser: deleteUser,
            deleteUserByPhoneNumber: deleteUserByPhoneNumber,
            deleteDriver: deleteDriver,
            deleteDriverByPhoneNumber: deleteDriverByPhoneNumber,
            getUser: getUser,
            sendUserLoginOtpUsecase: sendUserLoginOtpUsecase,
            resendUserLoginOtpUsecase: resendUserLoginOtpUsecase,
            verifyUserLoginOtpUsecase: verifyUserLoginOtpUsecase,
            signInWithEmail: signInWithEmail,
            signInWithGoogle: signInWithGoogle,
            getAllVehicles: getAllVehicles,
            createDriver: createDriver,
            saveDriverLocally: saveDriverLocally,
            saveUserLocally: saveUserLocally,
            saveToken: saveToken,
            logoutLocally: logoutLocally,
            fetchCurrentLocation: fetchCurrentLocation,
            getLocalUser: getCurrentUser,
            verifyDriverOtpUsecase: verifyDriverOtpUsecase,
            verifyOtpUsecase: verifyOtpUsecase,
            resendOtpUsecase: resendOtpUsecase,
            resendDriverOtpUsecase: resendDriverOtpUsecase,
            saveOtpPhoneNumberUserTypeUsecase:
                saveOtpPhoneNumberUserTypeUsecase,
            getOtpPhoneNumberUserTypeUsecase: getOtpPhoneNumberUserTypeUsecase,
            deletePhoneNumberUserTypeUsecase: deletePhoneNumberUserTypeUsecase,
            resendOtpByEmailUsecase: resendOtpByEmailUsecase,
            resendOtpToDriverByEmailUsecase: resendOtpToDriverByEmailUsecase,
            sendOtpByEmailUsecase: sendOtpByEmailUsecase,
            sendOtpToDriverByEmailUsecase: sendOtpToDriverByEmailUsecase,
            updateDriverPasswordUsecase: updateDriverPasswordUsecase,
            updatePasswordUsecase: updatePasswordUsecase,
            verifyOtpForDriverByEmailUsecase: verifyOtpForDriverByEmailUsecase,
            verifyOtpByEmailUsecase: verifyOtpByEmailUsecase,
            sendUserTempOtpUsecase: sendUserTempOtpUsecase,
            verifyUserTempOtpUsecase: verifyUserTempOtpUsecase,
            resendUserTempOtpUsecase: resendUserTempOtpUsecase,
            sendDriverLoginOtpUsecase: sendDriverLoginOtpUsecase,
            resendDriverLoginOtpUsecase: resendDriverLoginOtpUsecase,
            verifyDriverLoginOtpUsecase: verifyDriverLoginOtpUsecase,
            sendDriverTempOtpUsecase: sendDriverTempOtpUsecase,
            resendDriverTempOtpUsecase: resendDriverTempOtpUsecase,
            verifyDriverTempOtpUsecase: verifyDriverTempOtpUsecase,
          ),
        ),
        BlocProvider<RideRequestBloc>(
          create: (context) => RideRequestBloc(
            getAllItems: getAllItems,
            createRideRequest: createRideRequest,
            updateRideRequest: updateRideRequest,
            cancelRideRequest: cancelRideRequest,
            completeRideRequest: completeRideRequest,
            getLocalUser: getCurrentUser,
            getPendingRideRequestsByDriverCarCategory:
                getPendingRideRequestsByDriverCarCategory,
            getOngoingRideRequestByUserId: getOngoingRideRequestByUserId,
            deleteRideRequest: deleteRideRequest,
            getOngoingRideRequestByDriverId: getOngoingRideRequestByDriverId,
            getClosedRideRequestsByDriverId: getClosedRideRequestsByDriverId,
            getClosedRideRequestsByUserId: getClosedRideRequestsByUserId,
            fetchCurrentLocation: fetchCurrentLocation,
            getPolylinePoints: getPolylinePoints,
            getDriverLocation: getDriverLocation,
            updateDriverLocation: updateDriverLocation,
            getUserLocation: getUserLocation,
            updateUserLocation: updateUserLocation,
          ),
        ),
        BlocProvider<VehicleCategoriesBloc>(
          create: (context) => VehicleCategoriesBloc(
            getVehicleCategoriesByItems: getVehicleCategoriesByItems,
            getVehicleCategoriesByPassengers: getVehicleCategoriesByPassengers,
          ),
        ),
        BlocProvider<SocketBloc>(
          create: (context) => SocketBloc(),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(
            getUser: getUser,
            updateUser: updateUser,
            deleteUser: deleteUser,
            logoutLocally: logoutLocally,
            getLocalUser: getCurrentUser,
          ),
        ),
        BlocProvider<DriverProfileBloc>(
          create: (context) => DriverProfileBloc(
            getDriver: getDriver,
            updateDriver: updateDriver,
            deleteDriver: deleteDriver,
            logoutLocally: logoutLocally,
            getLocalUser: getCurrentUser,
          ),
        ),
        BlocProvider<ChatBloc>(
          create: (context) => ChatBloc(
            getChatMessagesById: getChatMessagesById,
            getConversationById: getConversationById,
            sendMessage: sendMessage,
            getLocalUser: getCurrentUser,
          ),
        ),
        BlocProvider<RepeatJobBloc>(
          create: (context) => RepeatJobBloc(
            createRepeatJob: createRepeatJob,
            deleteRepeatJob: deleteRepeatJob,
            getLocalUser: getCurrentUser,
            getRepeatJobs: getRepeatJobs,
          ),
        ),
        BlocProvider<PaymentBloc>(
          create: (context) => PaymentBloc(
            createPaymentSheet: createPaymentSheet,
            presentPaymentSheet: presentPaymentSheet,
            getLocalUser: getCurrentUser,
          ),
        ),
        BlocProvider<InstructionBloc>(
          create: (context) => InstructionBloc(
            getInstructionsByUserType: getInstructionsByUserType,
          ),
        ),
      ],
      child: DismissFocusOverlay(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Ambition Delivery',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              scrolledUnderElevation: 0,
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Colors.white,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.grey,
            ),
            drawerTheme: const DrawerThemeData(
              backgroundColor: Colors.white,
            ),
            // dialogTheme: const DialogTheme(
            //   backgroundColor: Colors.white,
            // ),
          ),
          routes: appRoutes,
          navigatorObservers: const [],
        ),
      ),
    );
  }
}
