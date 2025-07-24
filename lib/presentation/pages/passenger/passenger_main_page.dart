import 'dart:async';
import 'dart:convert';

import 'package:ambition_delivery/domain/entities/location_entity.dart';
import 'package:ambition_delivery/domain/entities/ride_request.dart';
import 'package:ambition_delivery/presentation/bloc/auth_bloc.dart';
import 'package:ambition_delivery/presentation/bloc/repeat_job_event.dart';
import 'package:ambition_delivery/presentation/bloc/ride_request_bloc.dart';
import 'package:ambition_delivery/presentation/bloc/socket_bloc.dart';
import 'package:ambition_delivery/presentation/bloc/socket_state.dart';
import 'package:ambition_delivery/presentation/bloc/repeat_job_bloc.dart';
import 'package:ambition_delivery/presentation/bloc/repeat_job_state.dart';
import 'package:ambition_delivery/presentation/widgets/ride_details_widget.dart';
import 'package:ambition_delivery/presentation/widgets/ongoing_ride_details_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PassengerMainPage extends StatefulWidget {
  const PassengerMainPage({super.key});

  @override
  State<PassengerMainPage> createState() => _PassengerMainPageState();
}

class _PassengerMainPageState extends State<PassengerMainPage> {
  late SocketBloc _socketBloc;
  late AuthBloc _authBloc;
  late RideRequestBloc _rideRequestBloc;
  @override
  void initState() {
    _socketBloc = BlocProvider.of<SocketBloc>(context);
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _rideRequestBloc = BlocProvider.of<RideRequestBloc>(context);
    _checkLocationPermission();
    _rideRequestBloc.add(GetOngoingRideRequestByUserIdEvent());
    _socketBloc.subscribeToEvents(_authBloc.currentUserId);
    // Fetch scheduled moves
    BlocProvider.of<RepeatJobBloc>(context).add(GetRepeatJobsEvent());
    super.initState();
  }

  StreamSubscription<Position>? _positionStreamSubscription;
  Position? _currentPosition;
  LocationEntity? _driverPosition;
  LocationEntity? _carDriverPosition;

  Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      // Handle the case when permission is permanently denied.
      return;
    }
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      getCurrentLocation();
    }
    _startTracking();
  }

  Future<void> getCurrentLocation() async {
    final Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
    });
  }

  void _startTracking() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Update when moved more than 10 meters
    );
    _positionStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      //update if the position has changed by more than 10 meters.
      if (_currentPosition != null &&
          Geolocator.distanceBetween(
                  _currentPosition!.latitude,
                  _currentPosition!.longitude,
                  position.latitude,
                  position.longitude) >
              10) {
        setState(() {
          _currentPosition = position;
          _rideRequestBloc.add(UpdateUserLocationEvent());
        });
      }
    });
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    _socketBloc.unsubscribeFromEvents(_authBloc.currentUserId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<RideRequestBloc, RideRequestState>(
            listener: (context, state) {
              if (state is RideRequestDeleted) {
              } else if (state is UserDisabledError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("User is disabled"),
                  ),
                );
                _authBloc.add(SignOutEvent());
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              } else if (state is UserNotFoundError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("User not found"),
                  ),
                );
                _authBloc.add(SignOutEvent());
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              }
            },
          ),
          BlocListener<SocketBloc, SocketState>(
            listener: (context, state) {
              if (state is RideRequestAccepted) {
                BlocProvider.of<RideRequestBloc>(context)
                    .add(GetOngoingRideRequestByUserIdEvent());
              }
              if (state is DriverLocationReceived) {
                Map<String, dynamic> data = jsonDecode(state.location);
                final lat = data["coordinates"][0];
                final long = data["coordinates"][1];

                setState(() {
                  _driverPosition = LocationEntity(
                    coordinates: [lat, long],
                    name: "Driver Location",
                    address: "Driver Address",
                    type: "Point",
                  );
                });
              }
              if (state is CarDriverLocationReceived) {
                Map<String, dynamic> data = jsonDecode(state.location);
                final lat = data["coordinates"][0];
                final long = data["coordinates"][1];

                setState(() {
                  _carDriverPosition = LocationEntity(
                    coordinates: [lat, long],
                    name: "Car Driver Location",
                    address: "Car Driver Address",
                    type: "Point",
                  );
                });
              }
            },
          ),
        ],
        child: BlocBuilder<RideRequestBloc, RideRequestState>(
            builder: (context, state) {
          debugPrint("State: $state");
          if (state is OnGoingUserRideRequestLoaded) {
            debugPrint("Ongoing ride status: "+state.rideRequest.status);
          }
          if (state is RideRequestLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is OnGoingUserRideRequestLoaded) {
            RideRequest rideRequest = state.rideRequest;

            return Scaffold(
              appBar: AppBar(title: const Text("Ongoing Ride")),
              body: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _currentPosition != null
                          ? LatLng(_currentPosition!.latitude,
                              _currentPosition!.longitude)
                          : const LatLng(51.456, 0.1313),
                      zoom: 14,
                    ),
                    onMapCreated: (controller) {},
                    markers: {
                      if (_currentPosition != null)
                        Marker(
                          markerId: const MarkerId("current"),
                          position: LatLng(_currentPosition!.latitude,
                              _currentPosition!.longitude),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueBlue),
                          infoWindow: const InfoWindow(title: "Your Location"),
                        ),
                      if (_driverPosition != null)
                        Marker(
                          markerId: const MarkerId("driver"),
                          position: LatLng(
                              _driverPosition!.coordinates[0].toDouble(),
                              _driverPosition!.coordinates[1].toDouble()),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueRed),
                          infoWindow:
                              const InfoWindow(title: "Van Driver Location"),
                        ),
                      if (_driverPosition == null &&
                          state.driverPosition != null)
                        Marker(
                          markerId: const MarkerId("driver"),
                          position: LatLng(
                              state.driverPosition!.coordinates[0].toDouble(),
                              state.driverPosition!.coordinates[1].toDouble()),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueRed),
                          infoWindow:
                              const InfoWindow(title: "Van Driver Location"),
                        ),
                      if (_carDriverPosition != null)
                        Marker(
                          markerId: const MarkerId("car_driver"),
                          position: LatLng(
                              _carDriverPosition!.coordinates[0].toDouble(),
                              _carDriverPosition!.coordinates[1].toDouble()),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueGreen),
                          infoWindow:
                              const InfoWindow(title: "Car Driver Location"),
                        ),
                      if (_carDriverPosition == null &&
                          state.carDriverPosition != null)
                        Marker(
                          markerId: const MarkerId("car_driver"),
                          position: LatLng(
                              state.carDriverPosition!.coordinates[0]
                                  .toDouble(),
                              state.carDriverPosition!.coordinates[1]
                                  .toDouble()),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueGreen),
                          infoWindow:
                              const InfoWindow(title: "Car Driver Location"),
                        ),
                      Marker(
                        markerId: const MarkerId("pickup"),
                        position: LatLng(
                            state.rideRequest.pickupLocation.coordinates[0]
                                .toDouble(),
                            state.rideRequest.pickupLocation.coordinates[1]
                                .toDouble()),
                        icon: BitmapDescriptor.defaultMarker,
                        infoWindow: const InfoWindow(title: "Pickup Location"),
                      ),
                      Marker(
                        markerId: const MarkerId("dropoff"),
                        position: LatLng(
                            state.rideRequest.dropoffLocation.coordinates[0]
                                .toDouble(),
                            state.rideRequest.dropoffLocation.coordinates[1]
                                .toDouble()),
                        icon: BitmapDescriptor.defaultMarker,
                        infoWindow: const InfoWindow(title: "Dropoff Location"),
                      ),
                    },
                    polylines: state.polylines,
                  ),
                  RideDetailsWidget(
                    rideRequest: rideRequest,
                    originPlace: rideRequest.pickupLocation,
                    destinationPlace: rideRequest.dropoffLocation,
                    waypointsPlaces: const [],
                  ),
                ],
              ),
            );
          } else {
            return Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    BlocBuilder<RepeatJobBloc, RepeatJobState>(
                      builder: (context, repeatJobState) {
                        if (repeatJobState is RepeatJobLoading) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } else if (repeatJobState is RepeatJobLoaded && repeatJobState.jobs.isNotEmpty) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                child: Text(
                                  'Scheduled Move(s)',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    side: BorderSide(color: Colors.grey.shade300, width: 1),
                                  ),
                                  elevation: 0,
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: repeatJobState.jobs.length,
                                    separatorBuilder: (context, idx) => Divider(height: 1, color: Colors.grey.shade200),
                                    itemBuilder: (context, idx) {
                                      final job = repeatJobState.jobs[idx];
                                      return ListTile(
                                        leading: Icon(Icons.local_shipping, size: 36, color: Colors.blueGrey),
                                        title: Text(job.moveType, style: const TextStyle(fontWeight: FontWeight.bold)),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('${job.originName} → ${job.destinationName}', maxLines: 1, overflow: TextOverflow.ellipsis),
                                            Text('Scheduled: ${job.jobType}'),
                                            Text('Date: ${job.originLat != null ? DateTime.now().toString().substring(0, 10) : ''}'), // Replace with actual date if available
                                          ],
                                        ),
                                        trailing: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            if (job.passengersCount != null)
                                              Text('x${job.passengersCount}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                            // Add fare if available
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else if (repeatJobState is RepeatJobLoaded && repeatJobState.jobs.isEmpty) {
                          return const SizedBox();
                        } else if (repeatJobState is RepeatJobError) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text('Failed to load scheduled moves: ${repeatJobState.message}', style: TextStyle(color: Colors.red)),
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                    //Guidelines for customers in a separate page
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8.0),
                      child: Card(
                        color: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 12.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.info_outline,
                                color: Colors.grey,
                                size: 24,
                              ),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Text(
                                  "Customer Guidelines",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed('/customer_tips');
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    '/pickup_dropoff_address',
                                    arguments: 'move',
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.search, color: Colors.black),
                                      SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          "Let's move",
                                          style: TextStyle(color: Colors.black),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                                width: 10), // Adds spacing between buttons
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now()
                                        .add(const Duration(days: 7)),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.schedule, color: Colors.black),
                                      SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          'Select Date & Time',
                                          style: TextStyle(color: Colors.black),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Icon(Icons.arrow_drop_down,
                                          color: Colors.black),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        children: [
                          const Text(
                            "More Ambition",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          //Repeat a ride

                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed('/repeat_job');
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: const Row(
                                  children: [
                                    Text('Repeat a ride'),
                                    SizedBox(width: 8),
                                    Icon(Icons.repeat),
                                  ],
                                )),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: CategoryCard(
                                  imagePath: 'assets/ride_move.png',
                                  label: "Ride & Move",
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        '/pickup_dropoff_address',
                                        arguments: 'ride & move');
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: CategoryCard(
                                  imagePath:
                                      'assets/ambition_refrigeration.png',
                                  label: "Ambition Refrigeration",
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        '/pickup_dropoff_address',
                                        arguments: 'refrigeration');
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                            height: 10), // Add spacing between the rows
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: CategoryCard(
                                  imagePath: 'assets/ambition_luton_van.png',
                                  label: "Ambition Luton Van",
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        '/pickup_dropoff_address',
                                        arguments: 'luton van');
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: CategoryCard(
                                  imagePath: 'assets/ambition_environment.png',
                                  label: "Ambition Environment",
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        '/pickup_dropoff_address',
                                        arguments: 'ambition enviorment');
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        //Google Map with the current location of the user
                        Container(
                          height: 200,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: _currentPosition != null
                                  ? LatLng(_currentPosition!.latitude,
                                      _currentPosition!.longitude)
                                  : const LatLng(51.456, 0.1313),
                              zoom: 14,
                            ),
                            onMapCreated: (controller) {},
                            markers: {
                              if (_currentPosition != null)
                                Marker(
                                  markerId: const MarkerId("current"),
                                  position: LatLng(_currentPosition!.latitude,
                                      _currentPosition!.longitude),
                                  icon: BitmapDescriptor.defaultMarkerWithHue(
                                      BitmapDescriptor.hueBlue),
                                  infoWindow:
                                      const InfoWindow(title: "Your Location"),
                                ),
                            },
                          ),
                        ),

                        const SizedBox(height: 10),
                      ],
                    )
                  ],
                ),
              ),
            );
          }
        }));
  }
}

class CategoryCard extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onTap;

  const CategoryCard(
      {super.key,
      required this.imagePath,
      required this.label,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[200],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                height: 100,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
