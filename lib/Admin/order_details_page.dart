import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class OrderDetailsPage extends StatefulWidget {
  final String orderId;
  final Map<String, dynamic> orderData;

  const OrderDetailsPage({
    super.key,
    required this.orderId,
    required this.orderData,
  });

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final DatabaseReference _foodBookingsRef = FirebaseDatabase.instance.ref('foodOrders');

  // Track the status locally
  late String status;

  @override
  void initState() {
    super.initState();
    status = widget.orderData['status'] ?? '1'; // Initialize with current status
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
  void _updateStatus() {
    int currentStatus = int.tryParse(status) ?? 1;
    if (currentStatus < 3) {
      currentStatus++;
    } else {
      currentStatus = 1;
    }
    setState(() {
      status = currentStatus.toString();
    });

    _foodBookingsRef.child("1234567899").child(widget.orderData['orderTime']).update({
      'status': status,
    });
  }

  @override
  Widget build(BuildContext context) {
    final gstAmount = widget.orderData['gstAmount'] ?? 0.0;
    final orderTime = widget.orderData['orderTime'] ?? '';
    final totalCost = widget.orderData['totalCost'] ?? 0.0;
    final deliveryDate = widget.orderData['deliveryDate'] ?? '';
    final deliveryTime = widget.orderData['deliveryTime'] ?? '';
    final villaName = widget.orderData['villaName'] ?? '';
    final orderDetails = widget.orderData['orderDetails'] as List<dynamic>? ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details - ${widget.orderId}'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card for order information
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Time: $orderTime',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Delivery Date: $deliveryDate',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Delivery Time: $deliveryTime',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Deliver On :- $villaName',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'GST Amount: ₹${gstAmount.toStringAsFixed(3)}',
                      style: const TextStyle(fontSize: 16, color: Colors.green),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Status: ${_getStatusText(status)}',
                      style: TextStyle(
                        fontSize: 16,
                        color: _getStatusColor(status), // Dynamically set color based on status
                      ),
                    ),
                    const Divider(),
                    Text(
                      'Total Cost: $totalCost',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              'Order Details:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Display list of order items
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orderDetails.length,
              itemBuilder: (context, index) {
                final itemDetails = Map<String, dynamic>.from(orderDetails[index] as Map);
                final title = itemDetails['title'] ?? 'N/A';
                final quantity = itemDetails['quantity'] ?? 0;
                final price = itemDetails['price'] ?? 0.0;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Quantity: $quantity',
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                        Text(
                          '$price',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16), // Add spacing
            Center(
              child: ElevatedButton(
                onPressed: _updateStatus, // Call _updateStatus when button is pressed
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 40.0),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  "Next",
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
    );
  }
}
