import 'package:flutter/material.dart';
import 'package:new_project/config/routes.dart';

class TotalScreen extends StatefulWidget {
  const TotalScreen({super.key});

  @override
  State<TotalScreen> createState() => _TotalScreenState();
}

class _TotalScreenState extends State<TotalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.toName(Routes.addTotalBalance);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
