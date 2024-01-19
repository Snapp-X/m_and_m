import 'package:flutter/material.dart';

class MixPage extends StatelessWidget {
  const MixPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mix Page'),
      ),
      body: const Center(
        child: Text('This is the Make Page, We are testing season idle'),
      ),
    );
  }
}
