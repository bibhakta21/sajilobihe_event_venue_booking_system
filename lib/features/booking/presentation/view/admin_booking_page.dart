import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/app/di/di.dart';
import 'package:sajilobihe_event_venue_booking_system/features/booking/presentation/view_model/booking_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/features/booking/presentation/view_model/booking_event.dart';
import 'package:sajilobihe_event_venue_booking_system/features/booking/presentation/view_model/booking_state.dart';

class AdminBookingPage extends StatelessWidget {
  const AdminBookingPage({super.key});

  void _confirmDelete(BuildContext context, String bookingId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text("Confirm Deletion",
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("Are you sure you want to delete this booking?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<BookingBloc>().add(DeleteBookingEvent(bookingId));
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookingBloc>(
      create: (_) => getIt<BookingBloc>()..add(LoadAllBookingsEvent()),
      child: Scaffold(
        backgroundColor: Colors.grey[100], // Light background
        appBar: AppBar(
          title: const Text("Bookings Management"),
          backgroundColor: Colors.white,
        ),
        body: BlocBuilder<BookingBloc, BookingState>(
          builder: (context, state) {
            if (state is BookingLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AllBookingsLoaded) {
              if (state.bookings.isEmpty) {
                return const Center(
                    child: Text("No bookings found.",
                        style: TextStyle(fontSize: 16)));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.bookings.length,
                itemBuilder: (context, index) {
                  final booking = state.bookings[index];
                  String? firstImage = booking.venueImages != null &&
                          booking.venueImages!.isNotEmpty
                      ? booking.venueImages!.first
                      : null;
                  String imageUrl =
                      (firstImage != null && !firstImage.startsWith("http"))
                          ? "http://10.0.2.2:3000$firstImage"
                          : (firstImage ?? "");

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: imageUrl.isNotEmpty
                                ? Image.network(imageUrl,
                                    width: 80, height: 80, fit: BoxFit.cover)
                                : Container(
                                    width: 80,
                                    height: 80,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.image,
                                        color: Colors.white, size: 40),
                                  ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  booking.userName?.isNotEmpty == true
                                      ? booking.userName!
                                      : booking.userId,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Icon(Icons.email,
                                        color: Colors.redAccent, size: 18),
                                    const SizedBox(width: 5),
                                    Text(booking.userEmail ?? 'N/A'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.phone,
                                        color: Colors.green, size: 18),
                                    const SizedBox(width: 5),
                                    Text(booking.userPhone ?? 'N/A'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on,
                                        color: Colors.blueAccent, size: 18),
                                    const SizedBox(width: 5),
                                    Text(booking.venueName ?? booking.venueId),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today,
                                        color: Colors.orange, size: 18),
                                    const SizedBox(width: 5),
                                    Text(
                                        "Date: ${booking.bookingDate.toLocal().toString().split(' ')[0]}"),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(booking.status),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    booking.status.toUpperCase(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              if (booking.status == "pending")
                                IconButton(
                                  icon: const Icon(Icons.check,
                                      color: Colors.green),
                                  onPressed: () {
                                    context
                                        .read<BookingBloc>()
                                        .add(ApproveBookingEvent(booking.id));
                                  },
                                ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () =>
                                    _confirmDelete(context, booking.id),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is BookingOperationFailure) {
              return Center(
                child: Text("Error: ${state.error}",
                    style: const TextStyle(color: Colors.red)),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "approved":
        return Colors.green;
      case "pending":
        return Colors.orange;
      case "rejected":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
