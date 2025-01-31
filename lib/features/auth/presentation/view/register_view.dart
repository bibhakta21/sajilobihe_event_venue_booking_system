import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sajilobihe_event_venue_booking_system/app/constants/color_constants.dart';
import 'package:sajilobihe_event_venue_booking_system/core/common/widgets/custom_elevated_button.dart';
import 'package:sajilobihe_event_venue_booking_system/core/common/widgets/custom_text_field.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/presentation/view_model/signup/register_bloc.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _registerViewFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  File? _img;

  checkCameraPermission() async {
    if (await Permission.camera.request().isRestricted ||
        await Permission.camera.request().isDenied) {
      await Permission.camera.request();
    }
  }

  Future _browseImage(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image != null) {
        setState(() {
          _img = File(image.path);
          context.read<RegisterBloc>().add(
            LoadImage(file: _img!),
          );
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _registerViewFormKey,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 160,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 28.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'By creating a free account.',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              backgroundColor: Colors.grey[300],
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(10),
                                ),
                              ),
                              builder: (context) => Padding(
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        checkCameraPermission();
                                        _browseImage(ImageSource.camera);
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(Icons.camera),
                                      label: const Text('Camera'),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        _browseImage(ImageSource.gallery);
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(Icons.image),
                                      label: const Text('Gallery'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[200],
                            ),
                            child: _img != null
                                ? CircleAvatar(
                              backgroundImage: FileImage(_img!),
                              radius: 75,
                            )
                                : const CircleAvatar(
                              radius: 75,
                              child: Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomTextField(
                    controller: _nameController,
                    validator: ValidateLogin.fullNameValidate,
                    keyboardType: TextInputType.name,
                    hintText: 'Enter your fullname',
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _emailController,
                    validator: ValidateLogin.emailValidate,
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'Enter your email',
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _passwordController,
                    validator: ValidateLogin.passwordValidate,
                    keyboardType: TextInputType.visiblePassword,
                    hintText: 'Secured Password',
                  ),
                  const SizedBox(height: 20),
                  CustomElevatedButton(
                    text: "Sign Up",
                    onPressed: () {
                      if (_registerViewFormKey.currentState!.validate()) {
                        if (_img == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select a profile picture'),
                            ),
                          );
                          return;
                        }
                        final registerState = context.read<RegisterBloc>().state;
                        final imageName = registerState.imageName;
                        context.read<RegisterBloc>().add(
                          RegisterUserEvent(
                            context: context,
                            fullName: _nameController.text.trim(),
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                            avatar: imageName,
                          ),
                        );
                        // Clear fields after successful registration
                        _nameController.clear();
                        _emailController.clear();
                        _passwordController.clear();
                        setState(() {
                          _img = null;
                        });
                      }
                    },
                    width: double.infinity,
                    textColor: Colors.white,
                    verticalPadding: 18.0,
                    fontSize: 18.0,
                  ),
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {},
                      child: const Text(
                        "Already a member? Log in",
                        style: TextStyle(fontSize: 15.0, color: Colors.red),
                      ),
                    ),
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
  static String? fullNameValidate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }
    if (value.length < 3) {
      return 'Full name must be at least 3 characters long';
    }
    if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) {
      return 'Full name can only contain letters and spaces';
    }
    return null;
  }

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
