import 'package:flutter/material.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final double progress; // 0.0 - 1.0
  final String label;

  const ProgressIndicatorWidget({
    super.key,
    required this.progress,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 95,
          height: 95,
          child: CustomPaint(
            painter: _RoundedProgressPainter(progress),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10)),
            Text('${(progress).toStringAsFixed(0)}%', style: Theme.of(context).textTheme.titleSmall),
          ],
        ),
      ],
    );
  }
}

class _RoundedProgressPainter extends CustomPainter {
  final double progress;

  _RoundedProgressPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    const double strokeWidth = 10.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final backgroundPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final progressPaint = Paint()
      ..color = const Color(0xFF1D9F9B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    const startAngle = -90.0 * 3.1415927 / 180;
    final sweepAngle = 2 * 3.1415927 * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_RoundedProgressPainter oldDelegate) => oldDelegate.progress != progress;
}
