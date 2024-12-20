import 'package:flutter/material.dart';

import '../view/Bottom_Screen/profile_view.dart';
import 'Bottom_Screen/bookmark_view.dart';
import 'Bottom_Screen/homescreen_view.dart';
import 'Bottom_Screen/order_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _BottomNavigationViewState();
}

class _BottomNavigationViewState extends State<DashboardView> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const BookmarkView(),
    const OrderView(),
    const ProfileView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookmark',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_rounded),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
