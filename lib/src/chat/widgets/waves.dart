import 'dart:math';

import 'package:flutter/material.dart';

class PurpleCircleAnimation extends StatefulWidget {
  const PurpleCircleAnimation({Key? key}) : super(key: key);

  @override
  _PurpleCircleAnimationState createState() => _PurpleCircleAnimationState();
}

class _PurpleCircleAnimationState extends State<PurpleCircleAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 15),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _PurpleCirclePainter(_controller.value),
          size: MediaQuery.of(context).size,
          child: child,
        );
      },
    );
  }
}

class _PurpleCirclePainter extends CustomPainter {
  _PurpleCirclePainter(this.animationValue) {
    final Random random = Random();

    for (var i = 0; i < 5; i++) {
      final radius = random.nextDouble() * 100.0;
      final x = random.nextDouble() * 300.0;
      final y = random.nextDouble() * 300.0;
      final color = Color.fromRGBO(
        160 + random.nextInt(96),
        81 + random.nextInt(96),
        186 + random.nextInt(69),
        0.5,
      );

      _circles.add(_Circle(
        radius: radius,
        position: Offset(x, y),
        color: color,
        angle: random.nextDouble() * 4 * pi,
        speed: random.nextDouble() * 50.0 + 50.0,
      ));
    }
  }

  final double animationValue;
  final List<_Circle> _circles = [];

  @override
  void paint(Canvas canvas, Size size) {
    for (final circle in _circles) {
      final angle = circle.angle + circle.speed * animationValue * pi / 180;
      final x = circle.position.dx + circle.radius * cos(angle);
      final y = circle.position.dy + circle.radius * sin(angle);

      final circlePaint = Paint()..color = circle.color;

      canvas.drawCircle(Offset(x, y), circle.radius, circlePaint);
    }
  }

  @override
  bool shouldRepaint(_PurpleCirclePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

class _Circle {
  _Circle({
    required this.radius,
    required this.position,
    required this.color,
    required this.angle,
    required this.speed,
  });

  final double radius;
  final Offset position;
  final Color color;
  final double angle;
  final double speed;
}
