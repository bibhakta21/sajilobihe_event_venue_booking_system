import 'package:sajilobihe_event_venue_booking_system/app/constants/hive_table_constant.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/data/model/auth_hive_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  /// Initialize Hive and setup database directory
  static Future<void> init() async {
    // Get the application documents directory
    var directory = await getApplicationDocumentsDirectory();
    var path = '${directory.path}sajilobihe.db';

    // Initialize Hive with the specified path
    Hive.init(path);

    // Register Hive adapters for custom data models
    Hive.registerAdapter(AuthHiveModelAdapter());
  }

  /// Register a new user and store their data in Hive
  /// [auth] - The user's authentication details to store
  Future<void> register(AuthHiveModel auth) async {
    // Open the Hive box for user data
    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    // Store the user's data using their userId as the key
    await box.put(auth.userId, auth);
  }

  /// Delete a user from Hive by their ID
  /// [id] - The ID of the user to delete
  Future<void> deleteAuth(String id) async {
    // Open the Hive box for user data
    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    // Remove the user data with the specified ID
    await box.delete(id);
  }

  /// Retrieve all users stored in Hive
  /// Returns a list of all [AuthHiveModel] objects
  Future<List<AuthHiveModel>> getAllAuth() async {
    // Open the Hive box for user data
    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    // Return all values as a list
    return box.values.toList();
  }

  /// Authenticate a user by their email and password
  /// [email] - The user's email
  /// [password] - The user's password
  /// Returns the [AuthHiveModel] if found, otherwise null
  Future<AuthHiveModel?> login(String email, String password) async {
    // Open the Hive box for user data
    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);

    try {
      // Find the first user matching the email and password
      return box.values.firstWhere(
            (element) => element.email == email && element.password == password,
      );
    } catch (e) {
      // Return null if no matching user is found
      return null;
    }
  }

  /// Clear all user data from Hive
  Future<void> clearAll() async {
    // Delete the Hive box from disk
    await Hive.deleteBoxFromDisk(HiveTableConstant.userBox);
  }

  /// Close the Hive database connection
  Future<void> close() async {
    await Hive.close();
  }
}
