import 'dart:async';
import 'package:flutter/material.dart';
import 'package:proximity_sensor/proximity_sensor.dart';

class NearDetector extends StatefulWidget {
  final Widget child;
  final VoidCallback onNearDetected;
  
  const NearDetector({
    Key? key,
    required this.child,
    required this.onNearDetected,
  }) : super(key: key);

  @override
  _NearDetectorState createState() => _NearDetectorState();
}

class _NearDetectorState extends State<NearDetector> {
  late StreamSubscription<dynamic> _proximitySubscription;
  bool _hasTriggered = false;

  @override
  void initState() {
    super.initState();
    _proximitySubscription = ProximitySensor.events.listen((int event) {
      // Typically, a value of 1 means something is near.
      if (event == 1 && !_hasTriggered) {
        _hasTriggered = true;
        widget.onNearDetected();
      } else if (event == 0) {
        _hasTriggered = false;
      }
    });
  }

  @override
  void dispose() {
    _proximitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
