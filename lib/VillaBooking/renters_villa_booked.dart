import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RentersVillaBooked extends StatefulWidget {
  const RentersVillaBooked({super.key});

  @override
  State<RentersVillaBooked> createState() => _RentersVillaBookedState();
}

class _RentersVillaBookedState extends State<RentersVillaBooked> {
  final DatabaseReference reference =
      FirebaseDatabase.instance.ref("villaRenters");

  String? dataisfetching = "";
  bool isLoading = false;
  String brokerNumber = '';
  final TextEditingController brokerController = TextEditingController();

  String userPhoneNumber = "0";
  String role = "user";

  @override
  void initState() {
    super.initState();
    _initializeSharedPreferences();
  }

  Future<void> _initializeSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    String? userPhoneNumberTemp = prefs.getString('userPhoneNumber');
    String? userRole = prefs.getString('role');
    if (userRole != null && userPhoneNumberTemp != null) {
      setState(() {
        userPhoneNumber = userPhoneNumberTemp;
        role = userRole;
      });
    }
    await Future.delayed(const Duration(seconds: 2));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (role != "admin") ...[
                      Center(
                        child: ElevatedButton(
                          onPressed: () => _showBrokerNumberDialog(context),
                          child: const Text("Enter Broker Number"),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Broker Number: $brokerNumber',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(dataisfetching!),
                      const SizedBox(height: 20),
                    ],
                    if (brokerNumber.isNotEmpty && role == "user")
                      _buildUserData()
                    else if (role == "admin")
                      _buildAdminData(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildAdminData() {
    return FutureBuilder(
      future: reference.once(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          DataSnapshot? dataSnapshot = snapshot.data?.snapshot;
          if (dataSnapshot?.value == null) {
            return const Center(child: Text("No data found."));
          }

          Map<dynamic, dynamic> brokers =
              dataSnapshot?.value as Map<dynamic, dynamic>;
          List<Map<dynamic, dynamic>> allBookings = [];

          brokers.forEach((brokerPhone, users) {
            Map<dynamic, dynamic> usersMap = users as Map<dynamic, dynamic>;
            usersMap.forEach((userPhone, userBookings) {
              Map<dynamic, dynamic> bookingsMap =
                  userBookings as Map<dynamic, dynamic>;
              bookingsMap.forEach((bookingId, bookingData) {
                allBookings.add({
                  "brokerPhone": brokerPhone,
                  "userPhone": userPhone,
                  "bookingId": bookingId,
                  ...bookingData,
                });
              });
            });
          });

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: allBookings.length,
            itemBuilder: (context, index) {
              Map<dynamic, dynamic> booking = allBookings[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(
                      "Villa Booked: ${booking["villaDetails"]["villaName"]}"),
                  subtitle: Text(
                      "Broker: ${booking["brokerPhone"]} | User: ${booking["userPhone"]}"),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BookingDetailsPage(bookingData: booking),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(child: Text("No data available."));
        }
      },
    );
  }

  Widget _buildUserData() {
    return FirebaseAnimatedList(
      query: reference.child(brokerNumber),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, snapshot, animation, index) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        var filteredData = data.values.where((bookingData) {
          return bookingData["renterDetails"]["renterContact"] ==
              userPhoneNumber;
        }).toList();

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredData.length,
          itemBuilder: (context, i) {
            Map<dynamic, dynamic> bookingData = filteredData[i];

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(
                    "Booked Villa: ${bookingData["villaDetails"]["villaName"]}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Name: ${bookingData["renterDetails"]["renterName"]}"),
                    Text(
                        "Contact: ${bookingData["renterDetails"]["renterContact"]}"),
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        BookingDetailsPage(bookingData: bookingData),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showBrokerNumberDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Enter Broker Number"),
          content: TextField(
            controller: brokerController,
            decoration:
                const InputDecoration(hintText: "Enter Broker Phone Number"),
            keyboardType: TextInputType.phone,
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  dataisfetching = "please wait you data is fetching...";
                  brokerNumber = brokerController.text;
                });
                Navigator.of(context).pop();
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }
}

class BookingDetailsPage extends StatelessWidget {
  final Map<dynamic, dynamic> bookingData;

  const BookingDetailsPage({super.key, required this.bookingData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking Details"),
        backgroundColor: const Color(0xFF228B22), // Earth tone - Forest Green
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(13.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Villa Details",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF228B22)),
            ),
            const Divider(),
            _buildDetailRow("Name:", bookingData["villaDetails"]["villaName"]),
            _buildDetailRow("Size:", bookingData["villaDetails"]["villaSize"]),
            _buildDetailRow(
                "Price:", bookingData["villaDetails"]["villaPrice"]),
            _buildDetailRow(
                "Number:", bookingData["villaDetails"]["villaNumber"]),
            const SizedBox(height: 20),
            const Text(
              "Renter Details",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF228B22)),
            ),
            const Divider(),
            _buildDetailRow(
                "Name:", bookingData["renterDetails"]["renterName"]),
            _buildDetailRow(
                "Email:", bookingData["renterDetails"]["renterEmail"]),
            _buildDetailRow(
                "Contact:", bookingData["renterDetails"]["renterContact"]),
            const SizedBox(height: 20),
            const Text(
              "Cost Details",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF228B22)),
            ),
            const Divider(),
            _buildDetailRow("GST Cost:", bookingData["cost"]["gstCost"]),
            _buildDetailRow("Sub Cost:", bookingData["cost"]["subCost"]),
            _buildDetailRow("Total Cost:", bookingData["cost"]["totalCost"]),
            const SizedBox(height: 20),
            const Text(
              "Date Details",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF228B22)),
            ),
            const Divider(),
            _buildDetailRow("Entry Date:", bookingData["date"]["entryDate"]),
            _buildDetailRow("Exit Date:", bookingData["date"]["existDate"]),
            _buildDetailRow(
                "Number of Nights:", bookingData["date"]["numberOfNights"]),
          ],
        ),
      ),
    );
  }

  // Helper method to build each row with the label and value
  Widget _buildDetailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.brown, // Earth-tone color for label
            ),
          ),
          Flexible(
            child: Text(
              value.toString(),
              style: const TextStyle(
                color: Colors.black87, // Dark text for readability
                fontSize: 16,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
