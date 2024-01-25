import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_and_m/src/core/presentation/provider/season_control_provider.dart';
import 'package:m_and_m/src/core/presentation/widget/nue_button.dart';

class IdlePage extends ConsumerWidget {
  const IdlePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xffFDCB08),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Color(0xffFDDC01),
              Color(0xffFDCB08),
            ],
            radius: .5,
            stops: [.4, 1],
          ),
        ),
        child: Center(
          child: NueButton(
            color: const Color(0xffFDCB08),
            onPressed: () {
              ref.read(seasonControlProvider.notifier).startSeason();

              // Navigator.of(context).pushNamed('/mix');
            },
            size: 200,
            child: const Text(
              'Tap to Start',
              style: TextStyle(
                color: Color(0xff24272C),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
