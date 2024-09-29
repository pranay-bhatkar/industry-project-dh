import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../basescaffold.dart';

class AdminAllBooking extends StatefulWidget {
  @override
  _AdminAllBookingState createState() => _AdminAllBookingState();
}

class _AdminAllBookingState extends State<AdminAllBooking> {
  List<Map<String, dynamic>> allBookings = []; // List to store all bookings
  bool isLoading = true; // Flag to show loading indicator

  @override
  void initState() {
    super.initState();
    _fetchAllBookings();
  }

  Future<void> _fetchAllBookings() async {
    final databaseRef = FirebaseDatabase.instance.ref('serviceBooking');

    try {
      final snapshot = await databaseRef.get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<Object?, Object?>?;
        if (data != null) {
          allBookings.clear(); // Clear previous data before adding new entries

          // Loop through each booking entry
          data.forEach((userPhoneNumber, bookingsData) {
            final bookingsList = bookingsData as Map<Object?, Object?>?;

            bookingsList?.forEach((bookingID, bookingDetails) {
              final booking = bookingDetails as Map<Object?, Object?>?;
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
                String imageUrl = _getImageUrl(serviceProvider);

                if (services != null && totalAmount != null && bookingTime != null) {
                  allBookings.add({
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
            });
          });

          setState(() {
            isLoading = false; // Data fetched, stop loading
          });

          // Log the bookings for debugging
          print("All Bookings: $allBookings");
        } else {
          setState(() {
            allBookings = [];
            isLoading = false; // No data found, stop loading
          });
        }
      } else {
        setState(() {
          allBookings = [];
          isLoading = false; // No data found, stop loading
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false; // Stop loading on error
      });
      print('Error fetching data: $error');
    }
  }

  // Method to get the image URL based on service provider name
  String _getImageUrl(String? serviceProvider) {
    if (serviceProvider == null) return ""; // Handle null service provider

    String imageUrl = "";
    final databaseRef = FirebaseDatabase.instance.ref('assets/images/$serviceProvider');

    databaseRef.get().then((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.value as Map<Object?, Object?>?;
        imageUrl = data?['url'] as String? ?? ""; // Access the URL
        if (imageUrl.isEmpty) {
          print('Image URL is empty for $serviceProvider'); // Log if URL is empty
        }
      } else {
        print('Snapshot does not exist for $serviceProvider'); // Log if the snapshot does not exist
      }
    }).catchError((error) {
      print('Error fetching image URL: $error'); // Log any errors
    });

    return imageUrl; // Return the fetched image URL
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "Admin All Bookings",
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator while fetching data
          : allBookings.isNotEmpty
          ? ListView.builder(
        itemCount: allBookings.length,
        itemBuilder: (context, index) {
          final booking = allBookings[index];

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
                          'Service Provider: ${booking['serviceProvider']}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('Booking Time: ${booking['bookingTime']}'),
                        SizedBox(height: 8),
                        Text('Service Time: ${booking['serviceTime']}'),
                        SizedBox(height: 8),
                        Text(
                          'Total Cost: ₹${booking['totalAmount']}',
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
                      booking['imageUrl'].isEmpty
                          ? 'https://via.placeholder.com/90'
                          : booking['imageUrl'],
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      )
          : Center(
        child: const Text(
          "No bookings available",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}
