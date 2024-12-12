import 'package:flutter/material.dart';
import 'package:sajilobihe_event_venue_booking_system/view/splashscreen_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Dashboard',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashscreenView(),
    );
  }
}
