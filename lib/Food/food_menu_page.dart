import 'package:dh/basescaffold.dart';
import 'package:flutter/material.dart';

class FoodMenuPage extends StatefulWidget {
  @override
  _FoodMenuPageState createState() => _FoodMenuPageState();
}

class _FoodMenuPageState extends State<FoodMenuPage> {
  final List<Map<String, dynamic>> menuItems = [
    {
      'title': 'Caesar Salad',
      'description': 'Fresh romaine lettuce with...',
      'price': '\₹ 8.99',
      'imagePath':
          'https://firebasestorage.googleapis.com/v0/b/doodleshomes-7ffe2.appspot.com/o/images%2Fcaesarsalad.png?alt=media&token=7489dc2a-6cde-4a48-95c7-86b8857e6bfe',
    },
    {
      'title': 'Grilled Salmon',
      'description': 'Perfectly grilled salmon with...',
      'price': '\₹ 15.99',
      'imagePath':
          'https://firebasestorage.googleapis.com/v0/b/doodleshomes-7ffe2.appspot.com/o/images%2Fgrilledsalmon.png?alt=media&token=33932dcf-a20a-41d8-8776-94791842cbed',
    },
    {
      'title': 'Chocolate Cake',
      'description': 'Rich and moist chocolate...',
      'price': '\₹ 6.99',
      'imagePath':
          'https://firebasestorage.googleapis.com/v0/b/doodleshomes-7ffe2.appspot.com/o/images%2Fchocolatecake.png?alt=media&token=3ebe7ac1-a772-439b-a08e-3e8646108620',
    },
    {
      'title': 'Mojito',
      'description': 'Classic mojito with fresh mint...',
      'price': '\₹ 5.99',
      'imagePath':
          'https://firebasestorage.googleapis.com/v0/b/doodleshomes-7ffe2.appspot.com/o/images%2Fmojito.png?alt=media&token=7e1f00fb-e3c2-4385-b0cc-034cec26d156',
    },
  ];

  List<Map<String, dynamic>> filteredMenuItems =
      []; // List to hold filtered items
  List<Map<String, dynamic>> cartItems = []; // List to hold cart items
  TextEditingController _searchController =
      TextEditingController(); // Controller for search input

  @override
  void initState() {
    super.initState();
    // Initially, the filtered list contains all menu items
    filteredMenuItems = List.from(menuItems);
  }

  // Function to filter menu items based on the search query
  void _filterMenuItems(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredMenuItems = List.from(menuItems);
      });
    } else {
      setState(() {
        filteredMenuItems = menuItems.where((item) {
          return item['title'].toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  // Cart Page
  Widget _cartPage() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        backgroundColor: Colors.redAccent,
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Text(
                'Your cart is empty.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ) // Message when cart is empty
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Dismissible(
                  key: Key(
                      '${item['title']}_₹index'), // Unique key for each item
                  direction: DismissDirection.startToEnd, // Swipe to the right
                  onDismissed: (direction) {
                    final removedItem =
                        cartItems[index]; // Store the removed item
                    setState(() {
                      cartItems.removeAt(index); // Remove item from cart
                    });

                    // Show a SnackBar to confirm removal
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('${removedItem['title']} removed from cart!'),
                        duration: Duration(seconds: 2),
                      ),
                    );

                    // Check if the cart is empty after removal
                    if (cartItems.isEmpty) {
                      Center(
                        child: Text("Your Cart is empty."),
                      );
                    }
                  },
                  background: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.redAccent,
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  child: Card(
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item['title'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${item['price']} x ${item['quantity']}', // Updated line
                            style: TextStyle(color: Colors.green),
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

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "Food Menu",
      appBarActions: IconButton(
        icon: Icon(Icons.shopping_cart),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => _cartPage()),
          );
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged:
                  _filterMenuItems, // Call the filter function on text change
              decoration: InputDecoration(
                hintText: 'Search for dishes...',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredMenuItems.length,
              itemBuilder: (context, index) {
                final item = filteredMenuItems[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(
                              20.0), // Adjust the radius as needed
                        ),
                        child: Container(
                          height: 150, // Adjust the height as needed
                          child: Image.network(
                            item['imagePath'],
                            fit: BoxFit.cover, // Cover the entire container
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          item['title'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['description']),
                            SizedBox(height: 5),
                            Text(
                              item['price'],
                              style: TextStyle(color: Colors.green),
                            ),
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              // Check if item already exists in the cart
                              bool exists = false;
                              for (var cartItem in cartItems) {
                                if (cartItem['title'] == item['title']) {
                                  exists = true;
                                  cartItem[
                                      'quantity']++; // Increase the quantity
                                  break;
                                }
                              }
                              if (!exists) {
                                // Add new item to cart with quantity
                                cartItems.add({
                                  ...item,
                                  'quantity': 1,
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('${item['title']} added to cart!'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        '${item['title']} quantity increased!'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            });
                          },
                          child: Text('Add to Cart'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
