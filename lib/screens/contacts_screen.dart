import 'package:flutter/material.dart';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  // This is a mock contact list. Replace it with your API data.
  List<Map<String, dynamic>> contacts = [
    {
      "contact_number": "+216 28581523",
      "contact_name": "Amine",
      "_id": "66d8dbc24fc81625d2680884",
      "createdAt": "2024-09-04T22:14:26.967Z",
    },
    {
      "contact_number": "+216 28581525",
      "contact_name": null, // This will be handled as 'Unknown Name'
      "_id": "66d8dbc24fc81625d2680885",
      "createdAt": "2024-09-04T22:14:26.967Z",
    },
    {
      "contact_number": null, // This will be handled as 'Unknown Number'
      "contact_name": "John Doe",
      "_id": "66d8dbc24fc81625d2680886",
      "createdAt": "2024-09-04T22:14:26.967Z",
    }
  ];

  // Add Contact Functionality
  void _addContact(String name, String number) {
    setState(() {
      contacts.add({
        "contact_name": name,
        "contact_number": number,
        "_id": DateTime.now().toString(),
        "createdAt": DateTime.now().toIso8601String(),
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts"),
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          final contactName = contact['contact_name'] ?? 'Unknown Name';
          final contactNumber = contact['contact_number'] ?? 'Unknown Number';

          return ListTile(
            title: Text(contactName),
            subtitle: Text(contactNumber),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  contacts.removeAt(index);
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Example: Adding a new contact
          _addContact("New Contact", "+1234567890");
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
