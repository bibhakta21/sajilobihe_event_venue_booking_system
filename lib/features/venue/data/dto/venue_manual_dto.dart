class VenueDTO {
  final String id;
  final String name;
  final String location;
  final int capacity;
  final double price;
  final String description;
  final List<String> images;
  final bool available;

  VenueDTO({
    required this.id,
    required this.name,
    required this.location,
    required this.capacity,
    required this.price,
    required this.description,
    required this.images,
    required this.available,
  });

  /// Factory constructor to create `VenueDTO` from JSON
  factory VenueDTO.fromJson(Map<String, dynamic> json) {
    return VenueDTO(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      capacity: json['capacity'] as int,
      price: (json['price'] as num).toDouble(), // Ensures type safety
      description: json['description'] as String,
      images: (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      available: json['available'] as bool,
    );
  }

  /// Converts `VenueDTO` to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'capacity': capacity,
      'price': price,
      'description': description,
      'images': images,
      'available': available,
    };
  }
}
