import 'package:flutter/material.dart';
import 'bill_summary.dart'; // Import the BillSummaryPage
import 'service_item.dart';

class ElectricianBookingPage extends StatefulWidget {
  final String serviceName;
  final String serviceImagePath;
  final List<ServiceItem> serviceOptions;
  final int totalCharge;
  final DateTime selectedDateTime; // New field for date and time

  const ElectricianBookingPage({
    Key? key,
    required this.serviceName,
    required this.serviceImagePath,
    required this.serviceOptions,
    required this.totalCharge,
    required this.selectedDateTime, // Initialize the new field
  }) : super(key: key);

  @override
  State<ElectricianBookingPage> createState() => _ElectricianBookingPageState();
}

class _ElectricianBookingPageState extends State<ElectricianBookingPage> {
  List<ServiceItem> _selectedServices = [];
  int _currentCharge = 99;
  bool _showOtherTextField = false;
  String? _otherServiceName;

  int _previousTurfHours = 1; // Track previous turf hours

  // Clothing options
  String? _selectedClothingType;
  bool _showClothingOptions = false; // Move this here
  final List<String> _clothingOptions = ['White Clothes', 'Colored Clothes'];
  final Map<String, int> _clothingPrices = {
    'White Clothes': 100, // Adjust prices as needed
    'Colored Clothes': 120,
  };

  // Turf booking
  int _turfHours = 1; // Default hours
  final int _turfRatePerHour = 150; // Set rate per hour
  bool _showTurfHours = false; // Track visibility of turf hours

  // Club Membership
  String? _selectedMembership;
  bool _showMembershipOptions = false; // Track visibility of membership options
  final List<String> _membershipOptions = [
    'Weekly',
    'Monthly',
    '6 Months',
    'Yearly'
  ];
  final Map<String, int> _membershipPrices = {
    'Weekly': 1000,
    'Monthly': 3500,
    '6 Months': 18000,
    'Yearly': 40000,
  };

  @override
  void initState() {
    super.initState();
    // Set the initial charge to the visiting charge
    _currentCharge = 99; // Initialize with the visiting charge
  }

  void _onServiceSelected(ServiceItem service, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedServices.add(service);
        _currentCharge += service.price;
      } else {
        _selectedServices.remove(service);
        _currentCharge -= service.price;
      }
    });
  }

  void _onOtherServiceAdded() {
    if (_otherServiceName != null && _otherServiceName!.isNotEmpty) {
      final otherService = ServiceItem(
        name: _otherServiceName!,
        price: 80, // Fixed price for the other service
        imagePath: '',
      );
      setState(() {
        _selectedServices.add(otherService);
        _currentCharge += otherService.price;
        _showOtherTextField =
            false; // Hide the text fields after adding "Other"
      });
    }
  }

  void _showBill() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BillSummaryPage(
          selectedServices: _selectedServices,
          subTotal: _currentCharge,
          selectedDateTime: widget.selectedDateTime,
          serviceImagePath: widget.serviceImagePath,
          clothingType: _selectedClothingType,
          turfHours: _turfHours,
          membershipType: _selectedMembership,
          otherServices: _selectedServices
              .where((service) => service.name == 'Other')
              .toList(),
          clothingPrices: _selectedClothingType != null
              ? _clothingPrices[_selectedClothingType!] ?? 0
              : 0, // Include selected clothing price
          turfCharge: _turfHours * _turfRatePerHour, // Include turf charge
          membershipCharge: _selectedMembership != null
              ? _membershipPrices[_selectedMembership!] ?? 0
              : 0, // Include membership price
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.serviceName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: Colors.blue, width: 3.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.network(
                  widget.serviceImagePath,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Charge: ₹ $_currentCharge',
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
            const SizedBox(height: 8),

            // Expanded List of Services in Card Format
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.serviceOptions.length,
              itemBuilder: (context, index) {
                final serviceItem = widget.serviceOptions[index];

                // Check if the service item is "Clothes", "Turf", or "Club"
                bool isClothesService = (serviceItem.name == 'Wash and Iron');
                bool isTurfService = (serviceItem.name == 'Turf Booking');
                bool isClubService = (serviceItem.name == 'Club Membership');

                return Card(
                  color: const Color(0xFFE6EAFF),
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                serviceItem.name,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            if (!isClothesService &&
                                !isTurfService &&
                                !isClubService)
                              Text(
                                '₹ ${serviceItem.price}',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            if (!isClothesService &&
                                !isTurfService &&
                                !isClubService)
                              Checkbox(
                                value: _selectedServices.contains(serviceItem),
                                onChanged: (bool? isChecked) {
                                  _onServiceSelected(
                                      serviceItem, isChecked ?? false);
                                },
                              ),
                          ],
                        ),

                        // Show clothing options only if the "Clothes" service is selected
                        if (isClothesService) ...[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _showClothingOptions =
                                    !_showClothingOptions; // Toggle visibility
                              });
                            },
                            child: Text(
                              _showClothingOptions
                                  ? 'Hide Clothing Options'
                                  : 'Show Clothing Options',
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          if (_showClothingOptions) ...[
                            Column(
                              children: _clothingOptions.map((String option) {
                                return CheckboxListTile(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(option),
                                      Text(
                                          '₹ ${_clothingPrices[option]}'), // Display price next to clothing type
                                    ],
                                  ),
                                  value: _selectedServices
                                      .any((service) => service.name == option),
                                  onChanged: (bool? isChecked) {
                                    setState(() {
                                      if (isChecked ?? false) {
                                        _currentCharge +=
                                            _clothingPrices[option]!;
                                        _selectedServices.add(ServiceItem(
                                          name: option,
                                          price: _clothingPrices[option]!,
                                          imagePath: '',
                                        ));
                                      } else {
                                        _currentCharge -=
                                            _clothingPrices[option]!;
                                        _selectedServices.removeWhere(
                                            (service) =>
                                                service.name == option);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ],
                        ],

                        // Turf Booking
                        if (isTurfService) ...[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _showTurfHours =
                                    !_showTurfHours; // Toggle visibility
                              });
                            },
                            child: Text(
                              _showTurfHours
                                  ? 'Hide Turf Booking Options'
                                  : 'Show Turf Booking Options',
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          if (_showTurfHours) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Hours:'),
                                DropdownButton<int>(
                                  value: _turfHours,
                                  items: List.generate(5, (index) => index + 1)
                                      .map((hour) {
                                    return DropdownMenuItem<int>(
                                      value: hour,
                                      child: Text(
                                          '$hour hour${hour > 1 ? 's' : ''}'),
                                    );
                                  }).toList(),
                                  onChanged: (int? value) {
                                    if (value != null &&
                                        value != _previousTurfHours) {
                                      setState(() {
                                        // Update the charge based on the differnce  in hours
                                        // Always add the total for current hours
                                        _currentCharge = 99 +
                                            (value *
                                                _turfRatePerHour); // set the bse charge  + turf charge
                                        _turfHours =
                                            value; // update the current hours
                                      });
                                    }
                                  },
                                ),
                                Text('₹ ${_turfHours * _turfRatePerHour}'),
                              ],
                            ),
                          ],
                        ],

                        // Club Membership
                        if (isClubService) ...[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _showMembershipOptions =
                                    !_showMembershipOptions; // Toggle visibility
                              });
                            },
                            child: Text(
                              _showMembershipOptions
                                  ? 'Hide Membership Options'
                                  : 'Show Membership Options',
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          if (_showMembershipOptions) ...[
                            Column(
                              children: _membershipOptions.map((String option) {
                                return CheckboxListTile(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(option),
                                      Text(
                                          '₹ ${_membershipPrices[option]}'), // Display price next to membership type
                                    ],
                                  ),
                                  value: _selectedMembership == option,
                                  onChanged: (bool? isChecked) {
                                    setState(() {
                                      if (isChecked ?? false) {
                                        _selectedMembership = option;
                                        _currentCharge +=
                                            _membershipPrices[option]!;
                                      } else {
                                        if (_selectedMembership == option) {
                                          _currentCharge -=
                                              _membershipPrices[option]!;
                                          _selectedMembership = null;
                                        }
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),

            // "Other" option
            Card(
              color: const Color(0xFFE6EAFF),
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: CheckboxListTile(
                title: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text("Other"),
                ),
                value: _showOtherTextField,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                controlAffinity: ListTileControlAffinity.trailing,
                onChanged: (bool? isChecked) {
                  setState(() {
                    _showOtherTextField = isChecked ?? false;
                  });
                },
              ),
            ),

            if (_showOtherTextField) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        decoration:
                            const InputDecoration(labelText: "Service Name"),
                        onChanged: (value) {
                          setState(() {
                            _otherServiceName = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    const Text(
                      "₹ 80",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ), // Fixed price display
                    const SizedBox(width: 16.0),
                    ElevatedButton(
                      onPressed: _onOtherServiceAdded,
                      child: const Text("Add"),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _showBill,
              child: const Text('Show Bill'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
