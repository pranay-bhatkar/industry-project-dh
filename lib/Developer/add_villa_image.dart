import 'package:dh/Navigation/basescaffold.dart';
import 'package:flutter/material.dart';

class AddVilla extends StatefulWidget {
  const AddVilla({super.key});

  @override
  State<AddVilla> createState() => _AddVillaState();
}

class _AddVillaState extends State<AddVilla> {
  @override
  Widget build(BuildContext context) {
    return const BaseScaffold(title: 'Add Villa Image',
        body: Center(
            child: Text("Add Villa Image")
        )
    );
  }
}
