import 'package:dh/Food/food_date_time_picker_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../Navigation/basescaffold.dart';

class FoodMenuPage extends StatefulWidget {
  const FoodMenuPage({super.key});

  @override
  _FoodMenuPageState createState() => _FoodMenuPageState();
}

class _FoodMenuPageState extends State<FoodMenuPage> {
  final List<Map<String, dynamic>> menuItems = [];
  List<Map<String, dynamic>> filteredMenuItems = [];
  List<Map<String, dynamic>> cartItems = [];
  final TextEditingController _searchController = TextEditingController();
  final Map<String, bool> _expandedState = {}; // Expanded state for each item
  bool isCartActive = false; // Track if cart has items
  bool isLoading = true; // Track loading state
  bool isCategoriesLoading = true; // Track loading state for categories

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  List<Map<String, dynamic>> categories = []; // Store dynamic categories
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _fetchCategories(); // Fetch food categories when the page initializes
    _fetchMenuItems(); // Fetch food items when the page initializes
  }

  @override
  void dispose() {
    _searchController.dispose(); // Dispose of the controller
    super.dispose();
  }

  Future<void> _fetchCategories() async {
    final databaseRef = FirebaseDatabase.instance.ref('food/categories');
    try {
      final snapshot = await databaseRef.get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<Object?, Object?>?;
        if (data != null) {
          categories.clear(); // Clear previous data
          data.forEach((key, value) {
            final category = value as Map<Object?, Object?>?;
            if (category != null) {
              categories.add({
                'key': key, // Store the internal key
                'name': category['name'], // User-friendly name
                'description': category['description'],
                'imagePath': category['image'],
              });
            }
          });
        }
      }
    } catch (error) {
      print('Error fetching categories: $error');
    } finally {
      setState(() {
        isCategoriesLoading = false; // Stop loading
      });
    }
  }

  Widget _buildCategorySlider() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = 'All';
                _filterMenuItemsByCategory(selectedCategory);
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                gradient: selectedCategory == 'All'
                    ? const LinearGradient(colors: [Colors.green, Colors.teal])
                    : null,
                color: selectedCategory == 'All' ? null : Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
                boxShadow: selectedCategory == 'All'
                    ? [BoxShadow(color: Colors.green.shade900, blurRadius: 5)]
                    : [],
              ),
              child: Text(
                'All',
                style: TextStyle(
                  color:
                      selectedCategory == 'All' ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (isCategoriesLoading)
            const CircularProgressIndicator()
          else
            ...categories.map((category) {
              bool isSelected = selectedCategory == category['name'];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCategory = category['name'];
                    _filterMenuItemsByCategory(category['key']);
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                            colors: [Colors.orange, Colors.redAccent])
                        : null,
                    color: isSelected ? null : Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                                color: Colors.orange.shade900, blurRadius: 5)
                          ]
                        : [],
                  ),
                  child: Text(
                    category['name'],
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  Future<void> _fetchMenuItems() async {
    final databaseRef = FirebaseDatabase.instance.ref('food/foodlist');
    try {
      final snapshot = await databaseRef.get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<Object?, Object?>?;
        if (data != null) {
          menuItems.clear(); // Clear previous data
          data.forEach((key, value) {
            final item = value as Map<Object?, Object?>?;
            if (item != null) {
              if (item['activate'] == "yes") {
                menuItems.add({
                  'title': item['name'],
                  'description': item['description'] ?? 'Delicious food item.',
                  'price': '₹ ${item['price']}',
                  'imagePath':
                      'https://firebasestorage.googleapis.com/v0/b/doodleshomes-7ffe2.appspot.com/o/images%2Fcaesarsalad.png?alt=media&token=7489dc2a-6cde-4a48-95c7-86b8857e6bfe',
                  'category': '${item['categoryId']}'
                });
              }
            }
          });
          filteredMenuItems = List.from(menuItems); // Initialize filtered items
        }
      }
    } catch (error) {
      print('Error fetching menu items: $error');
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
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
          return item['category'] == category;
        }).toList();
      });
    }
  }

  Widget _cartPage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: cartItems.isEmpty
                ? const Center(
                    child: Text(
                      'Your cart is empty.',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12.0),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Dismissible(
                          key: Key('${item['title']}_$index'),
                          direction: DismissDirection.horizontal,
                          onDismissed: (direction) {
                            final removedItem = cartItems[index];
                            setState(() {
                              cartItems.removeAt(index);
                              isCartActive = cartItems.isNotEmpty;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    '${removedItem['title']} removed from cart!'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          background: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                              color: Colors.green,
                              alignment: Alignment.centerLeft,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                          ),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            elevation: 3,
                            shadowColor: Colors.greenAccent,
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(12.0),
                              title: Text(
                                item['title'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              trailing: Text(
                                '${item['price']} x ${item['quantity']}',
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (cartItems.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Your cart is empty! Add items to proceed.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DateTimePickerPage(cartItems: cartItems),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  backgroundColor: Colors.green,
                  elevation: 5,
                ),
                child: const Text(
                  "Proceed for Booking",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
        icon: const Icon(Icons.shopping_cart),
        color: Colors.green,
        iconSize: 30,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => _cartPage()));
        },
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 225, 231, 225),
              Color.fromARGB(255, 91, 105, 92)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 8.0),
            _buildCategorySlider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                onChanged: _filterMenuItems,
                decoration: InputDecoration(
                  hintText: 'Search for dishes...',
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _searchController.text.isEmpty
                        ? const Icon(Icons.search, color: Colors.green)
                        : IconButton(
                            icon: const Icon(Icons.clear,
                                color: Colors.redAccent),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _filterMenuItems('');
                              });
                            },
                          ),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                        color: Colors.greenAccent.shade100, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.green, width: 2),
                  ),
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
                    color: Colors.green.shade200,
                    margin: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(15.0)),
                          child: SizedBox(
                            height: 150,
                            child: Image.network(
                              item['imagePath'],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.error),
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(
                                    child: CircularProgressIndicator());
                              },
                            ),
                          ),
                        ),
                        ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(item['title'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Text(item['price'],
                                  style: const TextStyle(color: Colors.green)),
                            ],
                          ),
                          subtitle: quantity == 0
                              ? ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green.shade700,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      cartItems.add({...item, 'quantity': 1});
                                      isCartActive = true;
                                    });
                                  },
                                  child: const Text('Add to Cart',
                                      style: TextStyle(color: Colors.white)),
                                )
                              : _buildQuantityControls(item),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            if (isCartActive)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => _cartPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.greenAccent,
                    elevation: 10,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  )..copyWith(
                      backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.green.shade900;
                        }
                        return null;
                      }),
                    ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00C853), Color(0xFF64DD17)],
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Container(
                      constraints:
                          const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
                      alignment: Alignment.center,
                      child: const Text(
                        "View Cart",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityControls(Map<String, dynamic> item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Display the quantity of the item
        Text('Quantity: ${_getCartItemQuantity(item['title'])}'),
        Row(
          children: [
            // Decrease quantity button
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () {
                setState(() {
                  final index = cartItems.indexWhere(
                      (cartItem) => cartItem['title'] == item['title']);
                  if (index != -1) {
                    if (cartItems[index]['quantity'] > 1) {
                      cartItems[index]['quantity']--;
                    } else {
                      cartItems.removeAt(index); // Remove item if quantity is 1
                    }
                    isCartActive = cartItems.isNotEmpty; // Update cart status
                  }
                });
              },
            ),
            // Increase quantity button
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                setState(() {
                  final index = cartItems.indexWhere(
                      (cartItem) => cartItem['title'] == item['title']);
                  if (index != -1) {
                    cartItems[index]['quantity']++; // Increase quantity
                  } else {
                    cartItems.add(
                        {...item, 'quantity': 1}); // Add item with quantity 1
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
