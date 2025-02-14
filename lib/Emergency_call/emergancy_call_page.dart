import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Navigation/basescaffold.dart';

class EmergencyCalls extends StatelessWidget {
  const EmergencyCalls({super.key});

  final String policePhoneNumber =
      '+91 7506541325'; // Emergency number for police
  final String ambulancePhoneNumber =
      '+91 7506541325'; // Emergency number for ambulance
  final String managerPhoneNumber =
      '+91 7506541325'; // Manager's contact number without '+91'

  // Method to make a phone call using url_launcher
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber.replaceAll(' ', ''), // Ensure no spaces
    );
    if (!await launchUrl(launchUri)) {
      print("Error: Could not launch $phoneNumber");
      throw 'Could not launch $phoneNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Emergency Contacts', // Set your title here
      body: Container(
        decoration: BoxDecoration(color: Color.fromARGB(255, 187, 245, 168)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildEmergencyCard(
                title: 'Call Police',
                description:
                    'Contact the nearest police station in case of emergency.',
                phoneNumber: policePhoneNumber,
                icon: Icons.local_police,
              ),
              _buildEmergencyCard(
                title: 'Call Ambulance',
                description: 'Get medical help during emergencies.',
                phoneNumber: ambulancePhoneNumber,
                icon: Icons.local_hospital,
              ),
              _buildEmergencyCard(
                title: 'Call Manager',
                description: 'Contact the manager for assistance.',
                phoneNumber: managerPhoneNumber,
                icon: Icons.person,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build an emergency card
  Widget _buildEmergencyCard({
    required String title,
    required String description,
    required String phoneNumber,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2E7D32), // Dark Green
            Color(0xFF66BB6A), // Light Green
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            spreadRadius: 2,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 36, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  textAlign: TextAlign.justify,
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          ElevatedButton(
            onPressed: () => _makePhoneCall(phoneNumber),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
            ),
            child: const Text(
              'Call',
              style: TextStyle(fontSize: 16, color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }
}
