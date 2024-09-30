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

            bookingsList?.forEach((bookingID, bookingDetails) async {
              final booking = bookingDetails as Map<Object?, Object?>?;
              final servicesDetails =
                  booking != null && booking['servicesDetails'] is Map
                      ? booking['servicesDetails'] as Map
                      : null;
              final cost = booking != null && booking['cost'] is Map
                  ? booking['cost'] as Map
                  : null;

              if (servicesDetails != null && cost != null) {
                final services =
                    servicesDetails['services'] as List<dynamic>? ?? [];
                final serviceTime =
                    servicesDetails['serviceTime'] as String? ?? "N/A";
                final serviceDate =
                    servicesDetails['serviceDate'] as String? ?? "N/A";
                final totalAmount = cost['totalAmount'] as int? ?? 0;
                final bookingTime = booking?['bookingTime'] as String? ?? "N/A";
                final serviceProvider =
                    booking?['service_provider'] as String? ?? "Unknown";

                // Fetch the image URL from Firebase asynchronously
                String imageUrl = await _getImageUrl(serviceProvider);

                if (services.isNotEmpty &&
                    totalAmount > 0 &&
                    bookingTime.isNotEmpty) {
                  setState(() {
                    allBookings.add({
                      'bookingTime': bookingTime,
                      'totalAmount': totalAmount,
                      'serviceTime': serviceTime,
                      'serviceDate': serviceDate,
                      'services': services,
                      'serviceProvider': serviceProvider,
                      'imageUrl': imageUrl, // Store the image URL directly
                    });
                  });
                }
              }
            });
          });

          setState(() {
            isLoading = false; // Data fetched, stop loading
          });
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

  Future<String> _getImageUrl(String? serviceProvider) async {
    if (serviceProvider == null || serviceProvider.isEmpty) {
      print('Service provider is null or empty');
      return ""; // Handle null service provider
    }

    final databaseRef =
        FirebaseDatabase.instance.ref('assets/images/$serviceProvider');
    String imageUrl = "";

    try {
      final snapshot = await databaseRef.get();
      print('Fetching data from:assets/images/$serviceProvider');
      if (snapshot.exists) {
        final data = snapshot.value as Map<Object?, Object?>?;
        imageUrl = data?['url'] as String? ?? "";
        if (imageUrl.isEmpty) {
          print('Image URL is empty for $serviceProvider');
        } else {
          print('Image URL found for $serviceProvider:$imageUrl');
        }
      } else {
        print(
            'No snapshot exists for $serviceProvider at path: assets/images/$serviceProvider');
      }
    } catch (error) {
      print('Error fetching image URL: $error');
    }

    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "Admin All Bookings",
      body: isLoading
          ? Center(
              child:
                  CircularProgressIndicator(), // Show loading indicator while fetching data
            )
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
                                  Text(
                                      'Booking Time: ${booking['bookingTime']}'),
                                  SizedBox(height: 8),
                                  Text(
                                      'Service Time: ${booking['serviceTime']}'),
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
                  child: Text(
                    "No bookings available",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
    );
  }
}
