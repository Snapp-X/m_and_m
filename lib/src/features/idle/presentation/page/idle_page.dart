import 'package:flutter/material.dart';

class IdlePage extends StatelessWidget {
  const IdlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Idle'),
      ),
      body: const Center(
        child: Text('Idle'),
      ),
    );
  }
}
