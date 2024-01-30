import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_and_m/src/core/presentation/provider/season_control_provider.dart';
import 'package:m_and_m/src/core/presentation/widget/nue_button.dart';
import 'package:m_and_m/src/features/idle/presentation/widget/background_animation.dart';

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
        child: const BackgroundAnimation(child: StartButton()),
      ),
    );
  }
}

class StartButton extends ConsumerWidget {
  const StartButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NueButton(
      size: 200,
      gradient: const [
        Color(0xffffd302),
        Color(0xffcfac02),
      ],
      holderGradient: const [
        Color(0xffffd302),
        Color(0xffcfac02),
      ],
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          offset: Offset(18, 18),
          blurRadius: 36,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.white24,
          offset: Offset(-18, -18),
          blurRadius: 36,
          spreadRadius: 0,
        ),
      ],
      onPressed: () {
        ref.read(seasonControlProvider.notifier).startSeason();
      },
      child: const Text(
        'Start',
        style: TextStyle(
          color: Colors.white70,
          fontSize: 36,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
