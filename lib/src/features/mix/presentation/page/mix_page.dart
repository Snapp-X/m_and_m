import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_and_m/src/core/presentation/widget/nue_button.dart';
import 'package:m_and_m/src/features/mix/domain/model/candy_box.dart';
import 'package:m_and_m/src/features/mix/presentation/provider/mix_provider.dart';
import 'package:neumorphic_ui/neumorphic_ui.dart';
import 'package:recase/recase.dart';

class MixPage extends ConsumerWidget {
  const MixPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final candyBox = ref.watch(candyMixerProvider);
    final isBoxFull = ref.watch(candyBoxIsFullProvider);

    return const Scaffold(
      backgroundColor: Color(0xff24272C),
      body: BodyHolder(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Dive into the M&M rainbow and handpick the hues that make your taste buds tango. Choose 4 times, feel free to double down on your faves, and and let the M&M magic unfold.',
              style: TextStyle(
                color: Color(0xf17F8493),
                fontSize: 24,
                fontWeight: FontWeight.normal,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CandyWidget(
                  candyColor: CandyColor.blue,
                ),
                CandyWidget(
                  candyColor: CandyColor.yellow,
                ),
                CandyWidget(
                  candyColor: CandyColor.green,
                ),
                CandyWidget(
                  candyColor: CandyColor.red,
                ),
              ],
            ),
            MixButton(),
          ],
        ),
      ),
    );
  }
}

class CandyWidget extends StatelessWidget {
  const CandyWidget({super.key, required this.candyColor});

  final CandyColor candyColor;
  @override
  Widget build(BuildContext context) {
    final candyImageName = 'assets/img/${candyColor.name}.png';
    return Column(
      children: [
        Image.asset(
          candyImageName,
          width: 250,
          height: 250,
        ),
        const SizedBox(height: 32),
        CandyButton(color: candyColor),
        const SizedBox(height: 12),
        Text(
          candyColor.name.sentenceCase,
          style: const TextStyle(
            color: Color(0xf17F8493),
            fontSize: 30,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class CandyButton extends StatelessWidget {
  const CandyButton({
    super.key,
    required this.color,
  });

  final CandyColor color;

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
      gradient: gradientColors,
    );
  }
}

class MixButton extends StatelessWidget {
  const MixButton({super.key});

  @override
  Widget build(BuildContext context) {
    return NueButton(
      size: 200,
      color: const Color(0xff24272C),
      child: Text(
        'Mix',
        style: TextStyle(
          color: const Color(0xf17F8493).withOpacity(.2),
          fontSize: 36,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class BodyHolder extends StatelessWidget {
  const BodyHolder({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: 5,
          intensity: 0.5,
          boxShape: NeumorphicBoxShape.roundRect(
            const BorderRadius.all(Radius.circular(50)),
          ),
          color: const Color(0xff24272C),
          shadowLightColor: Colors.white24,
          shadowDarkColor: Colors.black,
        ),
        margin: const EdgeInsets.all(30),
        padding: const EdgeInsets.all(30),
        child: child,
      ),
    );
  }
}
