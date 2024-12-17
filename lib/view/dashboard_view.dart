import 'package:flutter/material.dart';
import '../view/Bottom_Screen/about_view.dart';
import '../view/Bottom_Screen/profile_view.dart';
import '../view/Bottom_Screen/cart_view.dart';
import '../view/Bottom_Screen/home_cart.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _BottomNavigationViewState();
}

class _BottomNavigationViewState extends State<DashboardView> {
  int _selectedIndex = 0;

  
  final List<Widget> _screens = [
    const HomeScreen(),
    const CartView(),
    const ProfileView(),
    const AboutView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),  
        centerTitle: true,
      ),
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
            icon: Icon(Icons.shopping_bag),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
        ],
      ),
    );
  }
}
