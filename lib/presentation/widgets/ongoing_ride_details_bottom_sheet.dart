import 'package:flutter/material.dart';
import 'package:ambition_delivery/domain/entities/ride_request.dart';
import 'package:ambition_delivery/domain/entities/item_with_qty.dart';
import 'package:ambition_delivery/domain/entities/custom_item.dart';

class OngoingRideDetailsBottomSheet extends StatelessWidget {
  final RideRequest ride;
  final bool atPickupLocation;

  const OngoingRideDetailsBottomSheet({
    required this.ride,
    required this.atPickupLocation,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Since RideRequest does not have a driver object, we use driverId or carDriverId for display
    final String driverName = ride.driverId ?? ride.carDriverId ?? 'N/A';
    final String jobRef = ride.id;
    // If you have a way to get driver photo from driverId, add that logic here
    final String? driverPhoto = null; // Placeholder, update if you have driver photo
    final List<ItemWithQty> items = ride.items;
    final List<CustomItem> customItems = ride.customItems;

    // Mocked values for rating, ETA, and arrival time
    final driverRating = 4.8;
    final eta = "5 min";
    final arrivalTime = "17:45";

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!atPickupLocation) ...[
            Text("Driver: $driverName", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text("Rating: $driverRating"),
            Text("Job Ref: $jobRef"),
            Text("ETA: $eta"),
          ],
          if (atPickupLocation) ...[
            Row(
              children: [
                if (driverPhoto != null && driverPhoto.isNotEmpty)
                  CircleAvatar(
                    backgroundImage: NetworkImage(driverPhoto),
                    radius: 24,
                  )
                else
                  CircleAvatar(
                    child: Icon(Icons.person),
                    radius: 24,
                  ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Driver: $driverName", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text("Rating: $driverRating"),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Text("Arrival Time: $arrivalTime"),
            Text("ETA: $eta"),
            if (items.isNotEmpty || customItems.isNotEmpty) ...[
              SizedBox(height: 8),
              Text('Item List:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...items.map((item) => Text(item.name)),
              ...customItems.map((item) => Text(item.name)),
            ],
          ],
        ],
      ),
    );
  }
} 