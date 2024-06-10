import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_and_m/src/core/domain/model/candy_box.dart';
import 'package:m_and_m/src/core/presentation/provider/season_control_provider.dart';
import 'package:m_and_m/src/core/presentation/theme/color.dart';
import 'package:m_and_m/src/features/catch_game/presentation/page/candy_controller.dart';
import 'package:m_and_m/src/features/mix/presentation/provider/mix_provider.dart';
import 'package:neumorphic_ui/neumorphic_ui.dart';

// TODO(payam): add precache logic for images

const _candyFallDuration = Duration(seconds: 3);
const _candyGenerateInterval = Duration(seconds: 1);

const bagWidgetWidth = 250.0;
const bagWidgetHeight = 300.0;

const collectorBagWidth = bagWidgetWidth * 0.6;
const collectorBagHeight = bagWidgetHeight * 0.8;

const bagHalfSize = bagWidgetWidth / 2;

const candySize = 150.0;
const candyOuterPadding = 32;
const candyRowWidth = candySize + candyOuterPadding;

class CacheGamePage extends StatelessWidget {
  const CacheGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: ThemeColors.green,
      body: Game(),
    );
  }
}

class Game extends ConsumerStatefulWidget {
  const Game({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GameState();
}

class _GameState extends ConsumerState<Game> with TickerProviderStateMixin {
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
              onFallAnimationCompleted: _removeCandyController,
              onPositionChanged: _onCandyPositionChanged,
            ),
          );
        });
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      updateBagPosition(MediaQuery.of(context).size.center(Offset.zero),
          MediaQuery.of(context).size);
    });
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
    ref.listen(
      candyMixerProvider,
      (previous, next) {
        if (next.portions.length ==
            ref.read(candyMixerProvider.notifier).limit) {
          finishGame(next);
        }
      },
    );

    final screenSize = MediaQuery.of(context).size;
    final rowCount = candyRowCount(context);
    final outerPadding = (screenSize.width - rowCount * candyRowWidth) / 2;

    final List<Widget> candyRows = [
      for (var i = 0; i < rowCount; i++)
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
            if (controller.rowPosition < rowCount)
              AnimatedBuilder(
                animation: Listenable.merge(
                  [
                    controller.dyAnimation,
                    controller.rotateAnimation,
                    controller.fadeOutAnimation,
                  ],
                ),
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
                      child: ScaleTransition(
                        scale: controller.fadeOutAnimation,
                        child: Candy(color: controller.color),
                      ),
                    ),
                  );
                },
              ),
          PositionedDirectional(
            top: 100,
            start: 100,
            child: Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
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
          const Positioned(
            top: 100,
            right: 100,
            child: CollectedCandiesWidget(),
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
                top: position.dy,
                child: child!,
              );
            },
          ),
        ],
      ),
    );
  }

  void finishGame(candyBox) {
    timer.cancel();

    // ResultPageRoute(candyBox).go(context);
  }

  int candyRowCount(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return screenSize.width ~/ candyRowWidth;
  }

  void updateBagPosition(Offset newPosition, Size screenSize) {
    if (newPosition.dx < bagHalfSize ||
        newPosition.dx > screenSize.width - bagHalfSize) {
      return;
    }

    final effectivePosition = Offset(
      newPosition.dx,
      screenSize.height - bagWidgetHeight,
    );

    bagPosition.value = effectivePosition - const Offset(bagHalfSize, 0);
  }

  Rect _collectorRect(Offset position) {
    final collectorCenter = position +
        const Offset(
          (bagWidgetWidth - collectorBagWidth) / 2,
          bagWidgetHeight - collectorBagHeight,
        );

    return Rect.fromLTWH(
      collectorCenter.dx,
      collectorCenter.dy,
      collectorBagWidth,
      collectorBagHeight,
    );
  }

  void _onCandyPositionChanged(String candyId) {
    final controller = candyControllers.firstWhereOrNull(
      (controller) => controller.id == candyId,
    );

    if (controller == null) return;

    final screenSize = MediaQuery.of(context).size;
    final rowCount = candyRowCount(context);
    final outerPadding = (screenSize.width - rowCount * candyRowWidth) / 2;

    final collectorRect = _collectorRect(bagPosition.value);

    final dx = (candyOuterPadding / 2) +
        (outerPadding) +
        controller.rowPosition * candyRowWidth;

    final dy = controller.dyPosition(screenSize.height, candySize);

    final candyRect = Rect.fromLTWH(
      dx,
      dy,
      candySize,
      candySize,
    );

    if (candyRect.overlaps(collectorRect)) {
      ref.read(candyMixerProvider.notifier).addCandy(controller.color);

      controller.startFadeOut();
    }
  }

  void _removeCandyController(String candyId) {
    final removedController = candyControllers.firstWhereOrNull(
      (controller) => controller.id == candyId,
    );

    if (removedController == null) return;

    candyControllers.remove(removedController);

    removedController.dispose();
  }
}

class BagWidget extends StatelessWidget {
  const BagWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/img/bag.png',
      width: bagWidgetWidth,
      height: bagWidgetHeight,
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

class CollectedCandiesWidget extends ConsumerStatefulWidget {
  const CollectedCandiesWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CollectedCandiesWidgetState();
}

class _CollectedCandiesWidgetState
    extends ConsumerState<CollectedCandiesWidget> {
  late List<ConfettiController> _confettiControllers;

  @override
  void initState() {
    super.initState();
    final limit = ref.read(candyMixerProvider.notifier).limit;

    _confettiControllers = List.generate(
      limit,
      (index) =>
          ConfettiController(duration: const Duration(milliseconds: 300)),
    );
  }

  @override
  void dispose() {
    for (var controller in _confettiControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      candyMixerProvider,
      (previous, next) {
        if (next.portions.length <=
            ref.read(candyMixerProvider.notifier).limit) {
          final controller = _confettiControllers[next.portions.length - 1];

          controller.play();
        }
      },
    );

    final box = ref.watch(candyMixerProvider);
    final limit = ref.watch(candyMixerProvider.notifier).limit;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < limit; i++)
          SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.antiAlias,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: const Color(0x4C035D20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    switchInCurve: Curves.bounceOut,
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: box.portions[i] != null
                        ? Image.asset(
                            'assets/img/${box.portions[i]!.name.toLowerCase()}.png',
                            width: 100,
                          )
                        : const SizedBox(width: 100, height: 100),
                  ),
                ),
                // TODO(payam): checkout the performance on raspberry pi
                Center(
                  child: ConfettiWidget(
                    confettiController: _confettiControllers[i],
                    blastDirectionality: BlastDirectionality.explosive,
                    shouldLoop: false,
                    numberOfParticles: 20,
                    gravity: 0.5,
                    colors: const [
                      Colors.green,
                      Colors.blue,
                      Colors.red,
                      Colors.yellow,
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
