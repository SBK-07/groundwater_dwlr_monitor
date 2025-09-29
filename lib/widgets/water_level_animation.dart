import 'package:flutter/material.dart';
import 'dart:math';


class WaterLevelAnimation extends StatefulWidget {
  final double waterLevel;
  const WaterLevelAnimation({super.key, required this.waterLevel});

  @override
  State<WaterLevelAnimation> createState() => _WaterLevelAnimationState();
}

class _WaterLevelAnimationState extends State<WaterLevelAnimation>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _waterController;
  late Animation<double> _waterAnimation;

  @override
  void initState() {
    super.initState();

    // Water level rise animation
    _waterController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _waterAnimation = Tween<double>(begin: 0, end: widget.waterLevel).animate(
      CurvedAnimation(parent: _waterController, curve: Curves.easeOut),
    );
    _waterController.forward();

    // Wave motion animation
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _waterController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_waveController, _waterController]),
      builder: (context, child) {
        return CustomPaint(
          size: const Size(120, 250),
          painter: WellPainter(
            waterLevel: _waterAnimation.value,
            wavePhase: _waveController.value * 2 * pi,
          ),
        );
      },
    );
  }

}

class WellPainter extends CustomPainter {
  final double waterLevel;
  final double wavePhase;
  WellPainter({required this.waterLevel, this.wavePhase = 0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, paint);

    final level = (1 - (waterLevel / 10)) * size.height;

    final waterPaint = Paint()
      ..color = Colors.blue.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    // Draw 10 m label at top-left
    final maxTextPainter = TextPainter(
      text: const TextSpan(
        text: '10 m',
        style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );
    maxTextPainter.layout(minWidth: 0, maxWidth: size.width);
    maxTextPainter.paint(canvas, const Offset(2, 2));

    // Draw water wave
    final path = Path();
    for (double x = 0; x <= size.width; x++) {
      final y = level + 5 * sin((x / size.width * 2 * pi) + wavePhase);
      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, waterPaint);

    // Water level text
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${waterLevel.toStringAsFixed(2)} m',
        style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(minWidth: 0, maxWidth: size.width);
    textPainter.paint(
      canvas,
      Offset(size.width / 2 - textPainter.width / 2, level - 20),
    );
  }

  @override
  bool shouldRepaint(covariant WellPainter oldDelegate) => true;
}
