import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Emergency_call/emergancy_call_page.dart';
import '../Food/food_call_book.dart';
import '../VillaBooking/homescreen.dart';
import '../Services/services.dart';
import 'package:dh/mybooking.dart';
import '../Registeration/signin.dart';
import 'package:dh/Admin/food_items_activate.dart';
import 'package:dh/Broker/broker_profile.dart';
import 'package:dh/Broker/user_history.dart';
import 'package:dh/Developer/add_broker.dart';
import 'package:dh/Developer/add_inner_services.dart';
import 'package:dh/Developer/add_service.dart';
import 'package:dh/Developer/add_villa_image.dart';
import 'package:dh/Developer/add_villa_owner.dart';
import 'package:dh/Developer/developer_homepage.dart';
import 'package:dh/VillaOwner/villa_owner_home.dart';

class SideNavigationBar extends StatefulWidget {
  const SideNavigationBar({super.key});

  @override
  State<SideNavigationBar> createState() => _SideNavigationBarState();
}

class _SideNavigationBarState extends State<SideNavigationBar> {
  String role = "user";
  String? userPhoneNumber;

  @override
  void initState() {
    super.initState();
    _initializeSharedPreferences();
  }

  Future<void> _initializeSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      role = prefs.getString('role') ?? "user";
      userPhoneNumber = prefs.getString('userPhoneNumber');
    });
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.setString('userPhoneNumber', "");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFA5D6A7), // Soft Green Background
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side:
                const BorderSide(color: Colors.green, width: 2), // Green Border
          ),
          title: const Text(
            'Confirm Log Out',
            style: TextStyle(
              color: Colors.black87, // Dark text for readability
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          content: const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Are you sure you want to log out?',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          actionsAlignment:
              MainAxisAlignment.spaceEvenly, // Center-align buttons
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),

            // Log Out Button
            TextButton(
              onPressed: () => _logout(context),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                child: Text(
                  'Log Out',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon,
          size: 30, color: const Color(0XFFD7A86E)), // Muted Clay Orange
      title: Text(
        title,
        style: const TextStyle(
            color: Color(0XFF3E2723), // Deep Earth Brown
            fontSize: 20,
            fontWeight: FontWeight.bold),
      ),
      onTap: onTap,
    );
  }

  Widget _buildRoleSpecificTiles() {
    switch (role) {
      case "developer":
        return Column(
          children: [
            _buildListTile(
              icon: Icons.home,
              title: 'Home',
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const CarouselScreen()),
              ),
            ),
            _buildListTile(
              icon: Icons.add_business_sharp,
              title: 'Add Villa',
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const DeveloperHomepage()),
              ),
            ),
            _buildListTile(
              icon: Icons.add_business_sharp,
              title: 'Add Villa Image',
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AddVilla()),
              ),
            ),
            _buildListTile(
              icon: Icons.catching_pokemon,
              title: 'Add Villa Owner',
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AddVillaOwnerD()),
              ),
            ),
            _buildListTile(
              icon: Icons.catching_pokemon,
              title: 'Add Broker',
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AddBroker()),
              ),
            ),
            _buildListTile(
              icon: Icons.cleaning_services_outlined,
              title: 'Add Service',
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AddService()),
              ),
            ),
            _buildListTile(
              icon: Icons.cleaning_services_outlined,
              title: 'Add Inner Service',
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddInnerServices()),
              ),
            ),
            _buildListTile(
              icon: Icons.perm_contact_calendar_outlined,
              title: 'Profile',
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        BrokerProfile(userPhoneNumber: userPhoneNumber!)),
              ),
            ),
            _buildListTile(
              icon: Icons.exit_to_app,
              title: 'Log Out',
              onTap: () => _showLogoutDialog(context),
            ),
          ],
        );
      case "admin":
        return Column(
          children: [
            _buildListTile(
              icon: Icons.home,
              title: 'Home',
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const CarouselScreen()),
              ),
            ),
            _buildListTile(
              icon: Icons.home,
              title: 'Bookings',
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MyBooking()),
              ),
            ),
            _buildListTile(
              icon: Icons.restaurant,
              title: 'Food',
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const FoodCallBookPage()),
              ),
            ),
            _buildListTile(
              icon: Icons.fastfood,
              title: 'Activated Foods',
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const FoodItemsActivate()),
              ),
            ),
            _buildListTile(
              icon: Icons.perm_contact_calendar_outlined,
              title: 'Profile',
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        BrokerProfile(userPhoneNumber: userPhoneNumber!)),
              ),
            ),
            _buildListTile(
              icon: Icons.exit_to_app,
              title: 'Log Out',
              onTap: () => _showLogoutDialog(context),
            ),
          ],
        );
      case "broker":
        return Column(
          children: [
            _buildListTile(
              icon: Icons.home,
              title: 'Home',
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const CarouselScreen()),
              ),
            ),
            _buildListTile(
              icon: Icons.person,
              title: 'User History',
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const UserHistory()),
              ),
            ),
            _buildListTile(
              icon: Icons.perm_contact_calendar_outlined,
              title: 'Profile',
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        BrokerProfile(userPhoneNumber: userPhoneNumber!)),
              ),
            ),
            _buildListTile(
              icon: Icons.exit_to_app,
              title: 'Log Out',
              onTap: () => _showLogoutDialog(context),
            ),
          ],
        );
      case "owner":
        return Column(
          children: [
            _buildListTile(
              icon: Icons.home,
              title: 'Home',
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const CarouselScreen()),
              ),
            ),
            _buildListTile(
              icon: Icons.person,
              title: 'My Villa',
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const VillaOwnerHome()),
              ),
            ),
            _buildListTile(
              icon: Icons.miscellaneous_services,
              title: 'Service',
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ServicesScreen()),
              ),
            ),
            _buildListTile(
              icon: Icons.restaurant,
              title: 'Food',
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const FoodCallBookPage()),
              ),
            ),
            _buildListTile(
              icon: Icons.book,
              title: 'My Bookings',
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MyBooking()),
              ),
            ),
            _buildListTile(
              icon: Icons.perm_contact_calendar_outlined,
              title: 'Profile',
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        BrokerProfile(userPhoneNumber: userPhoneNumber!)),
              ),
            ),
            _buildListTile(
              icon: Icons.exit_to_app,
              title: 'Log Out',
              onTap: () => _showLogoutDialog(context),
            ),
          ],
        );
      default:
        return Column(
          children: [
            _buildListTile(
              icon: Icons.home,
              title: 'Home',
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const CarouselScreen()),
              ),
            ),
            _buildListTile(
              icon: Icons.restaurant,
              title: 'Food',
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const FoodCallBookPage()),
              ),
            ),
            _buildListTile(
              icon: Icons.book,
              title: 'My Bookings',
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MyBooking()),
              ),
            ),
            _buildListTile(
              icon: Icons.call,
              title: 'Emergency Call',
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const EmergencyCalls()),
              ),
            ),
            _buildListTile(
              icon: Icons.perm_contact_calendar_outlined,
              title: 'Profile',
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        BrokerProfile(userPhoneNumber: userPhoneNumber!)),
              ),
            ),
            _buildListTile(
              icon: Icons.exit_to_app,
              title: 'Log Out',
              onTap: () => _showLogoutDialog(context),
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          Column(
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 156, 237, 144),
                      Color.fromARGB(255, 76, 167, 30),
                    ], // Sunset Over Forest Gradient
                    begin: Alignment.bottomRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
                height: 130,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 50),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Color(0XFFF5F5DC), // Soft Beige
                              size: 30,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Text(
                            "Navigation Menu",
                            style: TextStyle(
                                fontSize: 28,
                                color: Color(0XFFF5F5DC), // Soft Beige
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: const Color.fromARGB(
                      255, 203, 237, 214), // Light Sand (Surface)
                  child: _buildRoleSpecificTiles(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
