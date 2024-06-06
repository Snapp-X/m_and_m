import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:m_and_m/src/core/domain/model/candy_box.dart';
import 'package:m_and_m/src/core/presentation/theme/color.dart';
import 'package:m_and_m/src/features/catch_game/presentation/page/candy_controller.dart';
import 'package:neumorphic_ui/neumorphic_ui.dart';

// TODO(payam): add precache logic for images

const _candyFallDuration = Duration(seconds: 3);
const _candyGenerateInterval = Duration(seconds: 1);

const bagWidgetWidth = 250.0;

const childHalfSize = bagWidgetWidth / 2;

const candySize = 150.0;
const candyOuterPadding = 32;
const candyRowWidth = candySize + candyOuterPadding;

class CacheGamePage extends StatelessWidget {
  const CacheGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: ThemeColors.green,
      body: GameScene(),
    );
  }
}

class GameScene extends StatefulWidget {
  const GameScene({super.key});

  @override
  GameSceneState createState() => GameSceneState();
}

class GameSceneState extends State<GameScene> with TickerProviderStateMixin {
  late final Timer timer;
  final Random random = Random();

  final ValueNotifier<Offset> bagPosition = ValueNotifier(Offset.zero);

  List<CandyController> candyControllers = [];

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(
      _candyGenerateInterval,
      (timer) {
        setState(() {
          final List<int> availableRowPositions = List.generate(
            candyRowCount(context),
            (index) => index,
          )
              .where(
                (position) => !candyControllers.any(
                  (controller) => controller.rowPosition == position,
                ),
              )
              .toList();

          candyControllers.add(
            CandyController(
              vsync: this,
              color: CandyColor.values[timer.tick % CandyColor.values.length],
              rowPosition: availableRowPositions[
                  random.nextInt(availableRowPositions.length)],
              autoStart: true,
              duration: _candyFallDuration,
              onFallAnimationCompleted: (id) {
                final removedController = candyControllers.firstWhereOrNull(
                  (controller) => controller.id == id,
                );

                if (removedController == null) return;

                candyControllers.remove(removedController);

                removedController.dispose();
              },
            ),
          );
        });
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();

    for (var controller in candyControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final candyRowCount = screenSize.width ~/ candyRowWidth;
    final outerPadding = (screenSize.width - candyRowCount * candyRowWidth) / 2;

    final List<Widget> candyRows = [
      for (var i = 0; i < candyRowCount; i++)
        Positioned(
          left: outerPadding + i * candyRowWidth,
          top: 0,
          child: Container(
            width: candyRowWidth,
            height: screenSize.height,
            color: [Colors.white54, Colors.white70][i % 2],
          ),
        ),
    ];

    return GestureDetector(
      child: Stack(
        children: [
          ...candyRows,
          for (var controller in candyControllers)
            if (controller.rowPosition < candyRowCount)
              AnimatedBuilder(
                animation: controller.dyAnimation,
                builder: (context, child) {
                  final dx = (candyOuterPadding / 2) +
                      (outerPadding) +
                      controller.rowPosition * candyRowWidth;

                  final dy =
                      controller.dyPosition(screenSize.height, candySize);
                  return Positioned(
                    left: dx,
                    top: dy,
                    child: RotationTransition(
                      turns: controller.rotateAnimation,
                      child: Candy(color: controller.color),
                    ),
                  );
                },
              ),
          ValueListenableBuilder(
            valueListenable: bagPosition,
            child: GestureDetector(
              onPanUpdate: (details) =>
                  updateBagPosition(details.globalPosition, screenSize),
              child: const BagWidget(),
            ),
            builder: (context, Offset position, child) {
              return Positioned(
                left: position.dx,
                bottom: 0,
                child: child!,
              );
            },
          ),
        ],
      ),
    );
  }

  int candyRowCount(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return screenSize.width ~/ candyRowWidth;
  }

  void updateBagPosition(Offset newPosition, Size screenSize) {
    if (newPosition.dx < childHalfSize ||
        newPosition.dx > screenSize.width - childHalfSize) {
      return;
    }

    bagPosition.value =
        newPosition - const Offset(childHalfSize, childHalfSize);
  }
}

class BagWidget extends StatelessWidget {
  const BagWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: ThemeColors.darkGreen,
      child: Image.asset(
        'assets/img/bag.png',
        width: bagWidgetWidth,
      ),
    );
  }
}

class Candy extends StatelessWidget {
  const Candy({super.key, required this.color});

  final CandyColor color;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/img/${color.name.toLowerCase()}.png',
      width: candySize,
    );
  }
}
