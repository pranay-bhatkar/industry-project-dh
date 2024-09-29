import 'package:flutter/material.dart';
import 'package:dh/basescaffold.dart'; // Import BaseScaffold
import 'electrician.dart'; // Import individual service pages
// Import other services similarly

class ServicesScreen extends StatefulWidget {
  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  // List of all Services names
  final List<String> services = [
    'Electrician',
    'Plumber',
    'Househelp',
    'Laundry',
    'Gardener',
    'Grocery',
    'Bicycle Booking',
    'Local Transport',
    'Turf & Club',
  ];

  // Names of a particular service's sub-services
  final List<List<String>> serviceNames = [
    [
      'Fan Installation',
      'Light Repair',
      'Wiring Check',
      'UnInstallation',
    ],
    [
      'Pipe Leak Repair',
      'Tap Installation',
      'Drain Cleaning',
    ],
    [
      'House Cleaning',
      'Dish Washing',
      'Laundry',
    ],
    [
      'Wash and Iron',
      'Dry Cleaning',
      'Iron Only',
      'Clothes',
    ],
    [
      'Lawn Mowing',
      'Plant Watering',
      'Garden Maintenance',
    ],
    [
      'Home Delivery',
      'Bulk Order',
      'Express Delivery',
    ],
    [
      'Hourly Rental',
      'Daily Rental',
      'Weekly Rental',
    ],
    [
      'Taxi Booking',
      'Auto Rickshaw',
      'Bus Pass',
    ],
    [
      'Turf Booking',
      'Club Membership',
      'Event Hosting',
    ],
  ];

  // Price of all sub-services of each service
  final List<List<int>> servicesCharge = [
    [50, 52, 54, 56],
    [50, 52, 54],
    [50, 52, 54],
    [50, 52, 54, 60],
    [50, 52, 54],
    [50, 52, 54],
    [50, 52, 54],
    [50, 52, 54],
    [50, 52, 54],
  ];

  // Images of services
  final List<String> serviceImages = [
    'assets/electrician.png',
    'assets/plumber.png',
    'assets/househelp.png',
    'assets/laundry.png',
    'assets/gardener.png',
    'assets/grocery.png',
    'assets/bicycle.png',
    'assets/transport.png',
    'assets/turf.png',
  ];

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Services',
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Using GridView.builder for cards
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1, // One column to take full width
                childAspectRatio: 2.5, // Adjust the aspect ratio as needed
              ),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(0.0),
              itemCount: services.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Optional: handle tap on the card
                  },
                  child: Container(
                    margin: EdgeInsets.all(6.0),
                    width: double.infinity, // Full width of the screen
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Row(
                        children: [
                          // First Column: Image
                          Expanded(
                            flex: 2, // Adjust flex as needed
                            child: Container(
                              margin: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                image: DecorationImage(
                                  image: AssetImage(serviceImages[index]),
                                  fit: BoxFit.cover, // Maintain aspect ratio
                                ),
                              ),
                            ),
                          ),

                          // Second Column: Title and Button
                          Expanded(
                            flex: 3, // Adjust flex as needed
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    services[index],
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size(0, 0),
                                        alignment: Alignment.centerLeft,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ElectricianPage(
                                              title: services[index],
                                              imagePath: serviceImages[index],
                                              serviceOptions: [
                                                serviceNames[index]
                                              ],
                                              servicesCharge: [
                                                servicesCharge[index]
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text("View More"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
