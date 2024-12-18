import 'package:flutter/material.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'About Screen',
        style: TextStyle(fontSize: 24,fontFamily: 'Montserrat Italic'),
      ),
    );
  }
}
