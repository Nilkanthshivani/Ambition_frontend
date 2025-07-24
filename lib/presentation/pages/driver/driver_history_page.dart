import 'package:ambition_delivery/domain/entities/custom_item.dart';
import 'package:ambition_delivery/domain/entities/item_with_qty.dart';
import 'package:ambition_delivery/domain/entities/location_entity.dart';
import 'package:ambition_delivery/domain/entities/ride_request.dart';
import 'package:ambition_delivery/presentation/bloc/auth_bloc.dart';
import 'package:ambition_delivery/presentation/bloc/ride_request_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DriverHistoryPage extends StatefulWidget {
  const DriverHistoryPage({super.key});

  @override
  State<DriverHistoryPage> createState() => _DriverHistoryPageState();
}

class _DriverHistoryPageState extends State<DriverHistoryPage> {
  late final RideRequestBloc _rideRequestBloc;
  late final AuthBloc _authBloc;
  @override
  void initState() {
    super.initState();
    // Fetch closed ride requests when the page is initialized

    _rideRequestBloc = context.read<RideRequestBloc>();
    _authBloc = context.read<AuthBloc>();
    _rideRequestBloc.add(GetClosedRideRequestsByDriverIdEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<RideRequestBloc, RideRequestState>(
        listener: (context, state) {
          if (state is DriverDisabledError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Driver is disabled"),
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
                content: Text("Driver not found"),
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
        builder: (context, state) {
          if (state is RideRequestError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is ClosedRideRequestsLoaded) {
            final rideRequests = state.rideRequests; // Assuming this is a list

            if (rideRequests.isEmpty) {
              return const Center(
                  child: Text('No closed ride requests found.'));
            }

            return ListView.builder(
              itemCount: rideRequests.length,
              itemBuilder: (context, index) {
                final rideRequest = rideRequests[index];
                if (rideRequest == null) {
                  return const SizedBox.shrink();
                }
                return RideRequestCard(rideRequest: rideRequest);
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class RideRequestCard extends StatelessWidget {
  final RideRequest rideRequest;

  const RideRequestCard({super.key, required this.rideRequest});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[200],
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ExpansionTile(
        title: Text('Ride ${rideRequest.id}',
            style: Theme.of(context).textTheme.titleLarge),
        subtitle: Text(rideRequest.status,
            style: TextStyle(color: _getStatusColor(rideRequest.status))),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(context, 'Ride Details'),
                _buildDetailRow(
                    'Type', '${rideRequest.jobType} (${rideRequest.moveType})'),
                _buildDetailRow(
                    'Passengers', rideRequest.passengersCount.toString()),
                _buildDetailRow('Distance',
                    '${rideRequest.distance.toStringAsFixed(2)} km'),
                const SizedBox(height: 16),
                _buildSectionTitle(context, 'Locations'),
                _buildLocationInfo('Pickup', rideRequest.pickupLocation),
                const SizedBox(height: 8),
                _buildLocationInfo('Dropoff', rideRequest.dropoffLocation),
                const SizedBox(height: 16),
                _buildSectionTitle(context, 'Fare'),
                _buildDetailRow('Total Fare',
                    '\$${rideRequest.fare.total.toStringAsFixed(2)}',
                    isBold: true),
                const SizedBox(height: 16),
                if (rideRequest.items.isNotEmpty ||
                    rideRequest.customItems.isNotEmpty) ...[
                  _buildSectionTitle(context, 'Items'),
                  ...rideRequest.items.map((item) => _buildItemInfo(item)),
                  ...rideRequest.customItems
                      .map((item) => _buildCustomItemInfo(item)),
                  const SizedBox(height: 16),
                ],
                _buildSectionTitle(context, 'Other Requirements'),
                _buildDetailRow('Pickup Floor',
                    rideRequest.requirements.pickupFloor.toString()),
                _buildDetailRow('Dropoff Floor',
                    rideRequest.requirements.dropoffFloor.toString()),
                _buildDetailRow('Required Helpers',
                    rideRequest.requirements.requiredHelpers.toString()),
                _buildDetailRow('People Tagging Along',
                    rideRequest.requirements.peopleTaggingAlong.toString()),
                if (rideRequest.requirements.specialRequirements.isNotEmpty)
                  _buildDetailRow('Special Requirements',
                      rideRequest.requirements.specialRequirements),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title,
          style:
              Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value,
              style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildLocationInfo(String type, LocationEntity location) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$type: ${location.name ?? ''}',
            style: const TextStyle(fontWeight: FontWeight.w500)),
        Text(location.address ?? '', style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildItemInfo(ItemWithQty item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(item.name)),
          Text('${item.qty}x'),
          Text(
              '${item.length}x${item.width}x${item.height} cm, ${item.weight} kg, ${item.qty}x'),
        ],
      ),
    );
  }

  Widget _buildCustomItemInfo(CustomItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(item.name)),
          Text(
              '${item.length}x${item.width}x${item.height} cm, ${item.weight} kg, ${item.quantity}x'),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}
