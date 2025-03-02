import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/features/auth/domain/entity/venue.dart';
import 'package:sajilobihe_event_venue_booking_system/features/dashboard1/admin_screens/view_model/venue_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/features/dashboard1/admin_screens/view_model/venue_event.dart';
import 'package:sajilobihe_event_venue_booking_system/features/dashboard1/admin_screens/view_model/venue_state.dart';


class UpdateVenuePage extends StatefulWidget {
  final Venue venue;
  const UpdateVenuePage({Key? key, required this.venue}) : super(key: key);

  @override
  _UpdateVenuePageState createState() => _UpdateVenuePageState();
}

class _UpdateVenuePageState extends State<UpdateVenuePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _capacityController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _imagesController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.venue.name);
    _locationController = TextEditingController(text: widget.venue.location);
    _capacityController = TextEditingController(text: widget.venue.capacity.toString());
    _priceController = TextEditingController(text: widget.venue.price.toString());
    _descriptionController = TextEditingController(text: widget.venue.description);
    _imagesController = TextEditingController(text: widget.venue.images.join(", "));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _capacityController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imagesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Venue"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocListener<VenueBloc, VenueState>(
          listener: (context, state) {
            if (state is VenueOperationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              Navigator.pop(context);
            } else if (state is VenueError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Name"),
                  validator: (value) => value!.isEmpty ? "Enter name" : null,
                ),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: "Location"),
                  validator: (value) => value!.isEmpty ? "Enter location" : null,
                ),
                TextFormField(
                  controller: _capacityController,
                  decoration: const InputDecoration(labelText: "Capacity"),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? "Enter capacity" : null,
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: "Price"),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? "Enter price" : null,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: "Description"),
                  validator: (value) => value!.isEmpty ? "Enter description" : null,
                ),
                TextFormField(
                  controller: _imagesController,
                  decoration: const InputDecoration(
                    labelText: "Images (comma separated URLs)",
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Enter at least one image URL" : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  child: const Text("Update Venue"),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final images = _imagesController.text
                          .split(",")
                          .map((e) => e.trim())
                          .toList();
                      context.read<VenueBloc>().add(
                        UpdateVenueEvent(
                          id: widget.venue.id,
                          name: _nameController.text,
                          location: _locationController.text,
                          capacity: int.parse(_capacityController.text),
                          price: double.parse(_priceController.text),
                          description: _descriptionController.text,
                          images: images,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
