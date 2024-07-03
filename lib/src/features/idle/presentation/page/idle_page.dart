import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_and_m/src/core/presentation/provider/season_control_provider.dart';
import 'package:m_and_m/src/core/presentation/theme/color.dart';
import 'package:m_and_m/src/core/presentation/widget/content_body.dart';
import 'package:m_and_m/src/features/idle/presentation/widget/background_animation.dart';
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
        child: BackgroundAnimation(
            child: Center(
          child: Center(
            child: ContentBody(
              title: 'GET YOUR MIX!',
              description: 'START THE GAME. \n',
              lightColor: ThemeColors.yellow,
              darkColor: ThemeColors.brown,
              onPressed: () {
                ref.read(seasonControlProvider.notifier).startSeason();
              },
            ),
          ),
        )),
      ),
    );
  }
}
