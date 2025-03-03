class Venue {
  final String id;
  final String name;
  final String location;
  final int capacity;
  final double price;
  final String description;
  final List<String> images;
  final bool available;

  Venue({
    required this.id,
    required this.name,
    required this.location,
    required this.capacity,
    required this.price,
    required this.description,
    required this.images,
    required this.available,
  });
}
