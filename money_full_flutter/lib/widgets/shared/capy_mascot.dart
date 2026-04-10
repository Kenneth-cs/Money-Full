import 'package:flutter/material.dart';

/// 卡皮管家吉祥物组件 - 用CustomPainter绘制，无需图片资源
class CapyMascot extends StatefulWidget {
  const CapyMascot({super.key});

  @override
  State<CapyMascot> createState() => _CapyMascotState();
}

class _CapyMascotState extends State<CapyMascot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: 0, end: -4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value),
          child: SizedBox(
            width: 72,
            height: 72,
            child: CustomPaint(painter: _CapyPainter()),
          ),
        );
      },
    );
  }
}

class _CapyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 橘子（头顶）
    final orangePaint = Paint()..color = const Color(0xFFFF9F00);
    canvas.drawCircle(Offset(w * 0.5, h * 0.18), h * 0.1, orangePaint);

    // 橘子叶
    final leafPaint = Paint()
      ..color = const Color(0xFF2C6956)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final leafPath = Path();
    leafPath.moveTo(w * 0.5, h * 0.08);
    leafPath.quadraticBezierTo(w * 0.6, h * 0.02, w * 0.65, h * 0.1);
    canvas.drawPath(leafPath, leafPaint);

    // 身体（圆角矩形）
    final bodyPaint = Paint()..color = const Color(0xFFB08968);
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.2, h * 0.28, w * 0.6, h * 0.62),
      Radius.circular(w * 0.25),
    );
    canvas.drawRRect(bodyRect, bodyPaint);

    // 耳朵
    final earPaint = Paint()..color = const Color(0xFF7F5539);
    canvas.drawCircle(Offset(w * 0.2, h * 0.42), h * 0.06, earPaint);
    canvas.drawCircle(Offset(w * 0.8, h * 0.42), h * 0.06, earPaint);

    // 鼻口区域
    final snoutPaint = Paint()..color = const Color(0xFF9C6644);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.72), width: w * 0.36, height: h * 0.22),
      snoutPaint,
    );

    // 鼻子线条
    final nosePaint = Paint()
      ..color = const Color(0xFF4A3022)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final nosePath = Path();
    nosePath.moveTo(w * 0.43, h * 0.66);
    nosePath.quadraticBezierTo(w * 0.5, h * 0.72, w * 0.57, h * 0.66);
    canvas.drawPath(nosePath, nosePaint);

    // 眼睛（微闭）
    final eyePaint = Paint()
      ..color = const Color(0xFF4A3022)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    final leftEye = Path();
    leftEye.moveTo(w * 0.3, h * 0.5);
    leftEye.quadraticBezierTo(w * 0.36, h * 0.47, w * 0.42, h * 0.5);
    canvas.drawPath(leftEye, eyePaint);
    final rightEye = Path();
    rightEye.moveTo(w * 0.58, h * 0.5);
    rightEye.quadraticBezierTo(w * 0.64, h * 0.47, w * 0.7, h * 0.5);
    canvas.drawPath(rightEye, eyePaint);

    // 腮红
    final blushPaint = Paint()..color = const Color(0xFFFF7F50).withOpacity(0.6);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.3, h * 0.6), width: w * 0.1, height: h * 0.06), blushPaint);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.7, h * 0.6), width: w * 0.1, height: h * 0.06), blushPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
