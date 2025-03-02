import 'package:flutter/material.dart';
import '../../auth/domain/entity/venue_entity.dart';

class VenueDetailPage extends StatelessWidget {
  final VenueEntity venue;

  const VenueDetailPage({required this.venue, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String baseUrl = "http://10.0.2.2:3000"; 

    String imageUrl = venue.images.isNotEmpty
        ? venue.images.first.startsWith("http")
            ? venue.images.first
            : "$baseUrl${venue.images.first}"
        : "assets/images/no_image.png";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text(venue.name, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: imageUrl.contains("assets")
                    ? Image.asset(imageUrl, height: 250, width: double.infinity, fit: BoxFit.cover)
                    : Image.network(imageUrl, height: 250, width: double.infinity, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) {
                        return Image.asset("assets/images/no_image.png", height: 250, width: double.infinity, fit: BoxFit.cover);
                      }),
              ),
              const SizedBox(height: 20),
              Text(venue.name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.redAccent),
                  const SizedBox(width: 5),
                  Text(venue.location, style: const TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Capacity: ${venue.capacity}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  Text("Price: \$${venue.price.toStringAsFixed(2)} / Plate", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.redAccent)),
                ],
              ),
              const SizedBox(height: 10),
              const Text("Description:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(venue.description, style: const TextStyle(fontSize: 16, color: Colors.black87)),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                  onPressed: () {},
                  child: const Text("Book Appointment", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
