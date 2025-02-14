import 'package:dh/VillaBooking/villa_booking.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VillaDetailsPage extends StatefulWidget {
  final String villaName,
      villaNumber,
      villaSize,
      villaPrice,
      villaOwner,
      villaStatus,
      role,
      userPhoneNumber;
  // agentPhoneNumber;

  const VillaDetailsPage({
    super.key,
    required this.villaName,
    required this.villaNumber,
    required this.villaSize,
    required this.villaPrice,
    required this.villaOwner,
    required this.villaStatus,
    required this.role,
    required this.userPhoneNumber,
    required String agentPhoneNumber,
    // required this.agentPhoneNumber,
  });

  @override
  State<VillaDetailsPage> createState() => _VillaDetailsPageState();
}

class _VillaDetailsPageState extends State<VillaDetailsPage> {
  final DatabaseReference reference = FirebaseDatabase.instance.ref('villas');
  String? tempAvailable;

  Future<void> _updateVillaStatus(String currentStatus) async {
    try {
      String newStatus = currentStatus == "on" ? "off" : "on";
      await reference
          .child(widget.villaNumber)
          .update({'villaStatus': newStatus});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Villa ${newStatus == 'on' ? 'Activated' : 'Deactivated'}")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Status Not Updated")));
    }
  }

  Stream<String?> _getExistDateStream() {
    return reference
        .child(widget.villaNumber)
        .child('available')
        .child(widget.villaNumber)
        .child('existDate')
        .onValue
        .map(
          (event) => event.snapshot.value as String?,
        );
  }

  Future<void> _makePhoneCall() async {
    const String agentPhoneNumber = '8669727126';
    final Uri launchUri = Uri(scheme: 'tel', path: agentPhoneNumber);
    if (!await launchUrl(launchUri)) {
      throw Exception('Could not launch $launchUri');
    }
  }

  @override
  void initState() {
    super.initState();
    _getExistDateStream().listen((value) {
      setState(() {
        tempAvailable = value == null || value.isEmpty ? "Available" : "Booked";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text(widget.villaName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/hone.jpg',
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[100],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('Villa Number:', widget.villaNumber),
                  _buildInfoRow('Size:', '${widget.villaSize} BHK'),
                  _buildInfoRow('Price:', 'Rs ${widget.villaPrice} / night',
                      color: Colors.green[800]!),
                  const SizedBox(height: 10),
                  _buildSectionTitle('Description'),
                  const Text(
                    'This villa is located in a serene area with beautiful surroundings. It features luxury amenities including spacious rooms, modern interiors, a scenic balcony view, and a fully equipped kitchen.',
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 15),
                  _buildSectionTitle('Facilities'),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _buildFacilityItem(Icons.wifi, 'Wi-Fi'),
                      _buildFacilityItem(Icons.hot_tub, 'Hot Water'),
                      _buildFacilityItem(Icons.bed, 'Double Bed'),
                      _buildFacilityItem(Icons.tv, 'Smart TV'),
                      _buildFacilityItem(Icons.free_breakfast, 'Breakfast'),
                      _buildFacilityItem(Icons.fitness_center, 'Gym'),
                      _buildFacilityItem(Icons.local_parking, 'Parking'),
                      _buildFacilityItem(Icons.ac_unit, 'Air Conditioning'),
                      _buildFacilityItem(Icons.pool, 'Swimming Pool'),
                      _buildFacilityItem(Icons.spa, 'Spa Services'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: widget.role == "owner" &&
                            widget.userPhoneNumber == widget.villaOwner
                        ? ElevatedButton(
                            onPressed: () =>
                                _updateVillaStatus(widget.villaStatus),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[700],
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 30),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                            child: Text(
                                widget.villaStatus == "on"
                                    ? "Deactivate"
                                    : "Activate",
                                style: const TextStyle(fontSize: 18)),
                          )
                        : ElevatedButton(
                            onPressed: _makePhoneCall,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[800],
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 30),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                            child: const Text("Contact Agent",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white)),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value,
      {Color color = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: RichText(
        text: TextSpan(
          text: '$label ',
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          children: [
            TextSpan(text: value, style: TextStyle(fontSize: 18, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(title,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
    );
  }

  Widget _buildFacilityItem(IconData icon, String text) {
    return Chip(
      backgroundColor: Colors.green[200],
      avatar: Icon(icon, color: Colors.green[900]),
      label: Text(text,
          style: TextStyle(
              color: Colors.green[900]!, fontWeight: FontWeight.w600)),
    );
  }
}
