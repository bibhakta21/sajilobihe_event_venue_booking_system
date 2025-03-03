import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/app/di/di.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/domain/entity/venue.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/presentation/view/login_view.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/presentation/view/product_view.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/presentation/view_model/admin/venue_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/presentation/view_model/admin/venue_event.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/presentation/view_model/admin/venue_state.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StreamSubscription<AccelerometerEvent> _accelerometerSubscription;
  final double _shakeThreshold = 15.0; // Adjust threshold as needed
  DateTime _lastShakeTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    // ignore: deprecated_member_use
    _accelerometerSubscription = accelerometerEvents.listen((event) {
      // Calculate the total acceleration
      final double acceleration =
          sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      if (acceleration > _shakeThreshold) {
        final now = DateTime.now();
        // Prevent multiple triggers (2 second cooldown)
        if (now.difference(_lastShakeTime) > const Duration(seconds: 2)) {
          _lastShakeTime = now;
          _confirmLogout();
        }
      }
    });
  }

  Future<void> _confirmLogout() async {
    // Ensure context is valid (using mounted)
    if (!mounted) return;
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Do you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text("Yes", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      final sharedPrefs = getIt<SharedPreferences>();
      await sharedPrefs.remove('token');
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (_) => LoginView()),
      );
    }
  }

  @override
  void dispose() {
    _accelerometerSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        elevation: 0,
        title: const Text(
          'SajiloBihe',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          // Logout icon button
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => _confirmLogout(),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            _buildOfferBanner(context),
            _buildSectionTitle('Popular Venues', context),
            _buildPopularVenues(),
            _buildSectionTitle('Explore Venues', context),
            _buildExploreVenueCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            hintText: 'Search Venue',
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  // Offer Banner with "Continue >" button navigating to BookmarkView
  Widget _buildOfferBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Up to 10% OFF',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                const Text(
                  'on first Venue Booking',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => BookmarkView()),
                    );
                  },
                  child: const Text('Continue >'),
                ),
              ],
            ),
            Image.asset(
              'assets/images/bride2.png',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }

  // Section Title with "See All >" button
  Widget _buildSectionTitle(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => BookmarkView()),
              );
            },
            child: const Text(
              'See All >',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  // Popular Venues (Horizontal List) using VenueBloc
  Widget _buildPopularVenues() {
    return BlocProvider<VenueBloc>(
      create: (_) => getIt<VenueBloc>()..add(LoadVenues()),
      child: SizedBox(
        height: 180,
        child: BlocBuilder<VenueBloc, VenueState>(
          builder: (context, state) {
            if (state is VenueLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is VenueLoaded) {
              final venues = state.venues;
              if (venues.isEmpty) {
                return const Center(child: Text("No popular venues found."));
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: venues.length,
                itemBuilder: (context, index) {
                  final venue = venues[index];
                  return GestureDetector(
                    onTap: () {
                      // Optionally navigate to a detail page
                      // Navigator.push(context, MaterialPageRoute(builder: (_) => VenueDetailPage(venue: venue)));
                    },
                    child: _VenueCard(venue: venue),
                  );
                },
              );
            } else if (state is VenueError) {
              return Center(child: Text("Error: ${state.error}"));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  // Explore Venue Card (Static Example)
  Widget _buildExploreVenueCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        height: 150,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            )
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Image.asset(
              'assets/images/explore.png',
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Golden Venue',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Seat Capacity: 400 people\nVenue Type: Party Palace',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {},
                    child: const Text('Book Now'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// _VenueCard now expects a 'Venue' from 'venue.dart'
class _VenueCard extends StatelessWidget {
  final Venue venue;
  const _VenueCard({required this.venue, super.key});

  @override
  Widget build(BuildContext context) {
    const String baseUrl = "http://10.0.2.2:3000";
    // If there's at least one image, check if it's a network URL
    String imageUrl = venue.images.isNotEmpty
        ? (venue.images.first.startsWith("http")
            ? venue.images.first
            : "$baseUrl${venue.images.first}")
        : "assets/images/no_image.png";

    return Card(
      margin: const EdgeInsets.only(left: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: imageUrl.contains("assets")
                  ? Image.asset(
                      imageUrl,
                      width: 150,
                      height: 80,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      imageUrl,
                      width: 150,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/images/no_image.png",
                          width: 150,
                          height: 80,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
            ),
            // Venue name
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                venue.name,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Capacity & Price
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "Capacity: ${venue.capacity}\nPrice: \$${venue.price.toStringAsFixed(2)} / Plate",
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
