import 'package:equatable/equatable.dart';

/// Represents a user authentication entity.
/// This class is immutable and uses `Equatable` for value comparison.
class AuthEntity extends Equatable {
  /// Unique identifier for the user.
  final String? userId;

  /// Email address of the user.
  final String email;

  /// First name of the user.
  final String fname;

  /// Last name of the user.
  final String lname;

  /// Password for user authentication.
  final String password;

  /// Constructs an `AuthEntity` instance with the required properties.
  ///
  /// - [userId] is optional and can be `null` for new users.
  /// - [email], [fname], [lname], and [password] are required fields.
  const AuthEntity({
    required this.email,
    this.userId,
    required this.fname,
    required this.lname,
    required this.password,
  });

  /// Defines the list of properties used for comparison.
  @override
  List<Object?> get props => [userId, fname, lname, password, email];
}
