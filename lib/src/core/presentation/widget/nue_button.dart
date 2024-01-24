
import 'package:flutter/material.dart';

class NueButton extends StatelessWidget {
  const NueButton({
    super.key,
    required this.size,
    this.child,
    this.color,
    this.gradient,
  }) : assert(color != null || gradient != null);

  final double size;
  final Widget? child;
  final Color? color;
  final List<Color>? gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      padding: const EdgeInsets.all(6.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.black12,
          width: 1,
        ),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xff2B2F33),
            Color(0xff101113),
          ],
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            offset: Offset(18, 18),
            blurRadius: 36,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.white10,
            offset: Offset(-18, -18),
            blurRadius: 36,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              gradient: (gradient?.isEmpty ?? true)
                  ? null
                  : LinearGradient(
                      begin: const Alignment(-0.6, -0.6),
                      end: Alignment.bottomRight,
                      colors: gradient!,
                    ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white12,
                  Colors.black12,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(6, 6),
                  blurRadius: 12,
                  spreadRadius: 0,
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              gradient: (gradient?.isEmpty ?? true)
                  ? null
                  : LinearGradient(
                      begin: Alignment.bottomRight,
                      end: const Alignment(-0.6, -0.6),
                      colors: gradient!,
                    ),
            ),
            alignment: Alignment.center,
            child: child,
          ),
        ],
      ),
    );
  }
}