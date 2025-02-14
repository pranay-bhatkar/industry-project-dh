import 'package:dh/Navigation/basescaffold.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddVillaOwnerD extends StatefulWidget {
  const AddVillaOwnerD({super.key});

  @override
  State<AddVillaOwnerD> createState() => _AddVillaOwnerDState();
}

class _AddVillaOwnerDState extends State<AddVillaOwnerD> {
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _ownerEmailController = TextEditingController();
  final TextEditingController _ownerPasswordController = TextEditingController();

  final DatabaseReference reference = FirebaseDatabase.instance.ref('villaOwners');

  @override
  void dispose() {
    _ownerNameController.dispose();
    _ownerEmailController.dispose();
    _ownerPasswordController.dispose();
    super.dispose();
  }

  Future<void> _storeVillaOwnerData() async {
    final ownerName = _ownerNameController.text;
    final ownerEmail = _ownerEmailController.text;
    final ownerPassword = _ownerPasswordController.text;

    if (ownerName.isEmpty || ownerEmail.isEmpty || ownerPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required")),
      );
      return;
    }

    try {
      await reference.push().set({
        "ownerName": ownerName,
        "ownerEmail": ownerEmail,
        "ownerPassword": ownerPassword,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Villa owner added successfully")),
      );

      // Clear input fields
      _ownerNameController.clear();
      _ownerEmailController.clear();
      _ownerPasswordController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to add villa owner")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Add Villa Owner',
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Column(
            children: [
              TextFormField(
                controller: _ownerNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelText: 'Villa Owner Name',
                  hintText: 'Enter Owner Name',
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _ownerEmailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelText: 'Villa Owner Email',
                  hintText: 'Enter Owner Email',
                  prefixIcon: const Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _ownerPasswordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelText: 'Villa Owner Password',
                  hintText: 'Enter Owner Password',
                  prefixIcon: const Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _storeVillaOwnerData,
                child: const Text("Add Villa Owner"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
