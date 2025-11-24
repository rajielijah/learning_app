import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({
    super.key,
    required this.child,
    this.showOverlay = true,
  });

  final Widget child;
  final bool showOverlay;

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
      colors: [
        const Color(0xFF6C63FF),
        const Color(0xFF8E8BFF),
        const Color(0xFFFF6584),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: gradient,
      ),
      child: showOverlay
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.92),
                    Colors.white.withOpacity(0.75),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: child,
            )
          : child,
    );
  }
}

