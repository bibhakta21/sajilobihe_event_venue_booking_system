import 'package:sajilobihe_event_venue_booking_system/features/auth/presentation/view/register_view.dart';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../../dashboard/dashboard_view.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? _emailError;
  String? _passwordError;

  void login() async {
    var userBox = await Hive.openBox('users'); // Open Hive box
    String email = emailController.text;
    String password = passwordController.text;

    // Check if email exists in Hive storage
    if (userBox.containsKey(email)) {
      Map<String, dynamic> userData = userBox.get(email);
      if (userData["password"] == password) {
        _showSuccessSnackBar("Login successful!");

        // Navigate to Dashboard after showing success message
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const DashboardView()),
          );
        });
      } else {
        _showErrorSnackBar("Incorrect password. Try again.");
      }
    } else {
      _showErrorSnackBar("No account found with this email.");
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo with elephants and design
                Column(
                  children: [
                    Image.asset(
                      'assets/images/logo.png', // Add your logo image path here
                      height: 200,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Welcome text
                const Text(
                  "Welcome back",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Sign in to access your account",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 32),

                // Email TextField
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Enter your email',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Password TextField
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Forgot password button
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Add forgot password functionality here
                    },
                    child: const Text(
                      "Forgot password?",
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Login button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      _validateForm();
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("New Member? "),
                    TextButton(
                      onPressed: () {
                        // Navigate to RegisterView
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterView()),
                        );
                      },
                      child: const Text(
                        "Register now",
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _validateForm() {
    String email = emailController.text;
    String password = passwordController.text;

    // Reset errors
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    // Email Validation (checks for @gmail.com domain)
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$').hasMatch(email)) {
      setState(() {
        _emailError = 'Please enter a valid Gmail address.';
      });
    }

    // Password Validation (checks for at least 8 characters)
    if (password.length < 8) {
      setState(() {
        _passwordError = 'Password must be at least 8 characters long.';
      });
    }

    // If no errors, attempt login
    if (_emailError == null && _passwordError == null) {
      login();
    }
  }
}
