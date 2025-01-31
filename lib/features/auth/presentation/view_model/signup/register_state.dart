part of 'register_bloc.dart';

class RegisterState {
  final bool isLoading;
  final bool isSuccess;
  final String? imageName;
  final String? error;
  RegisterState({
    required this.isLoading,
    required this.isSuccess,
    this.imageName,
    this.error,
  });

  RegisterState.initial()
      : isLoading = false,
        isSuccess = false,
        imageName = null,
        error = null;

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
      error: error,
    );
  }
}
