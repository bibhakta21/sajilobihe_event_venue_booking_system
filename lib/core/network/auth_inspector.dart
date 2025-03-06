import 'package:dio/dio.dart';
import 'package:sajilobihe_event_venue_booking_system/app/shared_prefs/token_shared_prefs.dart';

class AuthInterceptor extends Interceptor {
  final TokenSharedPrefs tokenSharedPrefs;

  AuthInterceptor(this.tokenSharedPrefs);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Retrieve the token from shared preferences
    final tokenEither = await tokenSharedPrefs.getToken();
    tokenEither.fold(
      (failure) {
        // Optionally handle failure if needed
      },
      (token) {
        if (token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
      },
    );
    return super.onRequest(options, handler);
  }
}
