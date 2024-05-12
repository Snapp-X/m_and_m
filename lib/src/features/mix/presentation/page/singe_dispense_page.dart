import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_and_m/src/core/presentation/routing/routes.dart';
import 'package:m_and_m/src/core/presentation/widget/body_container.dart';
import 'package:m_and_m/src/core/presentation/widget/spin_out_progress.dart';
import 'package:m_and_m/src/core/presentation/widget/nue_button.dart';
import 'package:m_and_m/src/core/domain/model/candy_box.dart';
import 'package:m_and_m/src/features/mix/presentation/provider/mix_provider.dart';
import 'package:m_and_m/src/features/mix/presentation/provider/single_dispense_provider.dart';
import 'package:m_and_m/src/features/result/presentation/page/result_page.dart';
import 'package:neumorphic_ui/neumorphic_ui.dart';
import 'package:recase/recase.dart';

class SingleDispensePage extends ConsumerStatefulWidget {
  const SingleDispensePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SingleDispensePageState();
}

class _SingleDispensePageState extends ConsumerState<SingleDispensePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ref.read(candyMixerProvider.notifier).addAllCandies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff24272C),
      body: BodyContainer(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 120.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: SizedBox(
                    width: 840,
                    child: Text(
                      'Choose how many M&Ms you want to dispense. You can choose up to 4 portions of M&Ms at a time. ',
                      style: TextStyle(
                        color: Color(0xf17F8493),
                        fontSize: 30,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ref.watch(singleDispenseProvider).toString(),
                    style: const TextStyle(
                      color: Color(0xf17F8493),
                      fontSize: 30,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 12.0,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 36.0),
                  overlayShape:
                      const RoundSliderOverlayShape(overlayRadius: 48.0),
                  activeTrackColor: const Color(0xffFDDD02),
                  inactiveTrackColor: const Color(0xff7F8493),
                  thumbColor: const Color(0xffFDDD02),
                  overlayColor: const Color(0xffFDDD02).withOpacity(.3),
                  showValueIndicator: ShowValueIndicator.never,
                ),
                child: Slider(
                  value: ref.watch(singleDispenseProvider).toDouble(),
                  onChanged: (value) {
                    ref
                        .read(singleDispenseProvider.notifier)
                        .updatePortionSize(value.toInt());
                    log(value.toString());
                  },
                  min: 0,
                  max: 4,
                  divisions: 4,
                ),
              ),
              const SizedBox(height: 80),
              const MixButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class CandyWidget extends StatelessWidget {
  const CandyWidget({
    super.key,
    required this.candyColor,
    this.onPressed,
  });

  final CandyColor candyColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final candyImageName = 'assets/img/${candyColor.name}_alt.png';

    return Column(
      children: [
        Image.asset(
          candyImageName,
          width: 220,
          height: 220,
        ),
        const SizedBox(height: 50),
        CandyButton(
          color: candyColor,
          onPressed: onPressed,
        ),
      ],
    );
  }
}

class CandyButton extends StatelessWidget {
  const CandyButton({
    super.key,
    required this.color,
    this.onPressed,
  });

  final CandyColor color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final gradientColors = switch (color) {
      CandyColor.blue => const [Color(0xff0079c0), Color(0xff004b77)],
      CandyColor.yellow => const [Color(0xffffd302), Color(0xffcfac02)],
      CandyColor.green => const [Color(0xff48a25a), Color(0xff377d45)],
      CandyColor.red => const [Color(0xffe11a31), Color(0xffae1426)],
    };

    return NueButton(
      size: 110,
      onPressed: onPressed,
      gradient: gradientColors,
      child: Text(
        color.name.sentenceCase,
        style: const TextStyle(
          color: Colors.white54,
          fontSize: 26,
          height: 1,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}

class MixButton extends ConsumerStatefulWidget {
  const MixButton({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MixButtonState();
}

class _MixButtonState extends ConsumerState<MixButton>
    with TickerProviderStateMixin {
  late final SpinOutProgressController _progressAnimationController;

  @override
  void initState() {
    super.initState();
    _progressAnimationController = SpinOutProgressController(vsync: this);

    _progressAnimationController.moveOutController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        onProcessCompleted();
      }
    });
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(candyMixerProvider, (previous, next) {
      _progressAnimationController.addColor(next.portions.values.last.color);
    });

    return SizedBox(
      width: 170,
      height: 170,
      child: SpinOutProgress(
        controller: _progressAnimationController,
        child: NueButton(
          size: 200,
          color: const Color(0xff24272C),
          onPressed: onMixButtonPressed,
          child: Text(
            'Mix',
            style: TextStyle(
              color: const Color(0xf17F8493).withOpacity(.7),
              fontSize: 36,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  void onMixButtonPressed() {
    _progressAnimationController.startMoveOutAnimation();
  }

  void onProcessCompleted() {
    final candyBox = ref.read(candyMixerProvider);
    final numberOfPortions = ref.read(singleDispenseProvider);

    ResultPageRoute(ResultPageArgs(
            candyBox: candyBox, numberOfPortions: numberOfPortions))
        .go(context);
  }
}
