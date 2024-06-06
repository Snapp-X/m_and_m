import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_and_m/src/core/presentation/provider/season_control_provider.dart';
import 'package:m_and_m/src/core/presentation/widget/body_container.dart';
import 'package:m_and_m/src/core/presentation/widget/spin_in_progress.dart';
import 'package:m_and_m/src/core/domain/model/candy_box.dart';
import 'package:m_and_m/src/features/result/presentation/provider/make_mix_provider.dart';

class ResultPage extends ConsumerWidget {
  const ResultPage({super.key, required this.args});

  final ResultPageArgs args;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xff24272C),
      body: BodyContainer(
        child: Stack(
          children: [
            Positioned(
              top: 20,
              right: 20,
              child: FloatingActionButton.large(
                elevation: 0,
                backgroundColor: Colors.white12,
                shape: const CircleBorder(),
                onPressed: () {
                  ref.read(seasonControlProvider.notifier).idle();
                },
                child: const Icon(
                  Icons.close_rounded,
                  size: 64,
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  QrCodeWidget(
                    candyBox: args.candyBox,
                    numberOfPortions: args.numberOfPortions,
                  ),
                  const SizedBox(height: 60),
                  const Text(
                    "Explore our Flutter project by scanning the QR code to access its \nGitHub repository. We're excited to see what you create with our \nproject—share it on social media by tagging us \n@SnappEmbedded. We look forward to your contributions!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xf17F8493),
                      fontSize: 30,
                      fontWeight: FontWeight.normal,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QrCodeWidget extends ConsumerStatefulWidget {
  const QrCodeWidget(
      {super.key, required this.candyBox, this.numberOfPortions});

  final CandyBox candyBox;
  final int? numberOfPortions;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QrCodeWidgetState();
}

class _QrCodeWidgetState extends ConsumerState<QrCodeWidget>
    with TickerProviderStateMixin {
  late final SpinInProgressController _progressAnimationController;

  final ValueNotifier<bool> _isQrCodeVisible = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _progressAnimationController = SpinInProgressController(
      vsync: this,
      colors: widget.candyBox.portions.values.map((e) => e.color).toList(),
    );

    _progressAnimationController.moveInAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        onAnimationCompleted();
      }
    });

    _progressAnimationController.startMoveInAnimation();
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mixResult = ref.watch(makeMixNotifierProvider);
    log('makeMixNotifierProvider: $mixResult', name: 'ResultPage');
// qr-code.png
    return SpinInProgress(
      controller: _progressAnimationController,
      child: Container(
        width: 230,
        height: 230,
        decoration: ShapeDecoration(
          color: const Color(0xFF24272C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(42),
          ),
          shadows: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 20,
              offset: Offset(5, 5),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.white24,
              blurRadius: 20,
              offset: Offset(-5, -5),
              spreadRadius: 0,
            )
          ],
        ),
        child: ValueListenableBuilder(
          valueListenable: _isQrCodeVisible,
          builder: (context, isQrCodeVisible, child) {
            return AnimatedOpacity(
              opacity: isQrCodeVisible ? 1 : 0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              child: child,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Image.asset(
                'assets/img/qr-code.png',
                width: 220,
                height: 220,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onAnimationCompleted() {
    _isQrCodeVisible.value = true;
    // ref.read(makeMixNotifierProvider.notifier).startMixing(widget.candyBox);
    ref
        .read(makeMixNotifierProvider.notifier)
        .startPortioning(widget.numberOfPortions ?? 0);
  }
}

class ResultPageArgs {
  const ResultPageArgs(
      {required this.candyBox, required this.numberOfPortions});

  final CandyBox candyBox;
  final int numberOfPortions;
}
