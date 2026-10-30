import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:names_app/theme/app_theme.dart';

/// Tiles of eight-pointed stars (khatim) drawn as thin outlines.
class IslamicPatternPainter extends CustomPainter {
  IslamicPatternPainter({
    this.color = Colors.white,
    this.opacity = 0.08,
    this.cell = 56,
  });

  final Color color;
  final double opacity;
  final double cell;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final outer = cell * 0.46;
    final inner = outer * 0.62;

    for (double y = 0; y < size.height + cell; y += cell) {
      for (double x = 0; x < size.width + cell; x += cell) {
        _star(canvas, Offset(x, y), outer, inner, paint);
        // Offset half-cell diamond to link the stars into a lattice.
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(x + cell / 2, y + cell / 2),
            width: cell * 0.2,
            height: cell * 0.2,
          ),
          paint,
        );
      }
    }
  }

  void _star(Canvas canvas, Offset c, double r1, double r2, Paint paint) {
    final path = Path();
    for (var i = 0; i < 16; i++) {
      final r = i.isEven ? r1 : r2;
      final a = math.pi / 8 * i - math.pi / 2;
      final p = Offset(c.dx + r * math.cos(a), c.dy + r * math.sin(a));
      i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(IslamicPatternPainter old) =>
      old.color != color || old.opacity != opacity || old.cell != cell;
}

/// Plum gradient surface with a faint geometric pattern on top.
class PatternedGradient extends StatelessWidget {
  const PatternedGradient({
    super.key,
    this.child,
    this.borderRadius = BorderRadius.zero,
    this.padding,
    this.opacity = 0.08,
    this.gradient = AppColors.heroGradient,
  });

  final Gradient gradient;
  final Widget? child;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry? padding;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: borderRadius,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: CustomPaint(
          painter: IslamicPatternPainter(opacity: opacity),
          child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
        ),
      ),
    );
  }
}
