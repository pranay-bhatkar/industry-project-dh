import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'basescaffold.dart';
import 'booking_detail_page.dart'; // Import the booking detail page

class mybooking extends StatefulWidget {
  @override
  _mybookingState createState() => _mybookingState();
}

class _mybookingState extends State<mybooking> {
  List<Map<String, dynamic>> bookings = []; // List to store all bookings with details
  bool isLoading = true; // Flag to show loading indicator

  @override
  void initState() {
    super.initState();
    _fetchBookedServices();
  }

  Future<void> _fetchBookedServices() async {
    final prefs = await SharedPreferences.getInstance();
    final userPhoneNumber = prefs.getString('userPhoneNumber');

    if (userPhoneNumber != null) {
      final databaseRef = FirebaseDatabase.instance.ref('serviceBooking/$userPhoneNumber');
      try {
        final snapshot = await databaseRef.get();

        if (snapshot.exists) {
          final data = snapshot.value as Map<Object?, Object?>?;
          if (data != null) {
            bookings.clear(); // Clear previous data before adding new entries

            // Loop through each booking entry
            for (var entry in data.entries) {
              final bookingID = entry.key;
              final booking = entry.value as Map<Object?, Object?>?;
              final servicesDetails = booking?['servicesDetails'] as Map<Object?, Object?>?;
              final cost = booking?['cost'] as Map<Object?, Object?>?;

              if (servicesDetails != null && cost != null) {
                final services = servicesDetails['services'] as List<dynamic>?;
                final serviceTime = servicesDetails['serviceTime'] as String?;
                final serviceDate = servicesDetails['serviceDate'] as String?;
                final totalAmount = cost['totalAmount'] as int?;
                final bookingTime = booking?['bookingTime'] as String?;
                final serviceProvider = booking?['service_provider'] as String?;

                // Fetch the image URL from Firebase
                String imageUrl = await _getImageUrl(serviceProvider); // Use await here

                if (services != null && totalAmount != null && bookingTime != null) {
                  bookings.add({
                    'bookingTime': bookingTime,
                    'totalAmount': totalAmount,
                    'serviceTime': serviceTime,
                    'serviceDate': serviceDate,
                    'services': services,
                    'serviceProvider': serviceProvider,
                    'imageUrl': imageUrl, // Store the image URL directly
                  });
                }
              }
            }

            setState(() {
              isLoading = false; // Data fetched, stop loading
            });

            // Log the bookings for debugging
            print("Bookings: $bookings");
          } else {
            setState(() {
              bookings = [];
              isLoading = false; // No data found, stop loading
            });
          }
        } else {
          setState(() {
            bookings = [];
            isLoading = false; // No data found, stop loading
          });
        }
      } catch (error) {
        setState(() {
          isLoading = false; // Stop loading on error
        });
        print('Error fetching data: $error');
      }
    } else {
      setState(() {
        isLoading = false; // User phone number not found, stop loading
      });
    }
  }

  // Method to get the image URL based on service provider name
  Future<String> _getImageUrl(String? serviceProvider) async {
    if (serviceProvider == null) return ""; // Handle null service provider

    final databaseRef = FirebaseDatabase.instance.ref('assets/images/$serviceProvider');
    String imageUrl = "";

    try {
      final snapshot = await databaseRef.get(); // Use .get() instead of .once()
      if (snapshot.exists) {
        final data = snapshot.value as Map<Object?, Object?>?;
        imageUrl = data?['url'] as String? ?? ""; // Access the URL
        if (imageUrl.isEmpty) {
          print('Image URL is empty for $serviceProvider'); // Log if URL is empty
        }
      } else {
        print('Snapshot does not exist for $serviceProvider'); // Log if the snapshot does not exist
      }
    } catch (error) {
      print('Error fetching image URL: $error'); // Log any errors
    }

    return imageUrl; // Return the fetched image URL
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "My Bookings",
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator while fetching data
          : bookings.isNotEmpty
          ? ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];

          return GestureDetector(
            onTap: () {
              // Navigate to the detailed booking page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingDetailPage(
                    serviceProvider: booking['serviceProvider'] as String? ?? '',
                    selectedService: (booking['services'] as List<dynamic>?)
                        ?.map((service) => service['name'] as String?)
                        .where((name) => name != null) // Filter out null names
                        .join(", ") ?? '', // Join service names
                    serviceDate: booking['serviceDate'] as String? ?? '',
                    serviceTime: booking['serviceTime'] as String? ?? '',
                    totalCost: (booking['totalAmount'] as int?)?.toDouble() ?? 0.0, bookingTime: '', services: [],
                  ),
                ),
              );
            },
            child: BookingCard(
              serviceProvider: booking['serviceProvider'],
              bookingTime: booking['bookingTime'],
              serviceTime: booking['serviceTime'],
              totalCost: booking['totalAmount'].toDouble(),
              imageUrl: booking['imageUrl'], // Use the image URL from bookings
            ),
          );
        },
      )
          : Center(
        child: const Text(
          "No bookings yet",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final String serviceProvider;
  final String bookingTime;
  final String serviceTime;
  final double totalCost;
  final String imageUrl;

  BookingCard({
    required this.serviceProvider,
    required this.bookingTime,
    required this.serviceTime,
    required this.totalCost,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Service Provider: $serviceProvider',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('Booking Time: $bookingTime'),
                  SizedBox(height: 8),
                  Text('Service Time: $serviceTime'),
                  SizedBox(height: 8),
                  Text(
                    'Total Cost: ₹$totalCost',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                imageUrl.isEmpty ? 'https://via.placeholder.com/90' : imageUrl,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
