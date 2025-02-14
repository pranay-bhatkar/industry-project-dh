import 'package:dh/Navigation/basescaffold.dart';
import 'package:flutter/material.dart';

class AddInnerServices extends StatefulWidget {
  const AddInnerServices({super.key});

  @override
  State<AddInnerServices> createState() => _AddInnerServicesState();
}

class _AddInnerServicesState extends State<AddInnerServices> {
  @override
  Widget build(BuildContext context) {
    return const BaseScaffold(title: 'Add Inner Services',
        body: Center(
            child: Text("Add Inner Services")
        )
    );
  }
}
