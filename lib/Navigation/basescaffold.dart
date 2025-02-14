import 'package:flutter/material.dart';
import 'navdrawer.dart'; // Import your navigation drawer

class BaseScaffold extends StatelessWidget {
  final String title;
  final Widget? appBarActions;
  final Widget body;

  const BaseScaffold({
    super.key,
    required this.title,
    this.appBarActions,
    required this.body,
    FloatingActionButton? floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280.0,
      height: double.infinity,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 118, 213, 94),
          title: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: appBarActions != null ? [appBarActions!] : [],
        ),
        body: body,
        drawer: const SideNavigationBar(), // Navigation drawer
      ),
    );
  }
}
