import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:sajilobihe_event_venue_booking_system/app/shared_prefs/token_shared_prefs.dart';
import 'package:sajilobihe_event_venue_booking_system/core/network/api_service.dart';
import 'package:sajilobihe_event_venue_booking_system/core/network/hive_service.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/data/data_source/local_datasource/local_datasource.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/data/repositories/user_local_repository.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/data/repositories/user_remote_repository.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/use_case/create_user_usecase.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/use_case/login_usecase.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/use_case/upload_image_usecase.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/features/home/presentation/view_model/home_cubit.dart';
import 'package:sajilobihe_event_venue_booking_system/features/onBoarding/presentation/view_model/onboarding_cubit.dart';
import 'package:sajilobihe_event_venue_booking_system/features/splash/presentation/view_model/splash_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  await _initHiveService();
  await _initApiService();
  await _initSharedPreferences();

  await _initHomeDependencies();
  await _initRegisterDependencies();
  await _initLoginDependencies();

  await _initOnBoardingScreenDependencies();
  await _initSplashScreenDependencies();
}

Future<void> _initSharedPreferences() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
}

_initHiveService() async {
  getIt.registerLazySingleton<HiveService>(() => HiveService());
}

_initApiService() {
  // Remote Data Source
  getIt.registerLazySingleton<Dio>(
    () => ApiService(Dio()).dio,
  );
}

_initRegisterDependencies() async {
  // Local Data Source
  getIt
      .registerFactory<UserLocalDataSource>(() => UserLocalDataSource(getIt()));

  // Remote Data Source
  getIt.registerFactory<UserRemoteDataSource>(
      () => UserRemoteDataSource(getIt<Dio>()));

  // Local Repository
  getIt.registerLazySingleton<UserLocalRepository>(() =>
      UserLocalRepository(userLocalDataSource: getIt<UserLocalDataSource>()));

  // Remote Repository
  getIt.registerLazySingleton<UserRemoteRepository>(
      () => UserRemoteRepository(getIt<UserRemoteDataSource>()));

  // Usecases
  getIt.registerLazySingleton<CreateUserUsecase>(
    () => CreateUserUsecase(userRepository: getIt<UserRemoteRepository>()),
  );

  getIt.registerLazySingleton<UploadImageUsecase>(
    () => UploadImageUsecase(
      getIt<UserRemoteRepository>(),
    ),
  );

  getIt.registerFactory<RegisterBloc>(
    () => RegisterBloc(
      createUserUsecase: getIt<CreateUserUsecase>(),
      uploadImageUsecase: getIt<UploadImageUsecase>(),
    ),
  );
}

_initOnBoardingScreenDependencies() async {
  getIt.registerFactory(
    () => OnboardingCubit(getIt<LoginBloc>()),
  );
}

_initHomeDependencies() async {
  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(),
  );
}

_initLoginDependencies() async {
  // =========================== Token Shared Preferences ===========================
  getIt.registerLazySingleton<TokenSharedPrefs>(
    () => TokenSharedPrefs(getIt<SharedPreferences>()),
  );

  getIt.registerLazySingleton<LoginUsecase>(
    () => LoginUsecase(
      getIt<UserRemoteRepository>(),
      getIt<TokenSharedPrefs>(),
    ),
  );

  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(
      registerBloc: getIt<RegisterBloc>(),
      homeCubit: getIt<HomeCubit>(),
      loginUsecase: getIt<LoginUsecase>(),
    ),
  );
}

_initSplashScreenDependencies() async {
  getIt.registerFactory(
    () => SplashCubit(getIt<OnboardingCubit>()),
  );
}
