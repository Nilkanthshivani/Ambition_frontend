import 'package:ambition_delivery/domain/entities/location_entity.dart';
import 'package:ambition_delivery/domain/entities/ride_request.dart';
import 'package:ambition_delivery/presentation/bloc/ride_request_bloc.dart';
import 'package:ambition_delivery/utils/utility_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RideDetailsWidget extends StatefulWidget {
  final RideRequest rideRequest;
  final LocationEntity? originPlace;
  final LocationEntity? destinationPlace;
  final List<LocationEntity>? waypointsPlaces;

  const RideDetailsWidget(
      {super.key,
      required this.rideRequest,
      required this.originPlace,
      required this.destinationPlace,
      required this.waypointsPlaces});

  @override
  State<RideDetailsWidget> createState() => _RideDetailsWidgetState();
}

class _RideDetailsWidgetState extends State<RideDetailsWidget> {
  bool _isExpanded = false; // State variable to manage expansion

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300), // Animation duration
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10.0,
            )
          ],
        ),
        // Use ConstrainedBox to limit height and avoid overflow
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: _isExpanded ? double.infinity : 80),
          child: SingleChildScrollView(
            // Add scroll functionality
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Ongoing Ride Details",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Icon(_isExpanded
                              ? Icons.expand_less
                              : Icons.expand_more),
                          onPressed: () {
                            setState(() {
                              _isExpanded =
                                  !_isExpanded; // Toggle the expansion state
                            });
                          },
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (_isExpanded) ...[
                  // --- Added points start ---

                  // Driver's photo
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: widget.rideRequest.driver?.profile !=
                                    null &&
                                widget.rideRequest.driver!.profile.isNotEmpty
                            ? NetworkImage(widget.rideRequest.driver!.profile)
                            : null,
                        child: widget.rideRequest.driver?.profile == null ||
                                widget.rideRequest.driver!.profile.isEmpty
                            ? Icon(Icons.person)
                            : null,
                        radius: 20,
                      ),
                      SizedBox(width: 8),
                      // Text(widget.rideRequest.driver?.name ?? "Driver Photo"),
                    ],
                  ), // Driver's name

                  Text("Driver Name: " +
                      (widget.rideRequest.driver?.name ?? 'N/A')),
                  // Driver's rating (mocked),
                  Text("Rating: comming soon"),
                  // Job reference number
                  Text("Job Ref: ${widget.rideRequest.id}"),
                  // ETA (mocked)
                  Text("ETA: comin soon"),
                  // Arrival time (mocked)
                  Text("Arrival Time: coming soon"),
                  // Item list
                  if (widget.rideRequest.items.isNotEmpty ||
                      widget.rideRequest.customItems.isNotEmpty) ...[
                    SizedBox(height: 8),
                    Text('Item List:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    ...widget.rideRequest.items.map((item) => Text(item.name)),
                    ...widget.rideRequest.customItems
                        .map((item) => Text(item.name)),
                  ],
                  // --- Added points end ---
                  Text(
                      "Pickup Location: ${widget.rideRequest.pickupLocation.name}"),
                  Text(
                      "Pickup Address: ${widget.rideRequest.pickupLocation.address}"),
                  const SizedBox(height: 8),
                  Text(
                      "Dropoff Location: ${widget.rideRequest.dropoffLocation.name}"),
                  Text(
                      "Dropoff Address: ${widget.rideRequest.dropoffLocation.address}"),
                  const SizedBox(height: 8),
                  //Get Directions button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Get Directions:"),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          UtilityFunctions.openMap(
                            originPlace: widget.originPlace,
                            destinationPlace: widget.destinationPlace,
                            waypointsPlaces: widget.waypointsPlaces,
                          );
                        },
                        child: const Icon(Icons.directions,
                            color: Colors.blue, size: 30),
                      ),
                    ],
                  ),

                  Text("Distance: ${widget.rideRequest.distance} km"),
                  Text("Fare: ${widget.rideRequest.fare.total}"),
                  Text("Status: ${widget.rideRequest.status}"),

                  // Row for buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            //show dialog
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Complete Ride Request"),
                                content: const Text(
                                    "Are you sure you want to complete the ride request?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("No"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      BlocProvider.of<RideRequestBloc>(context)
                                          .add(CompleteRideRequestEvent(
                                              rideId: widget.rideRequest.id));
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Yes"),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          child: const Text("Complete Ride",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            //show dialog
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Cancel Ride Request"),
                                content: const Text(
                                    "Are you sure you want to cancel the ride request?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("No"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      BlocProvider.of<RideRequestBloc>(context)
                                          .add(CancelRideRequestEvent(
                                              rideId: widget.rideRequest.id));
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Yes"),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          child: const Text("Cancel Ride",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}


//Cancel ride request confirmation dialog

