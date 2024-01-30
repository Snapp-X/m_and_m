import 'package:neumorphic_ui/neumorphic_ui.dart';

class BodyContainer extends StatelessWidget {
  const BodyContainer({
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
