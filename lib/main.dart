import 'package:sajilobihe_event_venue_booking_system/app/app.dart'; // App widget that sets up the main screen and theme
import 'package:sajilobihe_event_venue_booking_system/app/di/di.dart'; // Dependency injection for services and blocs
import 'package:sajilobihe_event_venue_booking_system/core/network/hive_service.dart'; // Hive service for local storage management
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure proper initialization of Flutter bindings

  // Initialize Hive Database
  await HiveService.init(); // Open and initialize Hive database for persistent storage
  
  // Initialize Dependencies (services and blocs)
  await initDependencies(); // Set up dependency injection for the app

  // Run the app with the provided App widget
  runApp(
    const App(), // Launch the app starting with the Splash screen
  );
}
