import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/presentation/view_model/user/venue_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/presentation/view_model/user/venue_event.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/presentation/view_model/user/venue_state.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/data/data_source/remote_datasource/venue_remote_datasource.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/domain/repository/venue_repository.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/domain/use_case/get_all_venues_usecase.dart';

import 'venue_detail_page.dart';
import '../../domain/entity/venue_entity.dart';

class BookmarkView extends StatelessWidget {
  const BookmarkView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VenueBloc(
          GetVenuesUseCase(VenueRepositoryImpl(VenueRemoteDataSource(Dio()))))
        ..add(LoadVenuesEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Venues'),
          backgroundColor: Colors.redAccent,
          centerTitle: true,
        ),
        body: BlocBuilder<VenueBloc, VenueState>(
          builder: (context, state) {
            if (state is VenueLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is VenueLoadedState) {
              return ListView.builder(
                itemCount: state.venues.length,
                itemBuilder: (context, index) {
                  final venue = state.venues[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigate to VenueDetailPage on tap
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VenueDetailPage(venue: venue),
                        ),
                      );
                    },
                    child: VenueCard(venue: venue),
                  );
                },
              );
            } else if (state is VenueErrorState) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                ),
              );
            }
            return const Center(child: Text("No data available."));
          },
        ),
      ),
    );
  }
}

class VenueCard extends StatelessWidget {
  final VenueEntity venue;

  const VenueCard({required this.venue, super.key});

  @override
  Widget build(BuildContext context) {
    const String baseUrl = "http://10.0.2.2:3000";

    // Ensure the image URL is valid
    String imageUrl = venue.images.isNotEmpty
        ? venue.images.first.startsWith("http")
            ? venue.images.first
            : "$baseUrl${venue.images.first}"
        : "assets/images/no_image.png";

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      shadowColor: Colors.grey.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: imageUrl.contains("assets")
                  ? Image.asset(imageUrl,
                      height: 180, width: double.infinity, fit: BoxFit.cover)
                  : Image.network(imageUrl,
                      height: 180, width: double.infinity, fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                      return Image.asset("assets/images/no_image.png",
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover);
                    }),
            ),
            const SizedBox(height: 10),
            Text(venue.name,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(venue.location, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Capacity: ${venue.capacity}",
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                Text("Price: \$${venue.price.toStringAsFixed(2)} / Plate",
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.redAccent)),
              ],
            ),
            const SizedBox(height: 10),
            Text(venue.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
