import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetailsPage extends StatefulWidget {
  final String orderTime;
  final String deliveryDate;
  final String deliveryTime;
  final List<dynamic> orderDetails;
  final double gstAmount;
  final double grandTotal;

  const OrderDetailsPage({
    super.key,
    required this.orderTime,
    required this.deliveryDate,
    required this.deliveryTime,
    required this.orderDetails,
    required this.gstAmount,
    required this.grandTotal,
  });

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final DatabaseReference _foodBookingsRef =
      FirebaseDatabase.instance.ref('foodOrders');

  String userPhoneNumber = "0";
  String role = "admin";
  String status = "unknown Status";

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
    final snapshot = await _foodBookingsRef
        .child(userPhoneNumber)
        .child(widget.orderTime)
        .child('status')
        .once();

    if (snapshot.snapshot.value != null) {
      setState(() {
        status = snapshot.snapshot.value.toString();
      });
    } else {
      setState(() {
        status = "No status found";
      });
    }
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

  Future<void> _refreshPage() async {
    await _initializeSharedPreferences();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Page Refreshed"),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _updateStatus() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Refresh the page"),
      ),
    );
    _foodBookingsRef.child(userPhoneNumber).child(widget.orderTime).update({
      'status': '4',
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat =
        NumberFormat.currency(locale: 'en_IN', symbol: 'Rs ', decimalDigits: 2);
    double parsePrice(String price) {
      // Remove "Rs " prefix and any non-numeric characters
      return double.tryParse(price
              .replaceAll('Rs ', '')
              .replaceAll('-', '')
              .replaceAll(RegExp(r'[^\d.]'), '')) ??
          0.0;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order Time: ${widget.orderTime}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      Text('Delivery Date: ${widget.deliveryDate}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      Text('Delivery Time: ${widget.deliveryTime}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Order Summary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    )),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Qty',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('Item',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('Price',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Divider(thickness: 1, color: Colors.grey.shade500),
                      for (var item in widget.orderDetails)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${item['quantity']}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade800)),
                              Flexible(
                                child: Text(
                                  item['title'],
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade800),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(currencyFormat
                                  .format(parsePrice(item['price']))),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('GST Amount: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(currencyFormat.format(widget.gstAmount),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Grand Total: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          Text(currencyFormat.format(widget.grandTotal),
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text('Status: ${_getStatusText(status)}',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: _getStatusColor(status))),
                ),
                const SizedBox(height: 16), // Add spacing
                Center(
                  child: ElevatedButton(
                    onPressed:
                        _updateStatus, // Call _updateStatus when button is pressed
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 40.0),
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      "Food Delivered",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
