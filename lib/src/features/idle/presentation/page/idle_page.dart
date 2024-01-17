import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:m_and_m/src/core/presentation/provider/season_control_provider.dart';
import 'package:m_and_m/src/core/presentation/routing/routes.dart';

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Start your journey'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ref.read(seasonControlProvider.notifier).interacted();
                context.go(const MakePageRoute().location);
              },
              child: const Text('Start'),
            ),
          ],
        ),
      ),
    );
  }
}
