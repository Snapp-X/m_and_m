import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_and_m/src/core/presentation/widget/body_container.dart';
import 'package:m_and_m/src/core/presentation/widget/enter_gradient_progress.dart';
import 'package:m_and_m/src/features/mix/domain/model/candy_box.dart';

class ResultPage extends ConsumerWidget {
  const ResultPage({super.key, required this.candyBox});

  final CandyBox candyBox;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xff24272C),
      body: BodyContainer(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QrCodeWidget(candyBox: candyBox),
              const SizedBox(height: 60),
              const Text(
                "Explore our Flutter project by scanning the QR code to access its \nGitHub repository. We're excited to see what you create with our \nproject—share it on social media by tagging us \n@SnappEmbedded. We look forward to your contributions!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xf17F8493),
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class QrCodeWidget extends StatefulWidget {
  const QrCodeWidget({super.key, required this.candyBox});

  final CandyBox candyBox;

  @override
  State<StatefulWidget> createState() => _QrCodeWidgetState();
}

class _QrCodeWidgetState extends State<QrCodeWidget>
    with TickerProviderStateMixin {
  late final EnterGradientController _progressAnimationController;
  double qrCodeOpacity = 0;

  @override
  void initState() {
    super.initState();
    print('Mix Button init');

    _progressAnimationController = EnterGradientController(
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
    return EnterGradientProgress(
      controller: _progressAnimationController,
      child: Container(
        width: 160,
        height: 160,
        decoration: ShapeDecoration(
          color: const Color(0xFF24272C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
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
        child: AnimatedOpacity(
          opacity: qrCodeOpacity,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOut,
          child: const Padding(
            padding: EdgeInsets.all(32.0),
            child: FlutterLogo(style: FlutterLogoStyle.stacked),
          ),
        ),
      ),
    );
  }

  void onAnimationCompleted() {
    setState(() {
      qrCodeOpacity = 1;
    });
  }
}
