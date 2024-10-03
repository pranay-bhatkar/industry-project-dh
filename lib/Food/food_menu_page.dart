import 'package:dh/Food/food_bill_summery.dart';
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
      'description':
          'Fresh romaine lettuce with croutons and parmesan cheese tossed in Caesar dressing.',
      'price': '\₹ 8.99',
      'imagePath':
          'https://firebasestorage.googleapis.com/v0/b/doodleshomes-7ffe2.appspot.com/o/images%2Fcaesarsalad.png?alt=media&token=7489dc2a-6cde-4a48-95c7-86b8857e6bfe',
    },
    {
      'title': 'Grilled Salmon',
      'description':
          'Perfectly grilled salmon with lemon butter sauce, served with steamed vegetables.',
      'price': '\₹ 15.99',
      'imagePath':
          'https://firebasestorage.googleapis.com/v0/b/doodleshomes-7ffe2.appspot.com/o/images%2Fgrilledsalmon.png?alt=media&token=33932dcf-a20a-41d8-8776-94791842cbed',
    },
    {
      'title': 'Chocolate Cake',
      'description':
          'Rich and moist chocolate cake with a creamy ganache topping.',
      'price': '\₹ 6.99',
      'imagePath':
          'https://firebasestorage.googleapis.com/v0/b/doodleshomes-7ffe2.appspot.com/o/images%2Fchocolatecake.png?alt=media&token=3ebe7ac1-a772-439b-a08e-3e8646108620',
    },
    {
      'title': 'Mojito',
      'description': 'Classic mojito with fresh mint, lime, and soda water.',
      'price': '\₹ 5.99',
      'imagePath':
          'https://firebasestorage.googleapis.com/v0/b/doodleshomes-7ffe2.appspot.com/o/images%2Fmojito.png?alt=media&token=7e1f00fb-e3c2-4385-b0cc-034cec26d156',
    },
    {
      'title': 'Chocolate Cake',
      'description':
          'Rich and moist chocolate cake with a creamy ganache topping.',
      'price': '\₹ 6.99',
      'imagePath':
          'https://firebasestorage.googleapis.com/v0/b/doodleshomes-7ffe2.appspot.com/o/images%2Fchocolatecake.png?alt=media&token=3ebe7ac1-a772-439b-a08e-3e8646108620',
      'category': 'Dessert'
    },
    {
      'title': 'Mojito',
      'description': 'Classic mojito with fresh mint, lime, and soda water.',
      'price': '\₹ 5.99',
      'imagePath':
          'https://firebasestorage.googleapis.com/v0/b/doodleshomes-7ffe2.appspot.com/o/images%2Fmojito.png?alt=media&token=7e1f00fb-e3c2-4385-b0cc-034cec26d156',
      'category': 'Drink'
    },
    {
      'title': 'French Fries',
      'description':
          'Crispy golden fries, lightly salted and served with ketchup.',
      'price': '\₹ 3.99',
      'imagePath':
          'https://firebasestorage.googleapis.com/v0/b/doodleshomes-7ffe2.appspot.com/o/images%2Ffrenchfries.png?alt=media&token=4a5b843f-9194-4e93-b2bc-f5b00f6a612d',
      'category': 'Snack'
    },
    {
      'title': 'Cheesecake',
      'description': 'Creamy cheesecake with a buttery graham cracker crust.',
      'price': '\₹ 7.99',
      'imagePath':
          'https://firebasestorage.googleapis.com/v0/b/doodleshomes-7ffe2.appspot.com/o/images%2Fcheesecake.png?alt=media&token=cc9f42a7-ebe4-42ba-abe0-2fc7e5f6c4f7',
      'category': 'Dessert'
    },
    {
      'title': 'Hot Chocolate',
      'description': 'Rich, velvety hot chocolate topped with whipped cream.',
      'price': '\₹ 4.50',
      'imagePath':
          'https://firebasestorage.googleapis.com/v0/b/doodleshomes-7ffe2.appspot.com/o/images%2Fhotchocolate.png?alt=media&token=a0e2a613-5f77-45e6-99ec-455c60e5cfa6',
      'category': 'Drink'
    },
    {
      'title': 'Churros',
      'description':
          'Warm, crispy churros dusted with cinnamon sugar and served with chocolate sauce.',
      'price': '\₹ 5.50',
      'imagePath':
          'https://firebasestorage.googleapis.com/v0/b/doodleshomes-7ffe2.appspot.com/o/images%2Fchurros.png?alt=media&token=4c3a5ae4-f1f4-45c4-92df-d67f8b9e5d2c',
      'category': 'Snack'
    },
    {
      'title': 'Strawberry Milkshake',
      'description':
          'Creamy milkshake made with fresh strawberries and ice cream.',
      'price': '\₹ 6.50',
      'imagePath':
          'https://firebasestorage.googleapis.com/v0/b/doodleshomes-7ffe2.appspot.com/o/images%2Fstrawberrymilkshake.png?alt=media&token=f1d8b5dc-6bc2-43f9-b9d4-5697b2a9cc4f',
      'category': 'Drink'
    },
    {
      'title': 'Nachos',
      'description':
          'Tortilla chips topped with melted cheese, jalapeños, and salsa.',
      'price': '\₹ 7.99',
      'imagePath':
          'https://firebasestorage.googleapis.com/v0/b/doodleshomes-7ffe2.appspot.com/o/images%2Fnachos.png?alt=media&token=a19d9342-9e35-464f-98b4-4eb2ab3c45f1',
      'category': 'Snack'
    },
    {
      'title': 'Apple Pie',
      'description':
          'Classic apple pie with a flaky crust, served with vanilla ice cream.',
      'price': '\₹ 6.99',
      'imagePath':
          'https://firebasestorage.googleapis.com/v0/b/doodleshomes-7ffe2.appspot.com/o/images%2Fapplepie.png?alt=media&token=c52a9d49-0462-4fb2-86f6-133d5b4e129f',
      'category': 'Dessert'
    },
  ];

  List<Map<String, dynamic>> filteredMenuItems = [];
  List<Map<String, dynamic>> cartItems = [];
  TextEditingController _searchController = TextEditingController();
  Map<String, bool> _expandedState = {}; // Expanded state for each item
  bool isCartActive = false; // Track if cart has items

  final List<String> categories = [
    'All',
    'Dessert',
    'Drink',
    'Snack',
  ];
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    filteredMenuItems = List.from(menuItems);
  }

  @override
  void dispose() {
    _searchController.dispose(); // Dispose of the controller
    super.dispose();
  }

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

  int _getCartItemQuantity(String title) {
    final item = cartItems.firstWhere((cartItem) => cartItem['title'] == title,
        orElse: () => {} // Return an empty map if no matching item is found
        );
    return item.isNotEmpty
        ? item['quantity']
        : 0; // Check if the item is not empty
  }

  void _filterMenuItemsByCategory(String category) {
    if (category == 'All') {
      setState(() {
        filteredMenuItems = List.from(menuItems);
      });
    } else {
      setState(() {
        filteredMenuItems = menuItems.where((item) {
          // Modify the conditions according to your menuItems categories
          // Assuming you want to add a category key to each item
          return item['category'] == category; // Add category filtering logic
        }).toList();
      });
    }
  }

  Widget _buildCategorySlider() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          bool isSelected = selectedCategory == category;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = category; // Update selected category
                _filterMenuItemsByCategory(selectedCategory); // Filter items
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              margin: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.redAccent : Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _cartPage() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: cartItems.isEmpty
                ? Center(
                    child: Text(
                      'Your cart is empty.',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  )
                : ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 8.0,
                        ),
                        child: Dismissible(
                          key: Key('${item['title']}_$index'),
                          direction: DismissDirection.horizontal,
                          onDismissed: (direction) {
                            final removedItem = cartItems[index];
                            setState(() {
                              cartItems.removeAt(index);
                              isCartActive =
                                  cartItems.isNotEmpty; // Update isCartActive
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    '${removedItem['title']} removed from cart!'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          background: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                              color: Colors.redAccent,
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                          ),
                          child: Card(
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(item['title'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text('${item['price']} x ${item['quantity']}',
                                      style: TextStyle(color: Colors.green)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          // Add the "Proceed for Booking" button here
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FoodBillSummeryPage(
                              cartItems: cartItems,
                              bookingDateTime: '',
                            )),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  textStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: Text('Proceed for Booking'),
              ),
            ),
          ),
        ],
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
              context, MaterialPageRoute(builder: (context) => _cartPage()));
        },
      ),
      body: Column(
        children: [
          SizedBox(
            height: 8.0,
          ),
          _buildCategorySlider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterMenuItems,
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
                int quantity = _getCartItemQuantity(item['title']);

                return Card(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20.0)),
                        child: Container(
                          height: 150,
                          child: Image.network(
                            item['imagePath'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.error), // Error placeholder
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(child: CircularProgressIndicator());
                            },
                          ),
                        ),
                      ),
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item['title'],
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(item['price'],
                                style: TextStyle(color: Colors.green)),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDescription(
                                item['title'], item['description']),
                            SizedBox(height: 5),
                            quantity == 0
                                ? ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        cartItems.add({...item, 'quantity': 1});
                                        isCartActive = true; // Set cart active
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              '${item['title']} added to cart!'),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                    child: Text('Add to Cart'),
                                  )
                                : _buildQuantityControls(item),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          // Add the Book button here
          if (isCartActive)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => _cartPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                ),
                child: Text(
                  "View Cart",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          SizedBox(
            height: 16.0,
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(String title, String description) {
    bool isExpanded = _expandedState[title] ?? false;
    String displayText = isExpanded || description.length <= 50
        ? description
        : '${description.substring(0, 50)}...';
    return GestureDetector(
      onTap: () {
        setState(() {
          _expandedState[title] = !isExpanded;
        });
      },
      child: Text(
        displayText,
        style: TextStyle(color: Colors.grey[700]),
      ),
    );
  }

  Widget _buildQuantityControls(Map<String, dynamic> item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Quantity: ${_getCartItemQuantity(item['title'])}'),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                setState(() {
                  final index = cartItems.indexWhere(
                      (cartItem) => cartItem['title'] == item['title']);
                  if (index != -1) {
                    if (cartItems[index]['quantity'] > 1) {
                      cartItems[index]['quantity']--;
                    } else {
                      cartItems.removeAt(index);
                    }
                    isCartActive = cartItems.isNotEmpty; // Update cart status
                  }
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                setState(() {
                  final index = cartItems.indexWhere(
                      (cartItem) => cartItem['title'] == item['title']);
                  if (index != -1) {
                    cartItems[index]['quantity']++;
                  } else {
                    cartItems.add({...item, 'quantity': 1});
                  }
                  isCartActive = true; // Set cart active
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
