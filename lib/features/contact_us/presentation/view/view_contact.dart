import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/app/di/di.dart';
import 'package:sajilobihe_event_venue_booking_system/features/contact_us/presentation/view_model/admin/contact_bloc.dart';
import 'package:sajilobihe_event_venue_booking_system/features/contact_us/presentation/view_model/admin/contact_event.dart';
import 'package:sajilobihe_event_venue_booking_system/features/contact_us/presentation/view_model/admin/contact_state.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({Key? key}) : super(key: key);

  void _confirmDelete(BuildContext context, String contactId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text("Confirm Deletion", style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text("Are you sure you want to delete this contact?"),
          actions: [
            TextButton(
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
              onPressed: () => Navigator.pop(dialogContext),
            ),
            TextButton(
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<ContactBloc>().add(DeleteContactEvent(contactId));
              },
            ),
          ],
        );
      },
    );
  }

  void _showContactDetails(BuildContext context, dynamic contact) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.person, size: 50, color: Colors.blueAccent),
              const SizedBox(height: 10),
              Text(
                contact.name,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.email, color: Colors.redAccent),
                title: Text(contact.email),
              ),
              ListTile(
                leading: const Icon(Icons.phone, color: Colors.green),
                title: Text(contact.phone),
              ),
              ListTile(
                leading: const Icon(Icons.message, color: Colors.blue),
                title: Text(contact.message),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Close", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ContactBloc>()..add(LoadContacts()),
      child: Scaffold(
        backgroundColor: Colors.grey[100], // Light background
        appBar: AppBar(
          title: const Text("Contacts Management"),
          backgroundColor: Colors.white,
        ),
        body: BlocBuilder<ContactBloc, ContactState>(
          builder: (context, state) {
            if (state is ContactLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ContactsLoaded) {
              if (state.contacts.isEmpty) {
                return const Center(
                  child: Text("No contacts found.", style: TextStyle(fontSize: 16)),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.contacts.length,
                itemBuilder: (context, index) {
                  final contact = state.contacts[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: const CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(
                        contact.name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(contact.email, style: TextStyle(color: Colors.black54)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.visibility, color: Colors.blue),
                            onPressed: () => _showContactDetails(context, contact),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmDelete(context, contact.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is ContactError) {
              return Center(
                child: Text("Error: ${state.error}", style: const TextStyle(color: Colors.red)),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
