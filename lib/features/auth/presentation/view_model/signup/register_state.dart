import 'package:equatable/equatable.dart';

class RegisterState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final String? imageName;
  final String? error;

  const RegisterState({
    required this.isLoading,
    required this.isSuccess,
    this.imageName,
    this.error,
  });

  factory RegisterState.initial() {
    return const RegisterState(
      isLoading: false,
      isSuccess: false,
      imageName: null,
      error: null,
    );
  }

  RegisterState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? imageName,
    String? error,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      imageName: imageName ?? this.imageName,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [isLoading, isSuccess, imageName, error];
}
