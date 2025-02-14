import 'package:dh/Navigation/basescaffold.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Registeration/signin.dart';

class BrokerProfile extends StatefulWidget {
  final String userPhoneNumber;

  const BrokerProfile({super.key, required this.userPhoneNumber});

  @override
  State<BrokerProfile> createState() => _BrokerProfileState();
}

class _BrokerProfileState extends State<BrokerProfile> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref('userdata');

  String? userEmail;
  String? userName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final snapshot = await _database.child(widget.userPhoneNumber).get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        setState(() {
          userEmail = data['email'] ?? 'Email not available';
          userName = data['username'] ?? 'Username not available';
        });
      } else {
        _showSnackBar("User data not found");
      }
    } catch (e) {
      _showSnackBar("Error fetching data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Profile',
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFC8E6C9), // Light Green (Top)
              Color(0xFFA5D6A7), // Slightly Darker Green (Bottom)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.green)
              : LayoutBuilder(
                  builder: (context, constraints) {
                    double width =
                        constraints.maxWidth > 600 ? 500 : double.infinity;
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Profile Info Card
                          Container(
                            width: width,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 6,
                                  spreadRadius: 2,
                                  offset: const Offset(2, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _profileInfo("Username", userName ?? "N/A",
                                    Icons.person),
                                _profileInfo(
                                    "Email", userEmail ?? "N/A", Icons.email),
                                _profileInfo("Phone Number",
                                    widget.userPhoneNumber, Icons.phone),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Buttons Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _profileButton("Edit Profile", Icons.edit, () {}),
                              _profileButton(
                                  "Log Out", Icons.logout, _showLogoutDialog),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  // Profile Info Widget
  Widget _profileInfo(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.green[800], size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "$title: $value",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Profile Buttons
  Widget _profileButton(String text, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.green[800],
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Logout Confirmation Dialog
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFA5D6A7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(color: Colors.green, width: 2),
          ),
          title: const Text(
            'Confirm Log Out',
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 22),
          ),
          content: const Text(
            'Are you sure you want to log out?',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black87, fontSize: 18),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel',
                  style: TextStyle(color: Colors.black87, fontSize: 18)),
            ),
            TextButton(
              onPressed: _logout,
              child: const Text('Log Out',
                  style: TextStyle(color: Colors.redAccent, fontSize: 18)),
            ),
          ],
        );
      },
    );
  }

  // Logout function
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.setString('userPhoneNumber', "");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
    );
  }
}
