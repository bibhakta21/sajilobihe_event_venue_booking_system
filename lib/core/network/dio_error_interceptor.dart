import 'package:dio/dio.dart';

class DioErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response != null && err.response!.data != null) {
      // Attempt to parse the error field from the server's response
      final data = err.response!.data;

      // If the backend returns { "error": "You have already booked this venue." }
      // we set err.error to that string.
      if (data is Map && data['error'] != null) {
        err = DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          error: data['error'], // <--- Use the "error" field
          type: DioExceptionType.badResponse,
        );
      } else {
        // If the backend uses "message" or something else, adjust accordingly
        err = DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          error:
              data['message'] ?? err.response!.statusMessage ?? 'Bad Request',
          type: DioExceptionType.badResponse,
        );
      }
    } else {
      // Fallback for other error types (e.g., no internet)
      err = DioException(
        requestOptions: err.requestOptions,
        error: 'Connection error',
        type: DioExceptionType.unknown,
      );
    }
    super.onError(err, handler);
  }
}
