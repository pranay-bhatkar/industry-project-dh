import 'package:dh/Navigation/basescaffold.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeveloperHomepage extends StatefulWidget {
  const DeveloperHomepage({super.key});

  @override
  State<DeveloperHomepage> createState() => _DeveloperHomepageState();
}

class _DeveloperHomepageState extends State<DeveloperHomepage> {
  String? userEmail;

  final TextEditingController _villaName = TextEditingController();
  final TextEditingController _villaNumber = TextEditingController();
  final TextEditingController _villaSize = TextEditingController();
  final TextEditingController _villaPrice = TextEditingController();
  final TextEditingController _villaOwner = TextEditingController();

  final DatabaseReference reference = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _initializeSharedPreferences();
  }

  Future<void> _initializeSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('developerEmail');
    });
  }

  Future<void> _store_into_database() async {
    final villaName = _villaName.text;
    final villaNumber = _villaNumber.text;
    final villaSize = _villaSize.text;
    final villaPrice = _villaPrice.text;
    final villaOwner = _villaOwner.text;

    if (villaName.isEmpty ||
        villaNumber.isEmpty ||
        villaSize.isEmpty ||
        villaPrice.isEmpty ||
        villaOwner.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are Required")),
      );
      return;
    }

    try {
      await reference.child("villas").child(villaNumber).set({
        "villaName": villaName,
        "villaNumber": villaNumber,
        "villaSize": villaSize,
        "villaPrice": villaPrice,
        "villaOwner": villaOwner,
        "villaStatus": "on",
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data Saved Successfully")),
      );
      _villaName.clear();
      _villaNumber.clear();
      _villaSize.clear();
      _villaPrice.clear();
      _villaOwner.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to Save Data!")),
      );
    }
  }

  @override
  void dispose() {
    _villaName.dispose();
    _villaNumber.dispose();
    _villaSize.dispose();
    _villaPrice.dispose();
    _villaOwner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return BaseScaffold(
      title: "DeveloperHomePage",
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: isMobile
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildInputFields(),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildInputFields().sublist(0, 3),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildInputFields().sublist(3),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildInputFields() {
    return [
      TextFormField(
        controller: _villaName,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          labelText: 'Villa Name',
          hintText: 'Enter Villa Name',
          prefixIcon: const Icon(Icons.add_business_sharp),
        ),
      ),
      const SizedBox(height: 30),
      TextFormField(
        controller: _villaNumber,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          labelText: 'Villa Number',
          hintText: 'Enter Villa Number',
          prefixIcon: const Icon(Icons.add_business_sharp),
        ),
      ),
      const SizedBox(height: 30),
      TextFormField(
        controller: _villaSize,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          hintText: 'Villa Size',
          labelText: 'Enter Villa Size (BHK)',
          prefixIcon: const Icon(Icons.add_business_sharp),
        ),
      ),
      const SizedBox(height: 30),
      TextFormField(
        controller: _villaPrice,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          hintText: 'Villa Price',
          labelText: 'Enter Villa Price',
          prefixIcon: const Icon(Icons.add_business_sharp),
        ),
      ),
      const SizedBox(height: 30),
      TextFormField(
        controller: _villaOwner,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          hintText: 'Villa Owner Name',
          labelText: 'Owner Name',
          prefixIcon: const Icon(Icons.person),
        ),
      ),
      const SizedBox(height: 30),
      Center(
        child: ElevatedButton(
          onPressed: (_store_into_database),
          child: const Text("Add Villa"),
        ),
      ),
    ];
  }
}
