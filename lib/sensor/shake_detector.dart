// shake_detector.dart
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class ShakeDetector extends StatefulWidget {
  final Widget child;
  final VoidCallback onShake;
  final double shakeThreshold;
  final Duration cooldown;

  const ShakeDetector({
    super.key,
    required this.child,
    required this.onShake,
    this.shakeThreshold = 15.0,
    this.cooldown = const Duration(seconds: 2),
  });

  @override
  _ShakeDetectorState createState() => _ShakeDetectorState();
}

class _ShakeDetectorState extends State<ShakeDetector> {
  late StreamSubscription<AccelerometerEvent> _subscription;
  DateTime _lastShake = DateTime.now();

  @override
  void initState() {
    super.initState();
    _subscription = accelerometerEvents.listen((AccelerometerEvent event) {
      final double acceleration =
          sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      if (acceleration > widget.shakeThreshold) {
        final DateTime now = DateTime.now();
        if (now.difference(_lastShake) > widget.cooldown) {
          _lastShake = now;
          widget.onShake();
        }
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
