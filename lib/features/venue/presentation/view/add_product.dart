import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/presentation/view_model/admin/venue_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/presentation/view_model/admin/venue_event.dart';
import 'package:sajilobihe_event_venue_booking_system/features/venue/presentation/view_model/admin/venue_state.dart';

class AddVenueScreen extends StatefulWidget {
  const AddVenueScreen({Key? key}) : super(key: key);

  @override
  _AddVenueScreenState createState() => _AddVenueScreenState();
}

class _AddVenueScreenState extends State<AddVenueScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _capacityController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Light background color
      appBar: AppBar(
        title: const Text("Add Venue"),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
            child: BlocListener<VenueBloc, VenueState>(
              listener: (context, state) {
                if (state is VenueOperationSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.green,
                    ),
                  );
                  _nameController.clear();
                  _locationController.clear();
                  _capacityController.clear();
                  _priceController.clear();
                  _descriptionController.clear();
                  setState(() {
                    _selectedImage = null;
                  });
                } else if (state is VenueError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 8, // Adds shadow for a modern look
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Venue Details",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildTextField(
                          controller: _nameController,
                          label: "Venue Name",
                          icon: Icons.event,
                        ),
                        _buildTextField(
                          controller: _locationController,
                          label: "Location",
                          icon: Icons.location_on,
                        ),
                        _buildTextField(
                          controller: _capacityController,
                          label: "Capacity",
                          icon: Icons.people,
                          keyboardType: TextInputType.number,
                        ),
                        _buildTextField(
                          controller: _priceController,
                          label: "Price",
                          icon: Icons.attach_money,
                          keyboardType: TextInputType.number,
                        ),
                        _buildTextField(
                          controller: _descriptionController,
                          label: "Description",
                          icon: Icons.description,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 15),
                        // Image Picker Section
                        _buildImagePicker(),
                        const SizedBox(height: 20),
                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "Add Venue",
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                context.read<VenueBloc>().add(
                                  AddVenueEvent(
                                    name: _nameController.text,
                                    location: _locationController.text,
                                    capacity: int.parse(_capacityController.text),
                                    price: double.parse(_priceController.text),
                                    description: _descriptionController.text,
                                    images: _selectedImage != null
                                        ? [_selectedImage!.path]
                                        : [],
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Custom Method to Build TextFields with Icons
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.redAccent),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.redAccent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.redAccent, width: 2),
          ),
        ),
        validator: (value) => value == null || value.isEmpty ? "Enter $label" : null,
      ),
    );
  }

  /// Image Picker UI
  Widget _buildImagePicker() {
    return Column(
      children: [
        if (_selectedImage != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              _selectedImage!,
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text("Camera"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
              onPressed: () => _pickImage(ImageSource.camera),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.image),
              label: const Text("Gallery"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () => _pickImage(ImageSource.gallery),
            ),
          ],
        ),
      ],
    );
  }
}
