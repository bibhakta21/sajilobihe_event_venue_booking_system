import 'package:sajilobihe_event_venue_booking_system/core/network/hive_service.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/features/splash/presentation/view_model/splash_cubit.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  await _initHiveService();
  await _initSplashDependencies();
  await _initSignupDependencies();
  await _initLoginDependencies();
}

_initHiveService() {
  getIt.registerLazySingleton<HiveService>(() => HiveService());
}

_initSignupDependencies() async {
  getIt.registerFactory<RegisterBloc>(() => RegisterBloc());
}

_initLoginDependencies() async {
  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(registerBloc: getIt<RegisterBloc>()),
  );
}

_initSplashDependencies() async {
  getIt.registerFactory<SplashCubit>(
        () => SplashCubit(),
  );
}