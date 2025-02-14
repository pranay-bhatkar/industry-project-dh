import 'package:dh/Navigation/basescaffold.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddBroker extends StatefulWidget {
  const AddBroker({super.key});

  @override
  State<AddBroker> createState() => _AddBrokerState();
}

class _AddBrokerState extends State<AddBroker> {
  final TextEditingController _brokerNameController = TextEditingController();
  final TextEditingController _brokerEmailController = TextEditingController();
  final TextEditingController _brokerPasswordController = TextEditingController();
  final TextEditingController _brokerContactController = TextEditingController();

  final DatabaseReference reference = FirebaseDatabase.instance.ref('brokers');

  @override
  void dispose() {
    _brokerNameController.dispose();
    _brokerEmailController.dispose();
    _brokerPasswordController.dispose();
    _brokerContactController.dispose();
    super.dispose();
  }

  Future<void> _storeBrokerData() async {
    final brokerName = _brokerNameController.text;
    final brokerEmail = _brokerEmailController.text;
    final brokerPassword = _brokerPasswordController.text;
    final brokerContact = _brokerContactController.text;

    if (brokerName.isEmpty || brokerEmail.isEmpty || brokerPassword.isEmpty || brokerContact.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required")),
      );
      return;
    }

    try {
      await reference.push().set({
        "brokerName": brokerName,
        "brokerEmail": brokerEmail,
        "brokerPassword": brokerPassword,
        "brokerContact": brokerContact,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Broker added successfully")),
      );

      _brokerNameController.clear();
      _brokerEmailController.clear();
      _brokerPasswordController.clear();
      _brokerContactController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to add broker")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Add Broker',
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Column(
            children: [
              TextFormField(
                controller: _brokerNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelText: 'Broker Name',
                  hintText: 'Enter Broker Name',
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _brokerEmailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelText: 'Broker Email',
                  hintText: 'Enter Broker Email',
                  prefixIcon: const Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _brokerPasswordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelText: 'Broker Password',
                  hintText: 'Enter Broker Password',
                  prefixIcon: const Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _brokerContactController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelText: 'Broker Contact Number',
                  hintText: 'Enter Contact Number',
                  prefixIcon: const Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _storeBrokerData,
                child: const Text("Add Broker"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
