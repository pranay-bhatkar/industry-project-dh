import 'package:dh/Admin/admin_all_bookings.dart';
import 'package:dh/Admin/admin_food_bookings.dart';
import 'package:dh/VillaBooking/renters_villa_booked.dart';
import 'package:flutter/material.dart';
import 'package:dh/Food/foodbooking.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Navigation/basescaffold.dart';
import 'package:dh/Services/servicebooking.dart';

class MyBooking extends StatefulWidget {
  const MyBooking({super.key});

  @override
  _MyBookingState createState() => _MyBookingState();
}

class _MyBookingState extends State<MyBooking> {
  int _selectedIndex = 0;

  String userPhoneNumber = "0";
  String role = "user";

  @override
  void initState() {
    super.initState();
    _initializeSharedPreferences();
  }

  Future<void> _initializeSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    String? userPhoneNumbertemp = prefs.getString('userPhoneNumber');
    String? userRole = prefs.getString('role');
    if (userRole != null && userPhoneNumbertemp != null) {
      setState(() {
        userPhoneNumber = userPhoneNumbertemp;
        role = userRole;
      });
    }
  }

  final List<Widget> _userWidgetOptions = <Widget>[
    const Center(child: VillaTab()),
    const Center(child: FoodTab()),
  ];

  final List<Widget> _ownerWidgetOptions = <Widget>[
    const Center(child: ServiceTab()),
    const Center(child: FoodTab()),
  ];
  final List<Widget> _adminWidgetOptions = <Widget>[
    const Center(child: VillaTab()),
    const Center(child: AdminServiceTab()),
    const Center(child: AdminFoodTab()),
  ];

  List<Widget> get _widgetOptions => role == "owner"
      ? _ownerWidgetOptions
      : role == "admin"
          ? _adminWidgetOptions
          : _userWidgetOptions;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'My Bookings',
      body: Column(
        children: [
          Expanded(child: _widgetOptions[_selectedIndex]),
          BottomNavigationBar(
            items: _getBottomNavigationBarItems(),
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.greenAccent,
            onTap: _onItemTapped,
          ),
        ],
      ),
    );
  }

  List<BottomNavigationBarItem> _getBottomNavigationBarItems() {
    if (role == "owner") {
      return const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(Icons.miscellaneous_services), label: 'Service'),
        BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: 'Food'),
      ];
    } else if (role == "admin") {
      return const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.miscellaneous_services), label: 'Service'),
        BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: 'Food'),
      ];
    } else {
      return const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: 'Food'),
      ];
    }
  }
}

class VillaTab extends StatelessWidget {
  const VillaTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const RentersVillaBooked();
  }
}

class AdminServiceTab extends StatelessWidget {
  const AdminServiceTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminAllBooking();
  }
}

class ServiceTab extends StatelessWidget {
  const ServiceTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const ServiceBooking();
  }
}

class FoodTab extends StatelessWidget {
  const FoodTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const FoodBooking();
  }
}

class AdminFoodTab extends StatelessWidget {
  const AdminFoodTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminFoodBookings();
  }
}
