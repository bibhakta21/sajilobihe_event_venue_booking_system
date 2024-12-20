import 'package:flutter/material.dart';
import 'package:sajilobihe_event_venue_booking_system/core/app_theme/app_theme.dart';
import 'package:sajilobihe_event_venue_booking_system/view/splashscreen_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Dashboard',
      debugShowCheckedModeBanner: false,
      theme: getApplicationTheme(),
      home: const SplashscreenView(),
    );
  }
}
