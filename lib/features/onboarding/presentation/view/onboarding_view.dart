import 'package:flutter/material.dart';

import '../../../auth/presentation/view/login_view.dart';

 // Update this import with the correct path

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int selectedIndex = 0;
  late PageController controller;

  final List<Map<String, String>> onBoardingData = [
    {
      "image": "assets/images/bride.png",
      "title": "Welcome to SajiloBihe",
      "description": "Explore, compare, and book ",
    },
    {
      "image": "assets/images/bihe.png",
      "title": "Plan with Ease",
      "description": "Discover the perfect venue for your events",
    },
    {
      "image": "assets/images/birthday.png",
      "title": "Hassle-Free Booking",
      "description": "Start Exploring Event Venue Booking app",
    },
  ];

  @override
  void initState() {
    controller =
        PageController(initialPage: 0, keepPage: true, viewportFraction: 1);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                "SKIP",
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: PageView.builder(
                itemCount: onBoardingData.length,
                controller: controller,
                onPageChanged: (v) {
                  setState(() {
                    selectedIndex = v;
                  });
                },
                itemBuilder: (context, index) {
                  final item = onBoardingData[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset(
                        item["image"]!,
                        height: size.height * 0.3,
                      ),
                      SizedBox(height: size.height * 0.05),
                      FittedBox(
                        child: Text(
                          item["title"]!,
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Text(
                        item["description"]!,
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: size.height * 0.1),
                    ],
                  );
                },
              ),
            ),
            Row(
              children: [
                SizedBox(width: size.width * 0.05),
                Row(
                  children: List.generate(
                    onBoardingData.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease,
                      height: 8,
                      width: selectedIndex == index ? 24 : 8,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: selectedIndex == index
                            ? Colors.redAccent
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    if (selectedIndex < onBoardingData.length - 1) {
                      controller.animateToPage(selectedIndex + 1,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease);
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    }
                  },
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.redAccent,
                    child: selectedIndex != onBoardingData.length - 1
                        ? const Icon(
                            Icons.arrow_forward,
                            size: 30,
                            color: Colors.white,
                          )
                        : Text(
                            "Start",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                          ),
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.15),
          ],
        ),
      ),
    );
  }
}
