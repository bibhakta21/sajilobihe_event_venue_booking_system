// app/constants/hive_table_constant.dart

/// A utility class that defines constants for Hive table and box configurations.
/// This class is not meant to be instantiated.
class HiveTableConstant {
  // Private constructor to prevent instantiation.
  HiveTableConstant._();

  /// Unique ID for the user table.
  static const int userTableId = 0;

  /// Name of the Hive box used for storing user authentication data.
  static const String userBox = 'userBox';
}
