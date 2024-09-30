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
  List<Map<String, dynamic>> bookings =
      []; // List to store all bookings with details
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
      final databaseRef =
          FirebaseDatabase.instance.ref('serviceBooking/$userPhoneNumber');
      try {
        final snapshot = await databaseRef.get();
        if (snapshot.exists) {
          final data = snapshot.value as Map<Object?, Object?>?;
          if (data != null) {
            bookings.clear();
            await _processBookings(data);
          }
        }
      } catch (error) {
        _handleFetchError(error);
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _processBookings(Map<Object?, Object?> data) async {
    for (var entry in data.entries) {
      final bookingID = entry.key;
      final booking = entry.value as Map<Object?, Object?>?;

      // Check if booking is null before processing it
      if (booking != null) {
        String serviceProvider =
            booking['service_provider'] as String? ?? 'Unknown';

        // Fetch the image URL for the service provider, defaulting to a placeholder if necessary
        String imageUrl = await _getImageUrl(serviceProvider);

        // Safely add the booking data to the list
        bookings.add({
          'serviceProvider': serviceProvider,
          'bookingTime': booking['bookingTime'] as String? ?? 'Not specified',
          'serviceTime': booking['serviceTime'] as String? ?? 'Not specified',
          'totalAmount': booking['totalAmount'] as int? ?? 0,
          'imageUrl': imageUrl,
          'services': booking['services'] as List<dynamic>? ?? [],
          'serviceDate': booking['serviceDate'] as String? ?? 'Not specified',
        });
      }
    }
  }

  void _handleFetchError(error) {
    print('Error fetching data: $error');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error fetching bookings')),
    );
  }

  // Method to get the image URL based on service provider name
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
      title: "My Bookings",
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : bookings.isNotEmpty
              ? ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingDetailPage(
                            serviceProvider:
                                booking['serviceProvider'] as String? ??
                                    'Unknown',
                            selectedService: (booking['services']
                                        as List<dynamic>?)
                                    ?.map((service) =>
                                        service['name'] as String? ?? 'Unknown')
                                    .join(", ") ??
                                'No services',
                            serviceDate: booking['serviceDate'] as String? ??
                                'Not specified',
                            serviceTime: booking['serviceTime'] as String? ??
                                'Not specified',
                            totalCost:
                                (booking['totalAmount'] as int?)?.toDouble() ??
                                    0.0,
                            bookingTime:
                                booking['bookingTime'] as String? ?? 'Unknown',
                            services: booking['services'] ?? [],
                          ),
                        ),
                      ),
                      child: BookingCard(
                        serviceProvider:
                            booking['serviceProvider'] as String? ?? 'Unknown',
                        bookingTime:
                            booking['bookingTime'] as String? ?? 'Unknown',
                        serviceTime:
                            booking['serviceTime'] as String? ?? 'Unknown',
                        totalCost:
                            (booking['totalAmount'] as int?)?.toDouble() ?? 0.0,
                        imageUrl: booking['imageUrl'] as String? ??
                            'https://via.placeholder.com/90',
                      ),
                    );
                  },
                )
              : Center(child: Text("No bookings yet")),
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
