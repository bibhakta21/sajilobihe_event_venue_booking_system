import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/data/data_source/remote_datasource/venue_remote_datasource.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/domain/entity/venue_entity.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/domain/repository/venue_repository.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/presentation/view_model/user/venue_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/presentation/view_model/user/venue_event.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/presentation/view_model/user/venue_state.dart';



import '../../domain/use_case/get_all_venues_usecase.dart';
import 'venue_detail_page.dart';

class BookmarkView extends StatefulWidget {
  const BookmarkView({super.key});

  @override
  State<BookmarkView> createState() => _BookmarkViewState();
}

class _BookmarkViewState extends State<BookmarkView> {
  late VenueBloc venueBloc;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    venueBloc = VenueBloc(
      GetVenuesUseCase(VenueRepositoryImpl(VenueRemoteDataSource(Dio()))),
    )..add(LoadVenuesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => venueBloc,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5), // Light grey background
        appBar: AppBar(
          title: const Text(
            'Venues',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.redAccent,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            _buildSearchBar(),
            Expanded(
              child: BlocBuilder<VenueBloc, VenueState>(
                builder: (context, state) {
                  if (state is VenueLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is VenueLoadedState) {
                    final filteredVenues = state.venues
                        .where((venue) => venue.name
                            .toLowerCase()
                            .contains(searchQuery.toLowerCase()))
                        .toList();
                    return filteredVenues.isNotEmpty
                        ? ListView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            itemCount: filteredVenues.length,
                            itemBuilder: (context, index) {
                              final venue = filteredVenues[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          VenueDetailPage(venue: venue),
                                    ),
                                  );
                                },
                                child: VenueCard(venue: venue),
                              );
                            },
                          )
                        : const Center(
                            child: Text(
                              "No venues found",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          );
                  } else if (state is VenueErrorState) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(
                            color: Colors.redAccent, fontSize: 16),
                      ),
                    );
                  }
                  return const Center(child: Text("No data available."));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: TextField(
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          hintText: "Search by venue name...",
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      searchQuery = '';
                    });
                  },
                )
              : null,
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
    const String baseUrl = "http://192.168.101.12:3000";

    String imageUrl = venue.images.isNotEmpty
        ? venue.images.first.startsWith("http")
            ? venue.images.first
            : "$baseUrl${venue.images.first}"
        : "assets/images/no_image.png";

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 10),
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
            Text(
              venue.name,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "📍 ${venue.location}",
                  style: const TextStyle(color: Colors.grey),
                ),
             
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Capacity: ${venue.capacity}",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  "Rs ${venue.price.toStringAsFixed(2)} / Plate",
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.redAccent),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              venue.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
