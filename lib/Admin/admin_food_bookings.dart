import 'package:dh/Admin/order_details_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminFoodBookings extends StatefulWidget {
  const AdminFoodBookings({super.key});

  @override
  State<AdminFoodBookings> createState() => _AdminFoodBookingsState();
}

class _AdminFoodBookingsState extends State<AdminFoodBookings> {
  final DatabaseReference _foodBookingsRef =
  FirebaseDatabase.instance.ref('foodOrders');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FirebaseAnimatedList(
        query: _foodBookingsRef,
        itemBuilder: (context, snapshot, animation, index) {
          if (snapshot.value != null) {
            final data = Map<String, dynamic>.from(snapshot.value as Map);

            // Filter and sort data based on delivery date and time
            final sortedEntries = data.entries
                .where((entry) {
              final entryData = Map<String, dynamic>.from(entry.value as Map);

              // Parse delivery date and time
              final deliveryDateTime = _parseDateTime(
                entryData['deliveryDate'] ?? '',
                entryData['deliveryTime'] ?? '',
              );

              // Filter for dates after the current time
              return deliveryDateTime.isAfter(DateTime.now());
            })
                .toList()
              ..sort((a, b) {
                final aData = Map<String, dynamic>.from(a.value as Map);
                final bData = Map<String, dynamic>.from(b.value as Map);

                // Parse delivery date and time for comparison
                final aDateTime = _parseDateTime(
                  aData['deliveryDate'] ?? '',
                  aData['deliveryTime'] ?? '',
                );
                final bDateTime = _parseDateTime(
                  bData['deliveryDate'] ?? '',
                  bData['deliveryTime'] ?? '',
                );

                // Sort by closest to current time
                return aDateTime.compareTo(bDateTime);
              });

            // Build the UI
            return Column(
              children: sortedEntries.map((entry) {
                final orderId = entry.key;
                final orderData = Map<String, dynamic>.from(entry.value as Map);

                final orderTime = orderData['orderTime'] ?? '';
                final deliveryDate = orderData['deliveryDate'] ?? '';
                final deliveryTime = orderData['deliveryTime'] ?? '';
                final totalCost = orderData['totalCost'] ?? 0.0;
                final status = orderData['status'] ?? '';
                final villaName = orderData['villaName'] ?? '';

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailsPage(
                          orderId: orderId,
                          orderData: orderData,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.all(8.0),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Order Time: $orderTime',
                                  style: const TextStyle(fontSize: 16)),
                              Text('Delivery Date: $deliveryDate',
                                  style: const TextStyle(fontSize: 16)),
                              Text('Delivery Time: $deliveryTime',
                                  style: const TextStyle(fontSize: 16)),
                              Text('Total Cost: ₹$totalCost',
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold)),
                              Row(
                                children: [
                                  Text('Status: $status',
                                      style: const TextStyle(fontSize: 16)),
                                  const SizedBox(width: 50,),
                                  Text('Diliver On :- $villaName',
                                      style: const TextStyle(fontSize: 16)),
                                ],
                              ),
                            ],
                          ),
                          const Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }
          return const SizedBox(); // Return empty widget if no data
        },
      ),
    );
  }

  /// Helper function to parse delivery date and time into a `DateTime` object
  DateTime _parseDateTime(String date, String time) {
    try {
      // Combine date and time into a single DateTime object
      final format = DateFormat("yyyy-MM-dd hh:mm a");
      return format.parse('$date $time');
    } catch (e) {
      // Return a far future date if parsing fails
      return DateTime(9999, 12, 31);
    }
  }
}
