import 'package:dh/Food/food_service_options.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Navigation/basescaffold.dart';

class FoodCallBookPage extends StatelessWidget {
  final String imageUrl =
      'https://firebasestorage.googleapis.com/v0/b/doodleshomes-7ffe2.appspot.com/o/images%2Fcaesarsalad.png?alt=media&token=7489dc2a-6cde-4a48-95c7-86b8857e6bfe';
  final String _phoneNumber = '+91 8669727126';

  const FoodCallBookPage({super.key});

  Future<void> _makePhoneCall() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: _phoneNumber,
    );

    if (!await launchUrl(launchUri)) {
      throw Exception('Could not launch $launchUri');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return BaseScaffold(
      title: "Food Details",
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFC1EDA1), // Light green
              Color(0xFF72A54D), // Dark green
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Center(
            child: Card(
              color: const Color(0x8A8AC379),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: const BorderSide(
                  color: Colors.white, // White border
                  width: 2.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    // Food Image
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                          color: Colors.white,
                          width: 3.0,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.network(
                          imageUrl,
                          height:
                              screenWidth > 600 ? 350 : 250, // Adaptive height
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Heading
                    const Text(
                      'What would you like to do ?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Buttons - Responsive row/column
                    LayoutBuilder(
                      builder: (context, constraints) {
                        if (screenWidth > 400) {
                          // Horizontal layout for wider screens
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              _buildActionButton(
                                text: 'Call',
                                color: Colors.green.shade700,
                                borderColor: Colors.white,
                                onPressed: _makePhoneCall,
                              ),
                              _buildActionButton(
                                text: 'Book',
                                color: Colors.redAccent,
                                borderColor: Colors.white,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const FoodServiceOption()),
                                  );
                                },
                              ),
                            ],
                          );
                        } else {
                          // Vertical layout for small screens
                          return Column(
                            children: <Widget>[
                              _buildActionButton(
                                text: 'Call',
                                color: Colors.green.shade700,
                                borderColor: Colors.white,
                                onPressed: _makePhoneCall,
                              ),
                              const SizedBox(height: 10),
                              _buildActionButton(
                                text: 'Book',
                                color: Colors.redAccent,
                                borderColor: Colors.white,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const FoodServiceOption()),
                                  );
                                },
                              ),
                            ],
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required Color color,
    required Color borderColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 140,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: borderColor, width: 2), // White border
          ),
          shadowColor: borderColor,
          elevation: 5,
        ),
        child: Text(text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
