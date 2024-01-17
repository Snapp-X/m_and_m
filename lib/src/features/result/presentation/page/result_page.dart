import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Result')),
      body: const Center(
        child: Text(
          'Result',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
