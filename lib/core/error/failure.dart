import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;
  const Failure({required this.message, this.statusCode});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'Failure(message: $message, statusCode: $statusCode)';
}

class LocalDatabaseFailure extends Failure {
  const LocalDatabaseFailure({
    required super.message,
  });
}

class ApiFailure extends Failure {
  @override
  final int statusCode;

  const ApiFailure({
    required this.statusCode,
    required super.message,
  });
}

class SharedPrefsFailure extends Failure {
  const SharedPrefsFailure({
    required super.message,
  });
}
