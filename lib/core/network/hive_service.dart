import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sajilobihe_event_venue_booking_system/app/constants/hive_table_constant.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/data/model/user_hive_model.dart';
import 'package:sajilobihe_event_venue_booking_system/features/booking/data/model/booking_hive_model.dart';
import 'package:sajilobihe_event_venue_booking_system/features/contact_us/data/model/contact_hive_model.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/data/model/venue_hive_model.dart';

class HiveService {
  Future<void> init() async {
    // Initialize the database
    var directory = await getApplicationDocumentsDirectory();
    var path = '${directory.path}sajilobihe_event_venue_booking_system.db';

    Hive.init(path);

    // Register Adapters
    Hive.registerAdapter(UserHiveModelAdapter());
  }

  // User Queries
  Future<void> addUser(UserHiveModel user) async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    await box.put(user.userId, user);
  }

  Future<List<UserHiveModel>> getAllUsers() async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    var users = box.values.toList();
    return users;
  }

  Future<void> deleteUser(String userId) async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    await box.delete(userId);
  }

  // Login using username and password
  Future<UserHiveModel?> login(String email, String password) async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    var user = box.values.firstWhere(
        (element) => element.email == email && element.password == password);
    box.close();
    return user;
  }

   Future<void> storeVenues(List<VenueHiveModel> venues) async {
    var box = await Hive.openBox<VenueHiveModel>(HiveTableConstant.venueBox);
    for (var venue in venues) {
      await box.put(venue.id, venue);
    }
  }

  Future<List<VenueHiveModel>> getStoredVenues() async {
    var box = await Hive.openBox<VenueHiveModel>(HiveTableConstant.venueBox);
    return box.values.toList();
  }

  Future<void> clearVenues() async {
    var box = await Hive.openBox<VenueHiveModel>(HiveTableConstant.venueBox);
    await box.clear();
  }

  Future<void> addBooking(BookingHiveModel booking) async {
    var box = await Hive.openBox<BookingHiveModel>(HiveTableConstant.bookingBox);
    await box.put(booking.id, booking);
  }

  Future<List<BookingHiveModel>> getUserBookings(String userId) async {
    var box = await Hive.openBox<BookingHiveModel>(HiveTableConstant.bookingBox);
    return box.values.where((booking) => booking.userId == userId).toList();
  }

  Future<List<BookingHiveModel>> getAllBookings() async {
    var box = await Hive.openBox<BookingHiveModel>(HiveTableConstant.bookingBox);
    return box.values.toList();
  }

  Future<void> cancelBooking(String bookingId) async {
    var box = await Hive.openBox<BookingHiveModel>(HiveTableConstant.bookingBox);
    var booking = box.get(bookingId);
    if (booking != null) {
      var updatedBooking = BookingHiveModel(
        id: booking.id,
        userId: booking.userId,
        venueId: booking.venueId,
        bookingDate: booking.bookingDate,
        status: "Cancelled", // Updating status
        userName: booking.userName,
        userEmail: booking.userEmail,
        userPhone: booking.userPhone,
        venueName: booking.venueName,
        venueImages: booking.venueImages,
        venuePrice: booking.venuePrice,
        venueCapacity: booking.venueCapacity,
      );
      await box.put(bookingId, updatedBooking);
    }
  }

  Future<void> deleteBooking(String bookingId) async {
    var box = await Hive.openBox<BookingHiveModel>(HiveTableConstant.bookingBox);
    await box.delete(bookingId);
  }


   Future<void> addContact(ContactHiveModel contact) async {
    var box =
        await Hive.openBox<ContactHiveModel>(HiveTableConstant.contactBox);
    await box.put(contact.id, contact);
  }

  Future<List<ContactHiveModel>> getAllContacts() async {
    var box =
        await Hive.openBox<ContactHiveModel>(HiveTableConstant.contactBox);
    return box.values.toList();
  }

  Future<void> deleteContact(String id) async {
    var box =
        await Hive.openBox<ContactHiveModel>(HiveTableConstant.contactBox);
    await box.delete(id);
  }
}
