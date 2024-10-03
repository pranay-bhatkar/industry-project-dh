import 'package:flutter/material.dart';

class FoodBillSummeryPage extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final String? bookingDateTime;
  final DateTime? date;
  final TimeOfDay? time;

  FoodBillSummeryPage({
    required this.cartItems,
    this.bookingDateTime,
    this.date,
    this.time,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize totalCost
    double totalCost = 0;

    // Check if cartItems is null or empty
    // if (cartItems == null || cartItems.isEmpty) {
    //   return Scaffold(
    //     appBar: AppBar(
    //       title: Text('Bill Summary'),
    //       backgroundColor: Colors.redAccent,
    //     ),
    //     body: Center(child: Text('No items in the cart')),
    //   );
    // }

    // Calculate totalCost only if cartItems is not null
    cartItems.forEach((item) {
      totalCost +=
          double.parse(item['price'].replaceAll('₹ ', '')) * item['quantity'];
    });

    // Calculate GST and grand total
    const double gstPercentage = 0.18; // 18%
    double gstAmount = totalCost * gstPercentage;
    double grandTotal = totalCost + gstAmount;

    // Build UI
    return Scaffold(
      appBar: AppBar(
        title: Text('Bill Summary'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking Date & Time:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              bookingDateTime ??
                  'Date and Time not selected', // Handle null bookingDateTime
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Ordered Items:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return ListTile(
                    title: Text(item['title']),
                    subtitle: Text('Quantity: ${item['quantity']}'),
                    trailing: Text(
                      'Total: ₹${(double.parse(item['price'].replaceAll('₹ ', '')) * item['quantity']).toStringAsFixed(2)}',
                    ),
                  );
                },
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Subtotal:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '₹${totalCost.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18, color: Colors.green),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'GST (18%):',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '₹${gstAmount.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18, color: Colors.green),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Grand Total:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '₹${grandTotal.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18, color: Colors.green),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity, // Make button full width
              child: ElevatedButton(
                onPressed: () {
                  // Show a confirmation dialog or navigate to payment
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Confirm Order'),
                      content:
                          Text('Are you sure you want to confirm this order?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                            Navigator.pop(
                                context); // Or navigate to payment screen
                          },
                          child: Text('Confirm'),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  textStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: Text('Confirm Order'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
