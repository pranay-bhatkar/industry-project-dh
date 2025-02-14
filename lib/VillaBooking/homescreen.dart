import 'package:dh/VillaBooking/villa_details_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Navigation/basescaffold.dart';

class CarouselScreen extends StatefulWidget {
  const CarouselScreen({super.key});

  @override
  _CarouselScreenState createState() => _CarouselScreenState();
}

class _CarouselScreenState extends State<CarouselScreen> {
  final List<String> imageUrls = ['assets/hone.jpg', 'assets/htwo.jpg'];
  String userPhoneNumber = "0", role = "user";
  final DatabaseReference reference = FirebaseDatabase.instance.ref('villas');
  bool _isUserScrolling = false;

  @override
  void initState() {
    super.initState();
    _initializeSharedPreferences();
    _requestSmsPermission();
  }

  Future<void> _initializeSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userPhoneNumber = prefs.getString('userPhoneNumber') ?? "0";
      role = prefs.getString('role') ?? "user";
    });
  }

  Future<void> _requestSmsPermission() async {
    if (await Permission.sms.status.isDenied) {
      if (await Permission.sms.request().isDenied) {
        if (mounted) {
          _showPermissionDialog();
        }
      }
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Permission Required"),
          content:
              const Text("This app needs SMS permission to send messages."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              child: const Text("Open Settings"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "Home Screen",
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          setState(() => _isUserScrolling =
              notification.direction != ScrollDirection.idle);
          return false;
        },
        child: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 250, 250, 250),
                  Color.fromARGB(255, 114, 165, 77),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            // color: const Color(0xFFE0D8C3),
            child: Column(
              children: [
                const SizedBox(height: 15),
                CarouselSlider(
                  items: imageUrls
                      .map((imageUrl) => _buildCarouselItem(imageUrl))
                      .toList(),
                  options: CarouselOptions(
                    height: 220,
                    enlargeCenterPage: true,
                    autoPlay: !_isUserScrolling,
                    autoPlayInterval: const Duration(seconds: 3),
                    viewportFraction: 0.8,
                    aspectRatio: 2.0,
                  ),
                ),
                if (userPhoneNumber != "0")
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      'User Phone Number: $userPhoneNumber',
                      style: const TextStyle(
                        color: Color(0xFF3E2723),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                FirebaseAnimatedList(
                  query: reference,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, snapshot, animation, index) =>
                      _buildVillaItem(snapshot),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselItem(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(imageUrl, fit: BoxFit.cover, width: double.infinity),
      ),
    );
  }

  Widget _buildVillaItem(DataSnapshot snapshot) {
    String villaStatus = snapshot.child('villaStatus').value.toString();
    bool isDisabled = villaStatus == "off";

    return GestureDetector(
      onTap: () {
        if (!isDisabled) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VillaDetailsPage(
                villaName: snapshot.child('villaName').value.toString(),
                villaNumber: snapshot.child('villaNumber').value.toString(),
                villaSize: snapshot.child('villaSize').value.toString(),
                villaPrice: snapshot.child('villaPrice').value.toString(),
                villaOwner: snapshot.child('villaOwner').value.toString(),
                villaStatus: villaStatus,
                userPhoneNumber: userPhoneNumber,
                role: role,
                agentPhoneNumber: '8669727126',
              ),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        decoration: BoxDecoration(
          border: Border.all(
              color: isDisabled ? Colors.grey : Color(0xFF4CAF50), width: 2),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDisabled ? 0.1 : 0.2),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Stack(
            children: [
              Image.asset('assets/hone.jpg',
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  opacity: AlwaysStoppedAnimation(isDisabled ? 0.5 : 0.9)),
              Container(
                height: 180,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildVillaText(
                        snapshot.child('villaName').value.toString(),
                        isDisabled),
                    _buildVillaText(
                        "${snapshot.child('villaSize').value}BHK | 10 Guests",
                        isDisabled),
                    _buildVillaText(
                        'Price: ${snapshot.child('villaPrice').value} /- per night',
                        isDisabled,
                        fontSize: 18),
                    _buildVillaText('Location: Lonavala', isDisabled,
                        fontSize: 18),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVillaText(String text, bool isDisabled, {double fontSize = 20}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: isDisabled ? Colors.grey : Colors.white,
        ),
      ),
    );
  }
}
