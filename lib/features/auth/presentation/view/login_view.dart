import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/app/constants/color_constants.dart';
import 'package:sajilobihe_event_venue_booking_system/core/common/widgets/custom_elevated_button.dart';
import 'package:sajilobihe_event_venue_booking_system/core/common/widgets/custom_text_field.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/presentation/view/register_view.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/presentation/view_model/login/login_bloc.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final _loginFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _loginFormKey,  // Wrap the form with the form key
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo with elephants and design
                  Image.asset(
                    'assets/images/logo.png', // Add your logo image path here
                    height: 200,
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
                  CustomTextField(
                    controller: _emailController,
                    validator: ValidateLogin.emailValidate, // Add validator here
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'Enter your email',
                  ),
                  const SizedBox(height: 16),

                  // Password TextField
                  CustomTextField(
                    controller: _passwordController,
                    validator: ValidateLogin.passwordValidate, // Add validator here
                    keyboardType: TextInputType.visiblePassword,
                    hintText: 'Password',
                  ),
                  const SizedBox(height: 8),

                  // Forgot password button
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed("/forget-password");
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
                    child: CustomElevatedButton(
                      text: "Login",
                      onPressed: () async {
                        if (_loginFormKey.currentState!.validate()) {
                          // Proceed with login if the form is valid
                          context.read<LoginBloc>().add(
                            LoginUserEvent(
                              context: context,
                              email: _emailController.text,
                              password: _passwordController.text,
                            ),
                          );
                        }
                      },
                      width: double.infinity,
                      textColor: Colors.white,
                      verticalPadding: 18.0,
                      fontSize: 18.0,
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
                          context.read<LoginBloc>().add(
                            NavigateRegisterScreenEvent(
                              context: context,
                              destination: const RegisterView(),
                            ),
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
      ),
    );
  }
}

class ValidateLogin {
  static String? emailValidate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    return null;
  }

  static String? passwordValidate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }
}
