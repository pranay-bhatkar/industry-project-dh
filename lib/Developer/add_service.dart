import 'package:dh/Navigation/basescaffold.dart';
import 'package:flutter/material.dart';

class AddService extends StatefulWidget {
  const AddService({super.key});

  @override
  State<AddService> createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  @override
  Widget build(BuildContext context) {
    return const BaseScaffold(title: 'Add Service',
        body: Center(
            child: Text("Add Service")),
    );
  }
}
