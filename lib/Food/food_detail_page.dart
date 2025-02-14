import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FoodDetailPage extends StatelessWidget {
  final String orderTime;
  final String deliveryDate;
  final String deliveryTime;
  final List<dynamic> orderDetails;
  final double gstAmount;
  final double grandTotal;
  final String status;

  const FoodDetailPage({super.key, 
    required this.orderTime,
    required this.deliveryDate,
    required this.deliveryTime,
    required this.orderDetails,
    required this.gstAmount,
    required this.grandTotal,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    // Number formatting for currency
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
        title: const Text('Order Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Time: $orderTime', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Delivery Date: $deliveryDate',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Delivery Time: $deliveryTime',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Qty', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Item', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Price', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            for (var item in orderDetails)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${item['quantity']}', style: const TextStyle(fontSize: 14)),
                    Flexible(
                      child: Text(
                        item['title'],
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(currencyFormat.format(parsePrice(item['price'])),
                        style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            const SizedBox(height: 8),
            // GST and Grand Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('GST Amount:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(currencyFormat.format(gstAmount),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Grand Total:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(currencyFormat.format(grandTotal),
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
              ],
            ),
            const SizedBox(height: 16),
            Text('Status: $status', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
