import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_and_m/src/core/presentation/provider/season_control_provider.dart';
import 'package:m_and_m/src/core/presentation/widget/nue_button.dart';
// import 'package:m_and_m/src/features/idle/presentation/widget/background_animation.dart';

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
        child: const Center(child: StartButton()),
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
      color: const Color(0xffFDDD02),
      borderGradient: const [
        Colors.white12,
        Color(0xffFDCD08),
      ],
      holderGradient: const [
        Color(0xffFDCD08),
        Color(0xffFEDD02),
      ],
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.05),
          offset: const Offset(18, 18),
          blurRadius: 36,
          spreadRadius: 0,
        ),
        const BoxShadow(
          color: Colors.white24,
          offset: Offset(-18, -18),
          blurRadius: 36,
          spreadRadius: 0,
        ),
      ],
      innerShadow: const [],
      onPressed: () {
        ref.read(seasonControlProvider.notifier).startSeason();
      },
      child: const Text(
        'Start',
        style: TextStyle(
          color: Colors.white54,
          fontSize: 36,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
