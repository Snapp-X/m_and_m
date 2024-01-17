import 'package:flutter/material.dart';

class MakePage extends StatelessWidget {
  const MakePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Make'),
      ),
      body: const Center(
        child: Text('This is the Make Page, We are testing season idle'),
      ),
    );
  }
}
