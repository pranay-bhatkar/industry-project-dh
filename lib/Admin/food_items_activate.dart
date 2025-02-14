import 'package:dh/Navigation/basescaffold.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class FoodItemsActivate extends StatefulWidget {
  const FoodItemsActivate({super.key});

  @override
  State<FoodItemsActivate> createState() => _FoodItemsActivateState();
}

class _FoodItemsActivateState extends State<FoodItemsActivate> {
  final DatabaseReference _foodItemsActivation =
  FirebaseDatabase.instance.ref('food').child('foodlist');

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "Active Food Items",
      body: FirebaseAnimatedList(
        query: _foodItemsActivation,
        itemBuilder: (context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          Map<dynamic, dynamic>? foodItem =
          snapshot.value as Map<dynamic, dynamic>?;

          if (foodItem == null) {
            return const Center(
              child: Text(
                "No data available",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          bool isActivated = (foodItem['activate'] ?? 'no') == 'yes';

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                contentPadding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                leading: CircleAvatar(
                  backgroundColor: Colors.orangeAccent,
                  child: Text(
                    foodItem['id']?.substring(0, 1).toUpperCase() ?? 'F',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  foodItem['name'] ?? 'Unknown Item',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4.0),
                    Text(
                      'Price: ₹${foodItem['price'] ?? '0'}',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Activate:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Checkbox(
                      value: isActivated,
                      onChanged: (bool? value) {
                        setState(() {
                          // Update the value in the database
                          _foodItemsActivation
                              .child(snapshot.key ?? '')
                              .update({'activate': value == true ? 'yes' : 'no'});
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
