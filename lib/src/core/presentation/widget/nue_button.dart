import 'package:flutter/material.dart';

class NueButton extends StatefulWidget {
  const NueButton({
    super.key,
    required this.size,
    this.color,
    this.gradient,
    this.onPressed,
    this.child,
  }) : assert(color != null || gradient != null);

  final double size;
  final Color? color;
  final List<Color>? gradient;
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
      onTap: widget.onPressed,
      onTapDown: (details) {
        _isPressed.value = true;
      },
      onTapUp: (details) {
        _isPressed.value = false;
      },
      onTapCancel: () {
        _isPressed.value = false;
      },
      child: ValueListenableBuilder(
        valueListenable: _isPressed,
        builder: (context, isPressed, child) {
          print('isPressed: $isPressed');

          return AnimatedContainer(
            duration: const Duration(milliseconds: 50),
            height: widget.size,
            width: widget.size,
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
              boxShadow: !isPressed
                  ? const [
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
