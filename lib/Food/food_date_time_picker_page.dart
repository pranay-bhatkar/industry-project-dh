import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dh/Food/food_bill_summery.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DateTimePickerPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  const DateTimePickerPage({super.key, required this.cartItems});

  @override
  _DateTimePickerPageState createState() => _DateTimePickerPageState();
}

class _DateTimePickerPageState extends State<DateTimePickerPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool isCodeVerified = false;
  String userPhoneNumber = "0";
  String role = "user";
  bool isLoading = true;
  final TextEditingController villaNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeSharedPreferences();
  }

  @override
  void dispose() {
    villaNameController.dispose();
    super.dispose();
  }

  Future<void> _initializeSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    String? userPhoneNumberTemp = prefs.getString('userPhoneNumber');
    String? userRole = prefs.getString('role');
    await Future.delayed(const Duration(seconds: 2)); // Simulate loading time

    if (userRole != null && userPhoneNumberTemp != null) {
      setState(() {
        userPhoneNumber = userPhoneNumberTemp;
        role = userRole;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Method to select date
  Future<void> _selectDate(BuildContext context) async {
    if (role == "user" && !isCodeVerified) {
      _showCodeEntryDialog(context);
      return;
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.green,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  // Method to select time
  Future<void> _selectTime(BuildContext context) async {
    if (role == "user" && !isCodeVerified) {
      _showCodeEntryDialog(context);
      return;
    }

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.green,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  // Method to format DateTime into a readable format
  String _formatDateTime() {
    if (selectedDate == null || selectedTime == null) {
      return 'No date and time selected';
    }

    final formattedDate = DateFormat('yMMMMd').format(selectedDate!);
    final formattedTime = selectedTime!.format(context);
    return '$formattedDate at $formattedTime';
  }

  // Method to show the code entry dialog
  Future<void> _showCodeEntryDialog(BuildContext context) async {
    final TextEditingController codeController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Code'),
          content: TextField(
            controller: codeController,
            decoration: const InputDecoration(
              hintText: 'Enter your code',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Color(0xFF4A7C59)),
              child: const Text('Submit'),
              onPressed: () {
                if (codeController.text == "1234") {
                  setState(() {
                    isCodeVerified = true;
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Code verified successfully!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid code, try again!')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.green,
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Date & Time'),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedDate == null
                            ? 'Select Date'
                            : DateFormat('yMMMMd').format(selectedDate!),
                        style: TextStyle(
                          fontSize: 18,
                          color: selectedDate == null
                              ? Colors.grey
                              : Colors.black87,
                        ),
                      ),
                      const Icon(Icons.calendar_today,
                          color: Color(0xFF4A7C59)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _selectTime(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedTime == null
                            ? 'Select Time'
                            : selectedTime!.format(context),
                        style: TextStyle(
                          fontSize: 18,
                          color: selectedTime == null
                              ? Colors.grey
                              : Colors.black87,
                        ),
                      ),
                      const Icon(Icons.access_time, color: Color(0xFF4A7C59)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100], // Background color for the container
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey
                          .withOpacity(0.3), // Shadow color with opacity
                      spreadRadius: 2, // How far the shadow spreads
                      blurRadius: 5, // Softness of the shadow
                      offset:
                          const Offset(2, 3), // Position of the shadow (x, y)
                    ),
                  ],
                ),
                child: TextField(
                  controller: villaNameController,
                  decoration: InputDecoration(
                    labelText: 'Villa Name',
                    hintText: 'Enter the villa name',
                    labelStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                    prefixIcon: const Icon(Icons.home_outlined,
                        color: Color(0xFF4A7C59)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          BorderSide.none, // No border as shadow provides depth
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          const BorderSide(color: Color(0xFF4A7C59), width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 18),
                    filled: true,
                    fillColor: Colors
                        .transparent, // Transparent to use the container's background color
                  ),
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Selected Date & Time:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                _formatDateTime(),
                style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
              ),
              const SizedBox(height: 10),
              Text(
                villaNameController.text,
                style: TextStyle(
                  fontSize: 20,
                  color: villaNameController.text.isNotEmpty
                      ? Colors.black87
                      : Colors.grey,
                  fontStyle: villaNameController.text.isNotEmpty
                      ? FontStyle.normal
                      : FontStyle.italic,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Color(0xFF4A7C59),
                ),
                onPressed: selectedDate != null && selectedTime != null
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FoodBillSummaryPage(
                              cartItems: widget.cartItems,
                              date: selectedDate,
                              time: selectedTime,
                              villaName: villaNameController.text,
                            ),
                          ),
                        );
                      }
                    : null,
                child: const Text(
                  'Confirm',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
