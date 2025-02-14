import 'package:dh/Food/order_details_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';

class FoodBooking extends StatefulWidget {
  const FoodBooking({super.key});

  @override
  _FoodBookingState createState() => _FoodBookingState();
}

class _FoodBookingState extends State<FoodBooking> {
  List<Map<String, dynamic>> bookings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeSharedPreferences();
    _fetchBookedServices();
  }

  String userPhoneNumber = "0";
  String role = "admin";

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
    await Future.delayed(const Duration(seconds: 2));
    setState(() {});
  }

  Future<void> _fetchBookedServices() async {
    final prefs = await SharedPreferences.getInstance();
    final userPhoneNumber = prefs.getString('userPhoneNumber');
    DatabaseReference databaseRef =
        FirebaseDatabase.instance.ref('foodOrders/$userPhoneNumber');

    if (userPhoneNumber != null) {
      try {
        final snapshot = await databaseRef.get();
        if (snapshot.exists) {
          final data = snapshot.value as Map<Object?, Object?>?;

          if (data != null) {
            bookings.clear();

            for (var entry in data.entries) {
              final booking = entry.value as Map<Object?, Object?>?;
              if (booking != null) {
                // Extract booking details
                final orderTime = booking['orderTime'] as String?;
                final totalCost = (booking['totalCost'] is int)
                    ? (booking['totalCost'] as int).toDouble()
                    : booking['totalCost'] as double?;
                final deliveryDate = booking['deliveryDate'] as String?;
                final deliveryTime = booking['deliveryTime'] as String?;
                final items = booking['orderDetails'] as List<dynamic>?;
                final orderStatus = booking['status'] as String?;
                // final orderStatus = '2' as String?;
                final gstAmount = (booking['gstAmount'] is int)
                    ? (booking['gstAmount'] as int).toDouble()
                    : booking['gstAmount'] as double?;
                final orderCount = booking['count'] as int?;

                if (orderTime != null &&
                    totalCost != null &&
                    orderCount != null) {
                  bookings.add({
                    'orderTime': orderTime,
                    'totalCost': totalCost,
                    'deliveryDate': deliveryDate,
                    'deliveryTime': deliveryTime,
                    'items': items,
                    'gstAmount': gstAmount,
                    'grandTotal': (booking['grandTotal'] is int)
                        ? (booking['grandTotal'] as int).toDouble()
                        : booking['grandTotal'] as double?,
                    'status': orderStatus,
                    'count': orderCount,
                  });
                }
              }
            }
            bookings.sort(
                (a, b) => (b['count'] as int).compareTo(a['count'] as int));

            // bookings.sort((a, b) {
            //   DateTime? aTime = a['deliveryDateTime'] as DateTime?;
            //   DateTime? bTime = b['deliveryDateTime'] as DateTime?;
            //   if (aTime == null && bTime == null) return 0;
            //   if (aTime == null) return 1; // Place nulls at the bottom
            //   if (bTime == null) return -1;
            //   return aTime.difference(DateTime.now()).compareTo(bTime.difference(DateTime.now()));
            // });
            setState(() {
              isLoading = false;
            });
          } else {
            setState(() {
              bookings = [];
              isLoading = false;
            });
          }
        } else {
          setState(() {
            bookings = [];
            isLoading = false;
          });
        }
      } catch (error) {
        print('Error fetching data: $error');
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

  Future<void> _refreshPage() async {
    await _initializeSharedPreferences();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Page Refreshed"),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case '1':
        return Colors.blue; // Order Placed
      case '2':
        return Colors.orange; // In the Kitchen
      case '3':
        return Colors.brown; // On the Way
      case '4':
        return Colors.green; // Delivered
      default:
        return Colors.grey; // Unknown status
    }
  }

  String _getStatusText(String? status) {
    switch (status) {
      case '1':
        return 'Order Placed';
      case '2':
        return 'In the Kitchen';
      case '3':
        return 'On the Way';
      case '4':
        return 'Delivered';
      default:
        return 'Unknown Status';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : bookings.isNotEmpty
                ? ListView.builder(
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      final order = bookings[index];
                      return OrderCard(
                        orderTime: order['orderTime'] as String? ?? '',
                        totalCost: order['totalCost'] as double? ?? 0.0,
                        gstAmount: order['gstAmount'] as double? ?? 0.0,
                        grandTotal: order['grandTotal'] as double? ?? 0.0,
                        deliveryDate: order['deliveryDate'] as String? ?? '',
                        deliveryTime: order['deliveryTime'] as String? ?? '',
                        orderDetails: order['items'] as List<dynamic>? ?? [],
                        status: _getStatusText(order['status'] as String? ??
                            ''), // Pass status text
                        statusColor: _getStatusColor(
                            order['status'] as String? ??
                                ''), // Pass status color
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      "No orders yet",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final String orderTime;
  final double totalCost;
  final double gstAmount;
  final double grandTotal;
  final String deliveryDate;
  final String deliveryTime;
  final List<dynamic> orderDetails;
  final String status;
  final Color statusColor;

  const OrderCard({
    super.key,
    required this.orderTime,
    required this.totalCost,
    required this.gstAmount,
    required this.grandTotal,
    required this.deliveryDate,
    required this.deliveryTime,
    required this.orderDetails,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    // Number formatting for currency
    final currencyFormat =
        NumberFormat.currency(locale: 'en_IN', symbol: 'Rs ', decimalDigits: 2);

    return GestureDetector(
      onTap: () {
        // Navigate to order details page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailsPage(
              orderTime: orderTime,
              deliveryDate: deliveryDate,
              deliveryTime: deliveryTime,
              orderDetails: orderDetails,
              gstAmount: gstAmount,
              grandTotal: grandTotal,
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order Time: $orderTime',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text('Delivery Date: $deliveryDate',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text('Delivery Time: $deliveryTime',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text(
                'Grand Total: ${currencyFormat.format(grandTotal)}',
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Status: $status',
                    style: TextStyle(color: statusColor, fontSize: 16),
                  ),
                  const Icon(Icons.arrow_forward, color: Colors.grey),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
