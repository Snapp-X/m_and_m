import 'package:flutter/material.dart';

class BodyContainer extends StatelessWidget {
  const BodyContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xff24272C),
          borderRadius: BorderRadius.all(Radius.circular(50)),
          boxShadow: [
            BoxShadow(
              color: Colors.white24,
              offset: Offset(-4, -4),
              blurRadius: 4,
            ),
            BoxShadow(
              color: Colors.black26,
              offset: Offset(4, 4),
              blurRadius: 4,
            ),
          ],
        ),
        margin: const EdgeInsets.all(30),
        padding: const EdgeInsets.all(30),
        child: child,
      ),
    );
  }
}
