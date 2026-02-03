import 'package:flutter/material.dart';
import 'dart:math';

class FloatingHeart {
  double x;
  double y;
  final double size;
  final double speed;
  final double opacity;

  FloatingHeart({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}

class FloatingHeartsPainter extends CustomPainter {
  final List<FloatingHeart> hearts;
  final double progress;

  FloatingHeartsPainter({required this.hearts, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (var heart in hearts) {
      final y = (heart.y + progress * heart.speed) % 1.2 - 0.1;
      final x = heart.x + sin(progress * 2 * pi + heart.y * 10) * 0.02;

      textPainter.text = TextSpan(
        text: '💗',
        style: TextStyle(
          fontSize: heart.size,
          color: Colors.white.withValues(alpha: heart.opacity),
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x * size.width, y * size.height),
      );
    }
  }

  @override
  bool shouldRepaint(covariant FloatingHeartsPainter oldDelegate) => true;
}
