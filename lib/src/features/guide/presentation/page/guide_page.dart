import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_and_m/src/core/domain/model/candy_box.dart';
import 'package:m_and_m/src/core/presentation/provider/season_control_provider.dart';
import 'package:m_and_m/src/core/presentation/routing/routes.dart';
import 'package:m_and_m/src/core/presentation/theme/color.dart';
import 'package:m_and_m/src/core/presentation/widget/content_body.dart';

class GuidePage extends StatefulWidget {
  const GuidePage({super.key});

  @override
  State<GuidePage> createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  late final CandyBox expectedCandyBox;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    expectedCandyBox = _makeRandomCandyBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.green,
      body: IconTheme(
        data: const IconThemeData(color: ThemeColors.green),
        child: DefaultTextStyle.merge(
          style: const TextStyle(color: ThemeColors.darkGreen),
          child: Stack(
            children: [
              PositionedDirectional(
                top: 100,
                end: 100,
                child: Consumer(
                  builder:
                      (BuildContext context, WidgetRef ref, Widget? child) {
                    return FloatingActionButton.large(
                      elevation: 0,
                      backgroundColor: ThemeColors.darkGreen,
                      foregroundColor: ThemeColors.green,
                      shape: const CircleBorder(),
                      onPressed: () {
                        ref.read(seasonControlProvider.notifier).idle();
                      },
                      child: const Icon(
                        Icons.close_rounded,
                        size: 64,
                      ),
                    );
                  },
                ),
              ),
              Center(
                child: ContentBody(
                  title: 'HOW IT WORKS',
                  description:
                      'SWIPE LEFT OR RIGHT ON THE BAG TO PICK THE M&MS YOU WANT. MAKE SURE TO COLLECT THE M&MS IN THE EXACT ORDER SHOWN BELOW TO GET YOUR PERFECT MIX AT THE END!',
                  lightColor: ThemeColors.green,
                  darkColor: ThemeColors.darkGreen,
                  customWidget: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: expectedCandyBox.portions.entries
                        .map(
                          (entry) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Image.asset(
                              'assets/img/${entry.value.name}.png',
                              width: 160,
                              height: 160,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  onPressed: () {
                    CatchGameRoute(expectedCandyBox).go(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  CandyBox _makeRandomCandyBox() {
    final colors = List.generate(
      4,
      (index) => MapEntry(
        index,
        CandyColor.values[_random.nextInt(4)],
      ),
    );
    return CandyBox(portions: Map.fromEntries(colors));
  }
}
