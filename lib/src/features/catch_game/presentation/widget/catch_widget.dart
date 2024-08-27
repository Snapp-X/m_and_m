import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_and_m/src/core/domain/model/candy_box.dart';
import 'package:m_and_m/src/features/catch_game/presentation/page/catch_game_page.dart';
import 'package:m_and_m/src/features/catch_game/presentation/provider/catch_game_const.dart';
import 'package:m_and_m/src/features/mix/presentation/provider/mix_provider.dart';

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
          final index = next.portions.length - 1;

          final expectedCandyBox = ref.read(expectedCandyBoxProvider);

          if (next.portions[index]! == expectedCandyBox.portions[index]!) {
            final controller = _confettiControllers[index];
            controller.play();
          }
        }
      },
    );

    final expectedBox = ref.read(expectedCandyBoxProvider);
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
                        : Opacity(
                            opacity: 0.4,
                            child: Image.asset(
                              'assets/img/${expectedBox.portions[i]!.name.toLowerCase()}.png',
                              width: 100,
                            ),
                          ),
                  ),
                ),
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
