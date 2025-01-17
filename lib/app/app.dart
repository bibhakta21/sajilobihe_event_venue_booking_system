import 'package:sajilobihe_event_venue_booking_system/app/di/di.dart'; // Dependency injection for services and blocs
import 'package:sajilobihe_event_venue_booking_system/core/app_theme.dart'; // Application theme configuration
import 'package:sajilobihe_event_venue_booking_system/features/splash/presentation/view/splash_screen_view.dart'; // SplashScreen widget import
import 'package:sajilobihe_event_venue_booking_system/features/splash/presentation/view_model/splash_cubit.dart'; // SplashCubit for splash screen logic
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Flutter BLoC library for state management

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Disable debug banner
      title: 'SajiloBihe', // Application title
      theme: getApplicationTheme(), // Set the theme of the app
      home: BlocProvider.value(
        value: getIt<SplashCubit>(), // Provide SplashCubit instance using dependency injection
        child: const SplashScreen(), // Use the SplashScreen widget as the home screen
      ),
    );
  }
}
