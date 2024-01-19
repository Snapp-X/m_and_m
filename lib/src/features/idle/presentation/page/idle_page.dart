import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_and_m/src/core/presentation/provider/season_control_provider.dart';

class IdlePage extends ConsumerWidget {
  const IdlePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Idle Page'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Tap to start the season!'),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: () {
                  ref.read(seasonControlProvider.notifier).startSeason();
                },
                child: const Text('Start Season')),
          ],
        ),
      ),
    );
  }
}
