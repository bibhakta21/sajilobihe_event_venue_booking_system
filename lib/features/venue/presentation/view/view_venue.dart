import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/app/constants/api_endpoints.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/domain/entity/venue.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/presentation/view/update_venue.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/presentation/view_model/admin/venue_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/presentation/view_model/admin/venue_event.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/presentation/view_model/admin/venue_state.dart';


class AllVenuesPage extends StatelessWidget {
  const AllVenuesPage({Key? key}) : super(key: key);

  void _confirmDelete(BuildContext context, String venueId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text("Confirm Deletion", style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text("Are you sure you want to delete this venue?"),
          actions: [
            TextButton(
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
              onPressed: () => Navigator.pop(dialogContext),
            ),
            TextButton(
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<VenueBloc>().add(DeleteVenueEvent(venueId));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("All Venues"),
        backgroundColor: Colors.white,
      ),
      body: BlocBuilder<VenueBloc, VenueState>(
        builder: (context, state) {
          if (state is VenueLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is VenueLoaded) {
            final venues = state.venues;
            if (venues.isEmpty) {
              return const Center(
                child: Text("No venues added yet.", style: TextStyle(fontSize: 16)),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: venues.length,
              itemBuilder: (context, index) {
                final Venue venue = venues[index];

                // Build the image URL using the static base URL.
                String imageUrl = "";
                if (venue.images.isNotEmpty) {
                  imageUrl = venue.images.first;
                  // Remove "file://" prefix if present.
                  if (imageUrl.startsWith("file://")) {
                    imageUrl = imageUrl.replaceFirst("file://", "");
                  }
                  // If it doesn't start with "http", assume it's a relative URL.
                  if (!imageUrl.startsWith("http")) {
                    if (!imageUrl.startsWith("/")) {
                      imageUrl = "/" + imageUrl;
                    }
                    imageUrl = ApiEndpoints.staticBaseUrl + imageUrl;
                  }
                  // Encode the URL to handle spaces and special characters.
                  imageUrl = Uri.encodeFull(imageUrl);
                }

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 6,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Venue Image
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: venue.images.isNotEmpty
                            ? Image.network(
                                imageUrl,
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 180,
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: Icon(Icons.broken_image, size: 60, color: Colors.grey),
                                    ),
                                  );
                                },
                              )
                            : Container(
                                height: 180,
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Icon(Icons.image, size: 60, color: Colors.grey),
                                ),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              venue.name,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(Icons.location_on, color: Colors.redAccent, size: 18),
                                const SizedBox(width: 5),
                                Text(venue.location, style: const TextStyle(fontSize: 14)),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Capacity: ${venue.capacity} People",
                              style: const TextStyle(fontSize: 14, color: Colors.black54),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "\$${venue.price}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              venue.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14, color: Colors.black54),
                            ),
                            const SizedBox(height: 15),
                            // Action Buttons: Edit and Delete
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton.icon(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  label: const Text("Edit", style: TextStyle(color: Colors.blue)),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => UpdateVenuePage(venue: venue),
                                      ),
                                    );
                                  },
                                ),
                                TextButton.icon(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  label: const Text("Delete", style: TextStyle(color: Colors.red)),
                                  onPressed: () => _confirmDelete(context, venue.id),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is VenueError) {
            return Center(
              child: Text("Error: ${state.error}", style: const TextStyle(color: Colors.red)),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
