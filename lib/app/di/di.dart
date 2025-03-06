import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:sajilobihe_event_venue_booking_system/app/shared_prefs/token_shared_prefs.dart';
import 'package:sajilobihe_event_venue_booking_system/core/network/api_service.dart';
import 'package:sajilobihe_event_venue_booking_system/core/network/hive_service.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/data/data_source/local_datasource/local_datasource.dart';
import 'package:sajilobihe_event_venue_booking_system/features/booking/data/data_source/remote_datasource/booking_remote_datasource.dart';
import 'package:sajilobihe_event_venue_booking_system/features/contact_us/data/data_source/remote_datasource/contact_remote_datasource.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/data/data_source/remote_datasource/user_profile_service.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/data/data_source/remote_datasource/venues_remote_datasource.dart';
import 'package:sajilobihe_event_venue_booking_system/features/booking/data/repositories/booking_repository_impl.dart';
import 'package:sajilobihe_event_venue_booking_system/features/contact_us/data/repositories/contact_repository_impl.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/data/repositories/user_local_repository.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/data/repositories/user_remote_repository.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/data/repositories/venue_repository_impl.dart';
import 'package:sajilobihe_event_venue_booking_system/features/booking/domain/repository/booking_repository.dart';
import 'package:sajilobihe_event_venue_booking_system/features/contact_us/domain/repository/contact_repository.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/domain/repository/venue_repository_final.dart';
import 'package:sajilobihe_event_venue_booking_system/features/booking/domain/use_case/approve_bookings_usecase.dart';
import 'package:sajilobihe_event_venue_booking_system/features/booking/domain/use_case/cancel_bookings_usecase.dart';
import 'package:sajilobihe_event_venue_booking_system/features/booking/domain/use_case/create_booking_usecase.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/use_case/create_user_usecase.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/domain/use_case/create_venue.usecase.dart';
import 'package:sajilobihe_event_venue_booking_system/features/booking/domain/use_case/delete_bookings_usecase.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/domain/use_case/delete_venue_usecase.dart';
import 'package:sajilobihe_event_venue_booking_system/features/contact_us/domain/use_case/delete_contact_usecase.dart';
import 'package:sajilobihe_event_venue_booking_system/features/booking/domain/use_case/get_all_bookings_usecase.dart';
import 'package:sajilobihe_event_venue_booking_system/features/contact_us/domain/use_case/get_all_contact_usecase.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/domain/use_case/get_all_venue_usecase.dart';
import 'package:sajilobihe_event_venue_booking_system/features/booking/domain/use_case/get_user_bookings.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/use_case/login_usecase.dart';
import 'package:sajilobihe_event_venue_booking_system/features/contact_us/domain/use_case/submit_contact_usecase.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/domain/use_case/update_venue_usecase.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/use_case/upload_image_usecase.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/features/contact_us/presentation/view_model/user/contact_bloc_view.dart';
import 'package:sajilobihe_event_venue_booking_system/features/booking/presentation/view_model/booking_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/features/contact_us/presentation/view_model/admin/contact_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/presentation/view_model/admin/venue_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/features/onBoarding/presentation/view_model/onboarding_cubit.dart';
import 'package:sajilobihe_event_venue_booking_system/features/splash/presentation/view_model/splash_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  await _initHiveService();
  await _initApiService();
  await _initSharedPreferences();
  await _initRegisterDependencies();
  await _initLoginDependencies();
  await _initOnBoardingScreenDependencies();
  await _initSplashScreenDependencies();
  await _initContactDependencies();
  await _initBookingDependencies(); // NEW booking dependencies
  await _initVenueDependencies(); // Add venue management dependencies
}

Future<void> _initSharedPreferences() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
}

_initHiveService() async {
  getIt.registerLazySingleton<HiveService>(() => HiveService());
}

_initApiService() {
  // Register Dio instance wrapped with your ApiService
  getIt.registerLazySingleton<Dio>(
    () => ApiService(Dio()).dio,
  );

  // Register UserProfileService
  getIt.registerLazySingleton<UserProfileService>(
    () => UserProfileService(getIt<Dio>()),
  );
}

_initRegisterDependencies() async {
  getIt
      .registerFactory<UserLocalDataSource>(() => UserLocalDataSource(getIt()));

  getIt.registerFactory<UserRemoteDataSource>(
      () => UserRemoteDataSource(getIt<Dio>()));

  getIt.registerLazySingleton<UserLocalRepository>(() =>
      UserLocalRepository(userLocalDataSource: getIt<UserLocalDataSource>()));

  getIt.registerLazySingleton<UserRemoteRepository>(
      () => UserRemoteRepository(getIt<UserRemoteDataSource>()));

  getIt.registerLazySingleton<CreateUserUsecase>(
    () => CreateUserUsecase(userRepository: getIt<UserRemoteRepository>()),
  );

  getIt.registerLazySingleton<UploadImageUsecase>(
    () => UploadImageUsecase(getIt<UserRemoteRepository>()),
  );

  getIt.registerFactory<RegisterBloc>(
    () => RegisterBloc(
      createUserUsecase: getIt<CreateUserUsecase>(),
      uploadImageUsecase: getIt<UploadImageUsecase>(),
    ),
  );
}

_initOnBoardingScreenDependencies() async {
  getIt.registerFactory(() => OnboardingCubit(getIt<LoginBloc>()));
}


_initLoginDependencies() async {
  getIt.registerLazySingleton<TokenSharedPrefs>(
    () => TokenSharedPrefs(getIt<SharedPreferences>()),
  );

  getIt.registerLazySingleton<LoginUsecase>(
    () =>
        LoginUsecase(getIt<UserRemoteRepository>(), getIt<TokenSharedPrefs>()),
  );

  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(
      registerBloc: getIt<RegisterBloc>(),
      loginUsecase: getIt<LoginUsecase>(),
      userProfileService: getIt<UserProfileService>(),
    ),
  );
}

_initSplashScreenDependencies() async {
  getIt.registerFactory(() => SplashCubit(getIt<OnboardingCubit>()));
}


_initContactDependencies() async {
  // Contact Management Dependencies (Submit, Get All & Delete)
  getIt.registerLazySingleton<ContactRemoteDataSource>(
      () => ContactRemoteDataSourceImpl(getIt<Dio>()));
  getIt.registerLazySingleton<ContactRepository>(
      () => ContactRepositoryImpl(getIt<ContactRemoteDataSource>()));
  getIt.registerLazySingleton<SubmitContactUseCase>(
      () => SubmitContactUseCase(getIt<ContactRepository>()));
  getIt.registerLazySingleton<GetAllContactsUseCase>(
      () => GetAllContactsUseCase(getIt<ContactRepository>()));
  getIt.registerLazySingleton<DeleteContactUseCase>(
      () => DeleteContactUseCase(getIt<ContactRepository>()));
  
  // Register the ContactBlocView for user contact submission
  getIt.registerFactory<ContactBlocView>(
      () => ContactBlocView(getIt<SubmitContactUseCase>()));
  
  // Register the admin ContactBloc for managing contacts (get all & delete)
  getIt.registerFactory<ContactBloc>(
      () => ContactBloc(
          getAllContactsUseCase: getIt<GetAllContactsUseCase>(),
          deleteContactUseCase: getIt<DeleteContactUseCase>()));
}

_initBookingDependencies() async {
  // Booking Management Dependencies
  getIt.registerLazySingleton<BookingRemoteDataSource>(
      () => BookingRemoteDataSourceImpl(getIt<Dio>()));
  getIt.registerLazySingleton<BookingRepository>(
      () => BookingRepositoryImpl(getIt<BookingRemoteDataSource>()));
  getIt.registerLazySingleton<CreateBookingUseCase>(
      () => CreateBookingUseCase(getIt<BookingRepository>()));
  getIt.registerLazySingleton<GetUserBookingsUseCase>(
      () => GetUserBookingsUseCase(getIt<BookingRepository>()));
  getIt.registerLazySingleton<GetAllBookingsUseCase>(
      () => GetAllBookingsUseCase(getIt<BookingRepository>()));
  getIt.registerLazySingleton<CancelBookingUseCase>(
      () => CancelBookingUseCase(getIt<BookingRepository>()));
  getIt.registerLazySingleton<ApproveBookingUseCase>(
      () => ApproveBookingUseCase(getIt<BookingRepository>()));
  getIt.registerLazySingleton<DeleteBookingUseCase>(
      () => DeleteBookingUseCase(getIt<BookingRepository>()));
  getIt.registerFactory<BookingBloc>(() => BookingBloc(
      createBookingUseCase: getIt<CreateBookingUseCase>(),
      getUserBookingsUseCase: getIt<GetUserBookingsUseCase>(),
      getAllBookingsUseCase: getIt<GetAllBookingsUseCase>(),
      cancelBookingUseCase: getIt<CancelBookingUseCase>(),
      approveBookingUseCase: getIt<ApproveBookingUseCase>(),
      deleteBookingUseCase: getIt<DeleteBookingUseCase>()));
}


_initVenueDependencies() async {
  // Venue Management Dependencies
  getIt.registerLazySingleton<VenueRemoteDataSource>(
      () => VenueRemoteDataSourceImpl(getIt<Dio>()));
  getIt.registerLazySingleton<VenueRepository>(
      () => VenueRepositoryImpl(getIt<VenueRemoteDataSource>()));
  getIt.registerLazySingleton<GetAllVenuesUseCase>(
      () => GetAllVenuesUseCase(getIt<VenueRepository>()));
  getIt.registerLazySingleton<AddVenueUseCase>(
      () => AddVenueUseCase(getIt<VenueRepository>()));
  getIt.registerLazySingleton<UpdateVenueUseCase>(
      () => UpdateVenueUseCase(getIt<VenueRepository>()));
  getIt.registerLazySingleton<DeleteVenueUseCase>(
      () => DeleteVenueUseCase(getIt<VenueRepository>()));
  // IMPORTANT: Ensure the VenueBloc import is the same in HomeScreen.
  getIt.registerFactory<VenueBloc>(() => VenueBloc(
      getAllVenuesUseCase: getIt<GetAllVenuesUseCase>(),
      addVenueUseCase: getIt<AddVenueUseCase>(),
      updateVenueUseCase: getIt<UpdateVenueUseCase>(),
      deleteVenueUseCase: getIt<DeleteVenueUseCase>()));
}
