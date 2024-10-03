import 'package:flutter/material.dart';

class FoodBillSummeryPage extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final String bookingDateTime;

  FoodBillSummeryPage({required this.cartItems, required this.bookingDateTime});

  @override
  Widget build(BuildContext context) {
    double totalCost = 0;
    cartItems.forEach((item) {
      totalCost +=
          double.parse(item['price'].replaceAll('₹ ', '')) * item['quantity'];
    });

    // Calculate GST (for example, at 5%)
    double gst = totalCost * 0.05;
    double grandTotal = totalCost + gst;

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Booking Date: ${bookingDateTime.split(" ")[0]}', // Only date
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Booking Time: ${bookingDateTime.split(" ")[1]}', // Only time
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
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
                        'Total: ₹${(double.parse(item['price'].replaceAll('₹ ', '')) * item['quantity']).toStringAsFixed(2)}'),
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
                    'GST (5%):',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '₹${gst.toStringAsFixed(2)}',
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
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Proceed to Payment or Confirmation
                    Navigator.pop(context);
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
            ),
          ],
        ),
      ),
    );
  }
}
