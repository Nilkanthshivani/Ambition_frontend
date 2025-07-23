import 'dart:async';
import 'dart:convert';

import 'package:ambition_delivery/domain/entities/location_entity.dart';
import 'package:ambition_delivery/domain/entities/polyline_point_entity.dart';
import 'package:ambition_delivery/domain/entities/ride_request.dart';
import 'package:ambition_delivery/presentation/bloc/auth_bloc.dart';
import 'package:ambition_delivery/presentation/bloc/repeat_job_event.dart';
import 'package:ambition_delivery/presentation/bloc/ride_request_bloc.dart';
import 'package:ambition_delivery/presentation/bloc/socket_bloc.dart';
import 'package:ambition_delivery/presentation/bloc/socket_state.dart';
import 'package:ambition_delivery/presentation/bloc/repeat_job_bloc.dart';
import 'package:ambition_delivery/presentation/bloc/repeat_job_state.dart';
import 'package:ambition_delivery/presentation/widgets/ride_details_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_switch/flutter_switch.dart';

class DriverMainPage extends StatefulWidget {
  const DriverMainPage({super.key});

  @override
  State<DriverMainPage> createState() => _DriverMainPageState();
}

class _DriverMainPageState extends State<DriverMainPage> {
  late SocketBloc _socketBloc;
  late AuthBloc _authBloc;
  List<PolylinePointEntity>? polylinePointsFromCurrentToPickup;

  StreamSubscription<Position>? _positionStreamSubscription;
  Position? _currentPosition;
  LocationEntity? userPosition;
  // Add isOnline state
  bool isOnline = true;
  Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      // Handle the case when permission is permanently denied.
      return;
    }
    _startTracking();
  }

  void _startTracking() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Update when moved more than 10 meters
    );

    _positionStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      setState(() {
        _currentPosition = position;
        BlocProvider.of<RideRequestBloc>(context)
            .add(UpdateDriverLocationEvent());
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _socketBloc = BlocProvider.of<SocketBloc>(context);
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _checkLocationPermission();
    BlocProvider.of<RideRequestBloc>(context)
        .add(GetOngoingRideRequestByDriverIdEvent());
    _socketBloc.subscribeToEvents(_authBloc.currentUserId);
    // Fetch scheduled moves
    BlocProvider.of<RepeatJobBloc>(context).add(GetRepeatJobsEvent());
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
            if (state is RideRequestUpdated) {
              BlocProvider.of<RideRequestBloc>(context)
                  .add(GetOngoingRideRequestByDriverIdEvent());
            } else if (state is RideRequestCompleted) {
            } else if (state is RideRequestCancelled) {
            } else if (state is DriverDisabledError) {
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
            } else if (state is DriverNotFoundError) {
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
            if (state is UserLocationReceived) {
              Map<String, dynamic> data = jsonDecode(state.location);
              final lat = data["coordinates"][0];
              final long = data["coordinates"][1];
              setState(() {
                userPosition = LocationEntity(
                  name: "User Location",
                  address: "User Address",
                  coordinates: [lat, long],
                  type: "Point",
                );
              });
            }
          },
        ),
      ],
      child: BlocBuilder<RideRequestBloc, RideRequestState>(
        builder: (context, state) {
          if (state is RideRequestLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is OnGoingRideRequestLoaded) {
            RideRequest rideRequest = state.rideRequest;
            return Scaffold(
              appBar: AppBar(title: const Text("Ongoing Ride")),
              body: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(state.driverPosition.latitude,
                          state.driverPosition.longitude),
                      zoom: 14,
                    ),
                    onMapCreated: (GoogleMapController controller) {},
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
                      if (userPosition != null)
                        Marker(
                          markerId: const MarkerId("passenger"),
                          position: LatLng(
                              userPosition!.coordinates[0].toDouble(),
                              userPosition!.coordinates[1].toDouble()),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueRed),
                          infoWindow:
                              const InfoWindow(title: "Passenger Location"),
                        ),
                      if (userPosition == null)
                        Marker(
                          markerId: const MarkerId("passenger"),
                          position: LatLng(
                              state.userPosition.coordinates[0].toDouble(),
                              state.userPosition.coordinates[1].toDouble()),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueCyan),
                          infoWindow:
                              const InfoWindow(title: "Passenger Location"),
                        ),
                      Marker(
                        markerId: const MarkerId("pickup"),
                        position: LatLng(
                            state.rideRequest.pickupLocation.coordinates[0]
                                .toDouble(),
                            state.rideRequest.pickupLocation.coordinates[1]
                                .toDouble()),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueMagenta),
                        infoWindow: const InfoWindow(title: "Pickup Location"),
                      ),
                      Marker(
                        markerId: const MarkerId("dropoff"),
                        position: LatLng(
                            state.rideRequest.dropoffLocation.coordinates[0]
                                .toDouble(),
                            state.rideRequest.dropoffLocation.coordinates[1]
                                .toDouble()),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueViolet),
                        infoWindow: const InfoWindow(title: "Dropoff Location"),
                      ),
                    },
                    polylines: state.polylines,
                  ),
                  RideDetailsWidget(
                    rideRequest: rideRequest,
                    originPlace: (_currentPosition?.latitude != null &&
                            _currentPosition?.longitude != null)
                        ? LocationEntity(
                            name: "current location",
                            address: "current address",
                            coordinates: [
                              _currentPosition!.latitude.toDouble(),
                              _currentPosition!.longitude.toDouble(),
                            ],
                            type: "Point",
                          )
                        : null,
                    destinationPlace: rideRequest.dropoffLocation,
                    waypointsPlaces: [
                      rideRequest.pickupLocation,
                    ],
                  ),
                ],
              ),
            );
          } else if (state is NoOngoingRideRequest) {
            // When no ongoing ride exists, fetch pending ride requests
            BlocProvider.of<RideRequestBloc>(context)
                .add(GetPendingRideRequestsByDriverCarCategoryEvent());
            // Show scheduled moves section only, do NOT access state.rideRequests here
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
                  ],
                ),
              ),
            );
          } else if (state is PendingRideRequestsLoaded) {
            List<RideRequest?> rideRequests = state.rideRequests.rideRequests;
            return Scaffold(
              body: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 100), // Height of the card + margin
                    child: Column(
                      children: [
                        // Map, buttons, online button, etc.
                        Container(
                          height: 200,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: _currentPosition != null
                                  ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
                                  : const LatLng(51.456, 0.1313),
                              zoom: 14,
                            ),
                            onMapCreated: (controller) {},
                            markers: {
                              if (_currentPosition != null)
                                Marker(
                                  markerId: const MarkerId("current"),
                                  position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                                  infoWindow: const InfoWindow(title: "Your Location"),
                                ),
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () {
                              // Add your logic here
                            },
                            child: const Text(
                              "Show Accepted/Scheduled Job",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: FlutterSwitch(
                            width: 120.0, // Increased width
                            height: 40.0,
                            valueFontSize: 18.0, // Larger text
                            toggleSize: 32.0,
                            value: isOnline,
                            borderRadius: 24.0,
                            activeColor: Colors.black,
                            inactiveColor: Colors.grey,
                            activeText: "Online",
                            inactiveText: "Offline",
                            activeTextColor: Colors.white,
                            inactiveTextColor: Colors.white,
                            showOnOff: true,
                            onToggle: (val) {
                              setState(() {
                                isOnline = val;
                              });
                            },
                          ),
                        ),
                        // Only show the list or message if online
                        if (isOnline)
                          Expanded(
                            child: rideRequests.isEmpty
                                ? Center(
                                    child: const Text(
                                      "No Pending Ride Requests",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: rideRequests.length,
                                    itemBuilder: (context, index) {
                                      RideRequest rideRequest = rideRequests[index]!;
                                      return AvailableJobsCard(
                                        avilableJob: rideRequest,
                                        onAccept: () {
                                          BlocProvider.of<RideRequestBloc>(context)
                                              .add(UpdateRideRequestEvent(id: rideRequest.id));
                                        },
                                      );
                                    },
                                  ),
                          ),
                      ],
                    ),
                  ),
                  // Fixed Total Earnings card at the bottom
                  Positioned(
                    left: 8,
                    right: 8,
                    bottom: 8,
                    child: Card(
                      margin: EdgeInsets.zero, // No margin, full width
                      color: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        side: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //Total Earnings
                            Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2.0),
                                  child: Text("Total Earnings",
                                      style: TextStyle(fontSize: 20)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                                  child: Text(
                                      "£${state.rideRequests.totalEarnings.toStringAsFixed(2)}",
                                      style: const TextStyle(fontSize: 20)),
                                ),
                              ],
                            ),
                            //Total Rides
                            Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2.0),
                                  child: Text("Total Rides",
                                      style: TextStyle(fontSize: 20)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                                  child: Text("${state.rideRequests.totalRides}",
                                      style: const TextStyle(fontSize: 20)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is RideRequestError) {
            return Scaffold(
              body: Center(
                child: Text("Error: ${state.message}"),
              ),
            );
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}

class AvailableJobsCard extends StatelessWidget {
  final RideRequest avilableJob;
  final VoidCallback onAccept;

  const AvailableJobsCard({
    super.key,
    required this.avilableJob,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[200],
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Request ID: ${avilableJob.id}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Type: ${avilableJob.jobType}'),
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(width: 8),
                if (avilableJob.isRideAndMove) ...[
                  const SizedBox(width: 16),
                  const Icon(Icons.directions_car),
                  const SizedBox(width: 8),
                  const Text('Ride & Move'),
                ],
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.people),
                const SizedBox(width: 8),
                Text('Helpers: ${avilableJob.requirements.requiredHelpers}'),
                const SizedBox(width: 16),
                const Icon(Icons.local_offer),
                const SizedBox(width: 8),
                Text(
                    'Items: ${avilableJob.items.length + avilableJob.customItems.length}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.stairs),
                const SizedBox(width: 8),
                Text(
                    'Floors: ${avilableJob.requirements.pickupFloor} → ${avilableJob.requirements.dropoffFloor}'),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Origin:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(avilableJob.pickupLocation.name),
            Text(avilableJob.pickupLocation.address),
            const SizedBox(height: 8),
            const Text('Destination:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(avilableJob.dropoffLocation.name),
            Text(avilableJob.dropoffLocation.address),
            if (avilableJob.requirements.specialRequirements.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text('Special Requirements:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(avilableJob.requirements.specialRequirements),
            ],
            const SizedBox(height: 16),

            //Distance
            Row(
              children: [
                const Icon(Icons.directions),
                const SizedBox(width: 8),
                Text('Distance: ${avilableJob.distance} km'),
              ],
            ),

            //Fare
            Row(
              children: [
                //Pound Icon
                const Icon(Icons.attach_money),
                const SizedBox(width: 8),
                Text('Fare: ${avilableJob.fare.total}'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  onPressed: onAccept,
                  child: const Text('Accept Ride Request'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
