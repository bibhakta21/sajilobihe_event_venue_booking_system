import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/app/di/di.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/presentation/view/login_view.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/domain/entity/venue.dart';
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
  final double _shakeThreshold = 15.0;
  DateTime _lastShakeTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _accelerometerSubscription = accelerometerEvents.listen((event) {
      final double acceleration =
          sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      if (acceleration > _shakeThreshold) {
        final now = DateTime.now();
        if (now.difference(_lastShakeTime) > const Duration(seconds: 2)) {
          _lastShakeTime = now;
          _confirmLogout();
        }
      }
    });
  }

  Future<void> _confirmLogout() async {
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
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        title: const Text(
          'SajiloBihe',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => _confirmLogout(),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            _buildOfferBanner(context),
            _buildSectionTitle('Popular Venues', context),
            _buildPopularVenues(),
            const SizedBox(height: 15),
            _buildWhyChooseUs(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
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
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildOfferBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
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
    );
  }

  Widget _buildWhyChooseUs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "WHY CHOOSE US",
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        _buildFeatureCard(
            Icons.apartment_rounded,
            "Wide Range of Venues",
            "Explore a variety of event venues to fit your unique requirements.",
            Colors.blue),
        _buildFeatureCard(
            Icons.shopping_cart_checkout_rounded,
            "Easy Online Booking",
            "Book your event venue in just a few clicks.",
            Colors.green),
        _buildFeatureCard(Icons.location_on_rounded, "Prime Locations",
            "Choose venues located in the heart of the city.", Colors.orange),
      ],
    );
  }

  Widget _buildFeatureCard(
      IconData icon, String title, String description, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
      ),
    );
  }

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

  Widget _buildPopularVenues() {
    return BlocProvider<VenueBloc>(
      create: (_) => getIt<VenueBloc>()..add(LoadVenues()),
      child: Padding(
        padding: const EdgeInsets.only(top: 1, bottom: 1),
        child: BlocBuilder<VenueBloc, VenueState>(
          builder: (context, state) {
            if (state is VenueLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is VenueLoaded) {
              final venues = state.venues;
              if (venues.isEmpty) {
                return const Center(child: Text("No popular venues found."));
              }
              return SizedBox(
                height: 255, // Adjusted height to avoid overflow issues
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: venues.length,
                  shrinkWrap: true, // Ensures correct rendering inside a Column
                  itemBuilder: (context, index) {
                    final venue = venues[index];
                    return GestureDetector(
                      onTap: () {
                        // Navigate to Venue Detail Page (optional)
                      },
                      child: _VenueCard(venue: venue),
                    );
                  },
                ),
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
}

class _VenueCard extends StatelessWidget {
  final Venue venue;
  const _VenueCard({required this.venue, super.key});

  @override
  Widget build(BuildContext context) {
    const String baseUrl = "http://192.168.101.12:3000";

    String imageUrl = venue.images.isNotEmpty
        ? (venue.images.first.startsWith("http")
            ? venue.images.first
            : "$baseUrl${venue.images.first}")
        : "assets/images/no_image.png";

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 8, bottom: 16),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 6,
        shadowColor: Colors.black.withOpacity(0.1),
        child: Container(
          width: 180, // Ensures a proper width
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Allows Column to shrink if needed
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Venue Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: imageUrl.contains("assets")
                    ? Image.asset(
                        imageUrl,
                        width: double.infinity,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        imageUrl,
                        width: double.infinity,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            "assets/images/no_image.png",
                            width: double.infinity,
                            height: 100,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
              ),
              const SizedBox(height: 10),

              // Venue Name
              Flexible(
                child: Text(
                  venue.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(height: 6),

              // Venue Capacity & Price
              Flexible(
                child: Text(
                  "Capacity: ${venue.capacity}",
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ),
              Flexible(
                child: Text(
                  "Price: Rs${venue.price.toStringAsFixed(2)} / Plate",
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ),
              Flexible(
                child: Text(
                  "📍 ${venue.location}",
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
