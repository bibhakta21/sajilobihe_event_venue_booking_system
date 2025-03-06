import 'package:flutter/material.dart';
import 'package:sajilobihe_event_venue_booking_system/app/app.dart';
import 'package:sajilobihe_event_venue_booking_system/app/di/di.dart';
import 'package:sajilobihe_event_venue_booking_system/core/network/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService().init();

  await initDependencies();
  runApp(const MyApp());
}
