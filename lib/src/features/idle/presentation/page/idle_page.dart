import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_and_m/src/core/presentation/provider/season_control_provider.dart';
import 'package:m_and_m/src/core/presentation/widget/nue_button.dart';

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
            NueButton(
              size: 200,
              color: const Color(0xff24272C),
              onPressed: () {
                ref.read(seasonControlProvider.notifier).startSeason();
              },
              child: const Text('Start Season'),
            ),
          ],
        ),
      ),
    );
  }
}
