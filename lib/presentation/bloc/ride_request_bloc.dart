import 'package:ambition_delivery/domain/entities/item.dart';
import 'package:ambition_delivery/domain/entities/location_entity.dart';
import 'package:ambition_delivery/domain/entities/polyline_point_entity.dart';
import 'package:ambition_delivery/domain/entities/ride_with_earnings.dart';
import 'package:ambition_delivery/domain/usecases/cancel_ride_request.dart';
import 'package:ambition_delivery/domain/usecases/complete_ride_request.dart';
import 'package:ambition_delivery/domain/usecases/create_ride_request.dart';
import 'package:ambition_delivery/domain/usecases/delete_ride_request.dart';
import 'package:ambition_delivery/domain/usecases/fetch_current_location.dart';
import 'package:ambition_delivery/domain/usecases/get_all_items.dart';
import 'package:ambition_delivery/domain/usecases/get_closed_ride_requests_by_driver_id.dart';
import 'package:ambition_delivery/domain/usecases/get_closed_ride_requests_by_user_id.dart';
import 'package:ambition_delivery/domain/usecases/get_driver_location.dart';
import 'package:ambition_delivery/domain/usecases/get_local_user.dart';
import 'package:ambition_delivery/domain/usecases/get_ongoing_ride_request_by_driver_id.dart';
import 'package:ambition_delivery/domain/usecases/get_pending_ride_requests_by_driver_car_category.dart';
import 'package:ambition_delivery/domain/usecases/get_ongoing_ride_request_by_user_id.dart';
import 'package:ambition_delivery/domain/usecases/get_polyline_points.dart';
import 'package:ambition_delivery/domain/usecases/get_user_location.dart';
import 'package:ambition_delivery/domain/usecases/update_driver_location.dart';
import 'package:ambition_delivery/domain/usecases/update_ride_request.dart';
import 'package:ambition_delivery/domain/usecases/update_user_location.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/ride_request.dart';

part 'ride_request_event.dart';
part 'ride_request_state.dart';

class RideRequestBloc extends Bloc<RideRequestEvent, RideRequestState> {
  final GetAllItems getAllItems;
  final CreateRideRequest createRideRequest;
  final UpdateRideRequest updateRideRequest;
  final DeleteRideRequest deleteRideRequest;
  final CancelRideRequest cancelRideRequest;
  final CompleteRideRequest completeRideRequest;
  final GetPendingRideRequestsByDriverCarCategory
      getPendingRideRequestsByDriverCarCategory;
  final GetOngoingRideRequestByUserId getOngoingRideRequestByUserId;
  final GetOngoingRideRequestByDriverId getOngoingRideRequestByDriverId;
  final GetClosedRideRequestsByDriverId getClosedRideRequestsByDriverId;
  final GetClosedRideRequestsByUserId getClosedRideRequestsByUserId;
  final FetchCurrentLocation fetchCurrentLocation;
  final GetPolylinePoints getPolylinePoints;
  final GetDriverLocation getDriverLocation;
  final UpdateDriverLocation updateDriverLocation;
  final GetUserLocation getUserLocation;
  final UpdateUserLocation updateUserLocation;

  final GetLocalUser getLocalUser;

  RideRequestBloc({
    required this.getAllItems,
    required this.createRideRequest,
    required this.updateRideRequest,
    required this.deleteRideRequest,
    required this.cancelRideRequest,
    required this.completeRideRequest,
    required this.getPendingRideRequestsByDriverCarCategory,
    required this.getOngoingRideRequestByUserId,
    required this.getLocalUser,
    required this.getOngoingRideRequestByDriverId,
    required this.getClosedRideRequestsByDriverId,
    required this.getClosedRideRequestsByUserId,
    required this.fetchCurrentLocation,
    required this.getPolylinePoints,
    required this.getDriverLocation,
    required this.updateDriverLocation,
    required this.getUserLocation,
    required this.updateUserLocation,
  }) : super(RideRequestInitial()) {
    on<GetItems>(_onItemsRequested);
    on<CreateRideRequestEvent>(_onRideRequestCreated);
    on<UpdateRideRequestEvent>(_onRideRequestUpdated);
    on<DeleteRideRequestEvent>(_onDeleteRideRequest);
    on<GetCurrentUserDataEvent>(_onGetCurrentUserData);
    on<GetOngoingRideRequestByUserIdEvent>(
        _onOngoingRideRequestByUserIdRequested);
    on<GetPendingRideRequestsByDriverCarCategoryEvent>(
        _onPendingRideRequestByDriverCarCategoryRequested);
    on<GetOngoingRideRequestByDriverIdEvent>(_onOngoingRideRequestByDriverId);
    on<GetClosedRideRequestsByDriverIdEvent>(_onClosedRideRequestsByDriverId);
    on<GetClosedRideRequestsByUserIdEvent>(_onClosedRideRequestsByUserId);
    on<FetchCurrentLocationEvent>(_onFetchCurrentLocation);
    on<GetPolylinePointsEvent>(_onPolylinePointsRequested);
    on<CancelRideRequestEvent>(_onCancelRideRequest);
    on<CompleteRideRequestEvent>(_onCompleteRideRequest);
    on<UpdateDriverLocationEvent>(_onUpdateDriverLocation);
    on<UpdateUserLocationEvent>(_onUpdateUserLocation);
  }
  Future<void> _onItemsRequested(
      GetItems event, Emitter<RideRequestState> emit) async {
    try {
      emit(RideRequestLoading());
      final items = await getAllItems();
      emit(ItemsLoaded(items));
    } on DioException catch (e) {
      if (e.response != null) {
        emit(RideRequestError(e.response!.data.toString()));
      } else {
        emit(RideRequestError(e.message ?? 'An error occurred'));
      }
    } catch (e) {
      emit(RideRequestError(e.toString()));
    }
  }

  Future<void> _onRideRequestCreated(
      CreateRideRequestEvent event, Emitter<RideRequestState> emit) async {
    try {
      emit(RideRequestLoading());
      await createRideRequest(event.rideRequest);
      emit(RideRequestCreated());
    } on DioException catch (e) {
      if (e.response != null) {
        emit(RideRequestError(e.response!.data.toString()));
      } else {
        emit(RideRequestError(e.message ?? 'An error occurred'));
      }
    } catch (e) {
      emit(RideRequestError(e.toString()));
    }
  }

  Future<void> _onRideRequestUpdated(
      UpdateRideRequestEvent event, Emitter<RideRequestState> emit) async {
    try {
      emit(RideRequestLoading());
      final user = getLocalUser();
      Map<String, dynamic> rideRequest = {'driverId': user!['id']};
      await updateRideRequest(rideRequest, event.id);
      emit(RideRequestUpdated());
    } on DioException catch (e) {
      if (e.response != null) {
        emit(RideRequestError(e.response!.data.toString()));
      } else {
        emit(RideRequestError(e.message ?? 'An error occurred'));
      }
    } catch (e) {
      emit(RideRequestError(e.toString()));
    }
  }

  Future<void> _onGetCurrentUserData(
      GetCurrentUserDataEvent event, Emitter<RideRequestState> emit) async {
    try {
      emit(RideRequestLoading());
      final user = getLocalUser();
      emit(CurrentUserLoaded(user));
    } on DioException catch (e) {
      if (e.response != null) {
        emit(RideRequestError(e.response!.data.toString()));
      } else {
        emit(RideRequestError(e.message ?? 'An error occurred'));
      }
    } catch (e) {
      emit(RideRequestError(e.toString()));
    }
  }

  Future<void> _onPendingRideRequestByDriverCarCategoryRequested(
      GetPendingRideRequestsByDriverCarCategoryEvent event,
      Emitter<RideRequestState> emit) async {
    try {
      emit(RideRequestLoading());
      final user = getLocalUser();
      final rideRequest =
          await getPendingRideRequestsByDriverCarCategory(user!['id']);
      if (rideRequest != null) {
        emit(PendingRideRequestsLoaded(rideRequest));
      } else {
        emit(NoPendingRideRequests());
      }
    } on DioException catch (_) {
      emit(NoPendingRideRequests());
    } catch (e) {
      emit(NoPendingRideRequests());
    }
  }

  Future<void> _onOngoingRideRequestByUserIdRequested(
      GetOngoingRideRequestByUserIdEvent event,
      Emitter<RideRequestState> emit) async {
    try {
      emit(RideRequestLoading());
      final user = getLocalUser();
      final rideRequest = await getOngoingRideRequestByUserId(user!['id']);
      if (rideRequest != null) {
        Set<Polyline> polylines = {};
        LocationEntity? carDriverLocation;
        if (rideRequest.carDriverId != null) {
          carDriverLocation = await getDriverLocation(rideRequest.carDriverId!);
          try {
            final polylinePoints = await getPolylinePoints({
              'origin': [
                carDriverLocation!.coordinates[0],
                carDriverLocation.coordinates[1]
              ],
              'destination': [
                rideRequest.pickupLocation.coordinates[0],
                rideRequest.pickupLocation.coordinates[1]
              ]
            });
            polylines.add(
              Polyline(
                polylineId: const PolylineId("car_driver_to_pickup"),
                points: polylinePoints
                    .map((point) =>
                        LatLng(point.lat.toDouble(), point.lng.toDouble()))
                    .toList(),
                color: Colors.green,
                width: 5,
              ),
            );
          } catch (e) {
            print('Failed to fetch polyline: $e');
            // Continue without polyline
          }
        }
        emit(OnGoingUserRideRequestLoaded(
            rideRequest: rideRequest,
            driverPosition: null,
            carDriverPosition: carDriverLocation,
            polylines: polylines));
      } else {
        emit(NoOngoingRideRequest());
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.data['type'] == "USER_NOT_FOUND") {
          emit(UserNotFoundError());
        } else if (e.response!.data['type'] == "USER_DISABLED") {
          emit(UserDisabledError());
        } else {
          emit(NoOngoingRideRequest());
        }
      }
    } catch (e) {
      emit(NoOngoingRideRequest());
    }
  }

  Future<void> _onOngoingRideRequestByDriverId(
      GetOngoingRideRequestByDriverIdEvent event,
      Emitter<RideRequestState> emit) async {
    try {
      emit(RideRequestLoading());
      final user = getLocalUser();
      final rideRequest = await getOngoingRideRequestByDriverId(user!['id']);
      // Check both driverId and carDriverId
      print('rideRequest.driverId: ${rideRequest?.driverId}');
      print('rideRequest.carDriverId: ${rideRequest?.carDriverId}');
      print('current user id: ${user['id']}');
      if (rideRequest != null &&
          (rideRequest.driverId == user['id'] ||
              rideRequest.carDriverId == user['id'])) {
        print('Emitting OnGoingRideRequestLoaded for ride: ${rideRequest.id}');
        final driverPosition = await fetchCurrentLocation();
        final userPostion = await getUserLocation(rideRequest.user);
        List<Polyline> polylines = [];
        try {
          final polylinePoints = await getPolylinePoints({
            'origin': driverPosition != null
                ? [driverPosition.latitude, driverPosition.longitude]
                : rideRequest.pickupLocation.coordinates,
            'destination': rideRequest.pickupLocation.coordinates,
          });
          if (polylinePoints.isNotEmpty) {
            polylines.add(
              Polyline(
                polylineId: const PolylineId("pickup_route"),
                points: polylinePoints
                    .map((point) =>
                        LatLng(point.lat.toDouble(), point.lng.toDouble()))
                    .toList(),
                color: Colors.blue,
                width: 5,
              ),
            );
          } else {
            // Fallback: straight line from driver to pickup
            polylines.add(
              Polyline(
                polylineId: const PolylineId("pickup_route_fallback"),
                points: [
                  LatLng(driverPosition.latitude, driverPosition.longitude),
                  LatLng(rideRequest.pickupLocation.coordinates[0].toDouble(),
                      rideRequest.pickupLocation.coordinates[1].toDouble()),
                ],
                color: Colors.red,
                width: 3,
              ),
            );
          }
        } catch (e) {
          print('Failed to fetch polyline: $e');
          // Fallback: straight line from driver to pickup
          polylines.add(
            Polyline(
              polylineId: const PolylineId("pickup_route_fallback"),
              points: [
                LatLng(driverPosition.latitude, driverPosition.longitude),
                LatLng(rideRequest.pickupLocation.coordinates[0].toDouble(),
                    rideRequest.pickupLocation.coordinates[1].toDouble()),
              ],
              color: Colors.red,
              width: 3,
            ),
          );
        }
        emit(OnGoingRideRequestLoaded(
          rideRequest: rideRequest,
          driverPosition: driverPosition,
          userPosition: userPostion!,
          polylines: polylines.toSet(),
        ));
      } else {
        print('Emitting NoOngoingRideRequest');
        emit(NoOngoingRideRequest());
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.data['type'] == "DRIVER_NOT_FOUND") {
          emit(DriverNotFoundError());
        } else if (e.response!.data['type'] == "DRIVER_DISABLED") {
          emit(DriverDisabledError());
        } else {
          emit(NoOngoingRideRequest());
        }
      }
    } catch (e) {
      emit(NoOngoingRideRequest());
    }
  }

  Future<void> _onClosedRideRequestsByDriverId(
      GetClosedRideRequestsByDriverIdEvent event,
      Emitter<RideRequestState> emit) async {
    try {
      emit(RideRequestLoading());
      final user = getLocalUser();
      final rideRequest = await getClosedRideRequestsByDriverId(user!['id']);
      emit(ClosedRideRequestsLoaded(rideRequest));
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.data['type'] == "DRIVER_NOT_FOUND") {
          emit(DriverNotFoundError());
        } else if (e.response!.data['type'] == "DRIVER_DISABLED") {
          emit(DriverDisabledError());
        } else {
          emit(RideRequestError(e.toString()));
        }
      }
    } catch (e) {
      emit(RideRequestError(e.toString()));
    }
  }

  Future<void> _onClosedRideRequestsByUserId(
      GetClosedRideRequestsByUserIdEvent event,
      Emitter<RideRequestState> emit) async {
    try {
      emit(RideRequestLoading());
      final user = getLocalUser();
      final rideRequest = await getClosedRideRequestsByUserId(user!['id']);
      emit(ClosedRideRequestsLoaded(rideRequest));
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.data['type'] == "USER_NOT_FOUND") {
          emit(UserNotFoundError());
        } else if (e.response!.data['type'] == "USER_DISABLED") {
          emit(UserDisabledError());
        } else {
          emit(RideRequestError(e.toString()));
        }
      }
    } catch (e) {
      emit(RideRequestError(e.toString()));
    }
  }

  Future<void> _onDeleteRideRequest(
      DeleteRideRequestEvent event, Emitter<RideRequestState> emit) async {
    try {
      emit(RideRequestLoading());
      await deleteRideRequest(event.id);
      emit(RideRequestDeleted());
    } on DioException catch (e) {
      if (e.response != null) {
        emit(RideRequestError(e.response!.data.toString()));
      } else {
        emit(RideRequestError(e.message ?? 'An error occurred'));
      }
    } catch (e) {
      emit(RideRequestError(e.toString()));
    }
  }

  Future<void> _onFetchCurrentLocation(
      FetchCurrentLocationEvent event, Emitter<RideRequestState> emit) async {
    try {
      emit(RideRequestLoading());
      final position = await fetchCurrentLocation();
      emit(CurrentLocationLoaded(position: position));
    } on DioException catch (e) {
      if (e.response != null) {
        emit(RideRequestError(e.response!.data.toString()));
      } else {
        emit(RideRequestError(e.message ?? 'An error occurred'));
      }
    } catch (e) {
      emit(RideRequestError(e.toString()));
    }
  }

  Future<void> _onPolylinePointsRequested(
      GetPolylinePointsEvent event, Emitter<RideRequestState> emit) async {
    try {
      emit(RideRequestLoading());
      final polylinePoints = await getPolylinePoints(event.data);
      emit(PolylinePointsLoaded(polylinePoints));
    } on DioException catch (e) {
      if (e.response != null) {
        emit(RideRequestError(e.response!.data.toString()));
      } else {
        emit(RideRequestError(e.message ?? 'An error occurred'));
      }
    } catch (e) {
      emit(RideRequestError(e.toString()));
    }
  }

  Future<void> _onCancelRideRequest(
      CancelRideRequestEvent event, Emitter<RideRequestState> emit) async {
    try {
      emit(RideRequestLoading());
      await cancelRideRequest(event.rideId);
      emit(RideRequestCancelled());
    } on DioException catch (e) {
      if (e.response != null) {
        emit(RideRequestError(e.response!.data.toString()));
      } else {
        emit(RideRequestError(e.message ?? 'An error occurred'));
      }
    } catch (e) {
      emit(RideRequestError(e.toString()));
    }
  }

  Future<void> _onCompleteRideRequest(
      CompleteRideRequestEvent event, Emitter<RideRequestState> emit) async {
    try {
      emit(RideRequestLoading());
      await completeRideRequest(event.rideId);
      emit(RideRequestCompleted());
    } on DioException catch (e) {
      if (e.response != null) {
        emit(RideRequestError(e.response!.data.toString()));
      } else {
        emit(RideRequestError(e.message ?? 'An error occurred'));
      }
    } catch (e) {
      emit(RideRequestError(e.toString()));
    }
  }

  Future<void> _onUpdateDriverLocation(
      UpdateDriverLocationEvent event, Emitter<RideRequestState> emit) async {
    try {
      final user = getLocalUser();
      final position = await fetchCurrentLocation();
      await updateDriverLocation(user!['id'], {
        'latitude': position.latitude,
        'longitude': position.longitude,
      });
    } on DioException catch (e) {
      if (e.response != null) {
        emit(RideRequestError(e.response!.data.toString()));
      } else {
        emit(RideRequestError(e.message ?? 'An error occurred'));
      }
    } catch (e) {
      emit(RideRequestError(e.toString()));
    }
  }

  Future<void> _onUpdateUserLocation(
      UpdateUserLocationEvent event, Emitter<RideRequestState> emit) async {
    try {
      final user = getLocalUser();
      final position = await fetchCurrentLocation();
      await updateUserLocation(user!['id'], {
        'latitude': position.latitude,
        'longitude': position.longitude,
      });
    } on DioException catch (e) {
      if (e.response != null) {
        emit(RideRequestError(e.response!.data.toString()));
      } else {
        emit(RideRequestError(e.message ?? 'An error occurred'));
      }
    } catch (e) {
      emit(RideRequestError(e.toString()));
    }
  }
}
