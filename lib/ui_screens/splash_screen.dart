import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:names_app/Bloc/NameBloc/names_bloc.dart';
import 'package:names_app/DataBase/SharedPrefrences.dart';
import 'package:names_app/theme/app_theme.dart';
import 'package:names_app/ui_screens/home/main_shell.dart';
import 'package:names_app/widgets/islamic_pattern.dart';

class SplashScreen extends StatefulWidget {
  static int? appopenedCounts;

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Keep the brand on screen long enough to register, but never hold the
  // user hostage if data loading stalls.
  static const _minDuration = Duration(milliseconds: 2400);
  static const _maxDuration = Duration(seconds: 8);

  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..forward();

  late final AnimationController _spin = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 24),
  )..repeat();

  late final Animation<double> _logoScale = CurvedAnimation(
    parent: _intro,
    curve: const Interval(0, 0.6, curve: Curves.easeOutBack),
  );
  late final Animation<double> _logoFade = CurvedAnimation(
    parent: _intro,
    curve: const Interval(0, 0.4, curve: Curves.easeOut),
  );
  late final Animation<double> _textFade = CurvedAnimation(
    parent: _intro,
    curve: const Interval(0.4, 0.9, curve: Curves.easeOut),
  );

  bool _minElapsed = false;
  bool _dataReady = false;
  bool _navigated = false;
  Timer? _minTimer;
  Timer? _maxTimer;

  @override
  void initState() {
    super.initState();

    final bloc = context.read<NamesBloc>();
    _dataReady = bloc.state is NamesSuccess;
    bloc.add(GetNames());
    _countAppOpens();

    _minTimer = Timer(_minDuration, () {
      _minElapsed = true;
      _maybeContinue();
    });
    _maxTimer = Timer(_maxDuration, _goHome);
  }

  Future<void> _countAppOpens() async {
    final stored = await SharedPreference.getString(
      SharedPreference.appOpenedCount,
    );
    final previous = stored.isEmpty ? 0 : int.parse(stored);
    SplashScreen.appopenedCounts = previous;
    SharedPreference.saveString(
      SharedPreference.appOpenedCount,
      (previous + 1).toString(),
    );
  }

  void _maybeContinue() {
    if (_minElapsed && _dataReady) _goHome();
  }

  void _goHome() {
    if (_navigated || !mounted) return;
    _navigated = true;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (_, __, ___) => const MainShell(),
        transitionsBuilder: (_, animation, __, child) => FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: child,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _minTimer?.cancel();
    _maxTimer?.cancel();
    _intro.dispose();
    _spin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NamesBloc, NamesState>(
      listener: (context, state) {
        if (state is NamesSuccess) {
          _dataReady = true;
          _maybeContinue();
        }
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            const PatternedGradient(opacity: 0.07),
            // Soft glow behind the logo.
            Center(
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.gold.withValues(alpha: 0.22),
                      AppColors.gold.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 5),
                  FadeTransition(
                    opacity: _logoFade,
                    child: ScaleTransition(
                      scale: _logoScale,
                      child: _LogoMark(rotation: _spin),
                    ),
                  ),
                  const SizedBox(height: 36),
                  FadeTransition(
                    opacity: _textFade,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.25),
                        end: Offset.zero,
                      ).animate(_textFade),
                      child: Column(
                        children: [
                          Text(
                            'Islamic Names',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(
                                  color: AppColors.gold,
                                  fontSize: 38,
                                ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '20,000+ names for Muslim boys & girls',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.78),
                              fontSize: 15,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(flex: 4),
                  FadeTransition(
                    opacity: _textFade,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 140,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              minHeight: 4,
                              color: AppColors.gold,
                              backgroundColor:
                                  Colors.white.withValues(alpha: 0.16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Preparing your names…',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Gold eight-pointed star with a crescent at its heart.
class _LogoMark extends StatelessWidget {
  const _LogoMark({required this.rotation});

  final Animation<double> rotation;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 168,
      height: 168,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: rotation,
            builder: (_, __) => Transform.rotate(
              angle: rotation.value * 2 * math.pi,
              child: CustomPaint(
                size: const Size(168, 168),
                painter: _StarPainter(
                  color: AppColors.gold.withValues(alpha: 0.35),
                  filled: false,
                  scale: 1,
                ),
              ),
            ),
          ),
          CustomPaint(
            size: const Size(140, 140),
            painter: const _StarPainter(
              color: AppColors.gold,
              filled: true,
              scale: 1,
            ),
          ),
          Container(
            width: 84,
            height: 84,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.plumDeep,
            ),
            child: const Icon(
              Icons.nightlight_round,
              size: 46,
              color: AppColors.gold,
            ),
          ),
        ],
      ),
    );
  }
}

class _StarPainter extends CustomPainter {
  const _StarPainter({
    required this.color,
    required this.filled,
    required this.scale,
  });

  final Color color;
  final bool filled;
  final double scale;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r1 = size.width / 2 * scale;
    final r2 = r1 * 0.74;
    final path = Path();
    for (var i = 0; i < 16; i++) {
      final r = i.isEven ? r1 : r2;
      final a = math.pi / 8 * i - math.pi / 2;
      final p = Offset(c.dx + r * math.cos(a), c.dy + r * math.sin(a));
      i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    path.close();

    final paint = Paint()
      ..color = color
      ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = 1.5;
    if (filled) {
      paint.shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.gold, AppColors.goldDeep],
      ).createShader(Rect.fromCircle(center: c, radius: r1));
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_StarPainter old) =>
      old.color != color || old.filled != filled;
}
