import 'package:dh/VillaBooking/villa_details_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Navigation/basescaffold.dart';

class VillaOwnerHome extends StatefulWidget {
  const VillaOwnerHome({super.key});

  @override
  State<VillaOwnerHome> createState() => _VillaOwnerHomeState();
}

class _VillaOwnerHomeState extends State<VillaOwnerHome> {
  final DatabaseReference reference = FirebaseDatabase.instance.ref('villas');

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

  @override
  Widget build(BuildContext context) {
    if (userPhoneNumber == "0") {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    Query query = reference.orderByChild('villaOwner').equalTo(userPhoneNumber);

    return BaseScaffold(
      title: 'Our Villa',
      body: SingleChildScrollView(
        child: FirebaseAnimatedList(
          query: query,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, snapshot, animation, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VillaDetailsPage(
                      villaName: snapshot.child('villaName').value.toString(),
                      villaNumber:
                          snapshot.child('villaNumber').value.toString(),
                      villaSize: snapshot.child('villaSize').value.toString(),
                      villaPrice: snapshot.child('villaPrice').value.toString(),
                      villaOwner: snapshot.child('villaOwner').value.toString(),
                      villaStatus:
                          snapshot.child('villaStatus').value.toString(),
                      userPhoneNumber: userPhoneNumber,
                      role: role,
                      agentPhoneNumber: '0101010101',
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, bottom: 5, top: 5),
                child: Container(
                  height: 270,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(25),
                              bottom: Radius.circular(25)),
                          child: Opacity(
                            opacity: 0.9,
                            child: Stack(
                              children: [
                                Image.asset(
                                  'assets/hone.jpg',
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                                Container(
                                  height: 180,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.7),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 150,
                          left: 10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot
                                        .child('villaName')
                                        .value
                                        .toString(),
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  const Text(
                                    "|",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    "${snapshot.child('villaSize').value}BHK",
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ),
                                  const Text(
                                    "|",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  const Text(
                                    "10 Guests",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Price : ${snapshot.child('villaPrice').value} /-',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Text(
                                    ' per day',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              const Text(
                                'Location : Lonavala',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
