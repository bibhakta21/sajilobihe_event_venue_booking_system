import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/app/di/di.dart';
import 'package:sajilobihe_event_venue_booking_system/core/theme/app_theme.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/features/contact_us/presentation/view_model/user/contact_bloc_view.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/presentation/view_model/admin/venue_bloc.dart';

import 'package:sajilobihe_event_venue_booking_system/features/splash/presentation/view/splash_view.dart';
import 'package:sajilobihe_event_venue_booking_system/features/splash/presentation/view_model/splash_cubit.dart';
// Import VenueBloc for venue management


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SplashCubit>(
          create: (_) => getIt<SplashCubit>(),
        ),
      
        BlocProvider<RegisterBloc>(
          create: (_) => getIt<RegisterBloc>(),
        ),
        BlocProvider<LoginBloc>(
          create: (_) => getIt<LoginBloc>(),
        ),
        BlocProvider<ContactBlocView>(
          create: (_) => getIt<ContactBlocView>(),
        ),
        
        // Add VenueBloc globally so that it is accessible in your venue management screens
        BlocProvider<VenueBloc>(
          create: (_) => getIt<VenueBloc>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sajilo bihe',
        theme: getApplicationTheme(),
        home: const SplashView(),
      ),
    );
  }
}
