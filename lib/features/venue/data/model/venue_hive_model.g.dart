part of 'venue_hive_model.dart';

VenueHiveModel _$VenueHiveModelFromHive(Map<dynamic, dynamic> hiveData) {
  return VenueHiveModel(
    id: hiveData['id'] as String,
    name: hiveData['name'] as String,
    location: hiveData['location'] as String,
    capacity: hiveData['capacity'] as int,
    price: hiveData['price'] as double,
    description: hiveData['description'] as String,
    images: (hiveData['images'] as List).map((item) => item as String).toList(),
    available: hiveData['available'] as bool,
  );
}

Map<String, dynamic> _$VenueHiveModelToHive(VenueHiveModel model) {
  return {
    'id': model.id,
    'name': model.name,
    'location': model.location,
    'capacity': model.capacity,
    'price': model.price,
    'description': model.description,
    'images': model.images,
    'available': model.available,
  };
}
