import 'dart:developer';

import 'package:flutter/material.dart';

class NueButton extends StatefulWidget {
  const NueButton({
    super.key,
    required this.size,
    this.color,
    this.gradient,
    this.holderGradient,
    this.borderGradient,
    this.boxShadow,
    this.innerShadow,
    this.onPressed,
    this.child,
  }) : assert(color != null || gradient != null);

  final double size;
  final Color? color;
  final List<Color>? gradient;
  final List<Color>? holderGradient;
  final List<Color>? borderGradient;
  final List<BoxShadow>? boxShadow;
  final List<BoxShadow>? innerShadow;
  final VoidCallback? onPressed;
  final Widget? child;

  @override
  State<NueButton> createState() => _NueButtonState();
}

class _NueButtonState extends State<NueButton> {
  final ValueNotifier<bool> _isPressed = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        log('onTapDown');
        _isPressed.value = true;
      },
      onTapUp: (details) {
        log('onTapUp');
        _isPressed.value = false;
        widget.onPressed?.call();
      },
      onTapCancel: () {
        log('onTapCancel');
        _isPressed.value = false;
      },
      child: ValueListenableBuilder(
        valueListenable: _isPressed,
        builder: (context, isPressed, child) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 50),
            curve: Curves.easeOut,
            height: widget.size,
            width: widget.size,
            padding: const EdgeInsets.all(6.5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: widget.holderGradient != null
                  ? null
                  : Border.all(
                      color: Colors.black12,
                      width: 1,
                    ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: widget.holderGradient ??
                    const [
                      Color(0xff2B2F33),
                      Color(0xff101113),
                    ],
              ),
              boxShadow: !isPressed
                  ? widget.boxShadow ??
                      const [
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
                      ]
                  : null,
            ),
            child: child,
          );
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color,
                gradient: (widget.gradient?.isEmpty ?? true)
                    ? null
                    : LinearGradient(
                        begin: const Alignment(-0.6, -0.6),
                        end: Alignment.bottomRight,
                        colors: widget.gradient!,
                      ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: widget.borderGradient ??
                      [
                        Colors.white12,
                        Colors.black12,
                      ],
                ),
                boxShadow: widget.innerShadow ??
                    const [
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
                color: widget.color,
                gradient: (widget.gradient?.isEmpty ?? true)
                    ? null
                    : LinearGradient(
                        begin: Alignment.bottomRight,
                        end: const Alignment(-0.6, -0.6),
                        colors: widget.gradient!,
                      ),
              ),
              alignment: Alignment.center,
              child: widget.child,
            ),
          ],
        ),
      ),
    );
  }
}
