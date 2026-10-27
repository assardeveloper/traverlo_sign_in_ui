import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'sign_in_widgets.dart';

// Fades, slides and slightly scales a child in when its slot in the entrance timeline is reached
class FadeSlideIn extends StatelessWidget {
  const FadeSlideIn({
    super.key,
    required this.controller,
    required this.index,
    required this.child,
    this.step = 0.06,
  });

  final AnimationController controller;
  final int index;
  final double step;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final start = (index * step).clamp(0.0, 0.6);
    final animation = CurvedAnimation(
      parent: controller,
      curve: Interval(start, start + 0.4, curve: Curves.easeOutBack),
    );

    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        final t = animation.value;
        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 40 * (1 - t)),
            child: Transform.scale(scale: 0.94 + 0.06 * t, child: child),
          ),
        );
      },
    );
  }
}

// Sky gradient that slowly breathes, a soft light drifting across the top and twinkling stars
class AnimatedSkyBackground extends StatefulWidget {
  const AnimatedSkyBackground({super.key, required this.child});

  final Widget child;

  @override
  State<AnimatedSkyBackground> createState() => _AnimatedSkyBackgroundState();
}

class _AnimatedSkyBackgroundState extends State<AnimatedSkyBackground> with TickerProviderStateMixin {
  late final AnimationController _breath = AnimationController(
    vsync: this,
    duration: Duration(seconds: 7),
  )..repeat(reverse: true);

  late final AnimationController _twinkle = AnimationController(
    vsync: this,
    duration: Duration(seconds: 4),
  )..repeat();

  @override
  void dispose() {
    _breath.dispose();
    _twinkle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedBuilder(
          animation: _breath,
          builder: (context, _) {
            final t = Curves.easeInOut.transform(_breath.value);
            return DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(-0.4 + 0.8 * t, -1),
                  end: Alignment(0.4 - 0.8 * t, 1),
                  colors: [kSkyTop, Color.lerp(kSkyTop, kSkyBottom, 0.5 + 0.1 * t)!, kSkyBottom],
                  stops: [0, 0.45 + 0.1 * t, 1],
                ),
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(-0.9 + 1.8 * t, -1.1),
                    radius: 0.9,
                    colors: [Colors.white.withValues(alpha: 0.2), Colors.transparent],
                  ),
                ),
              ),
            );
          },
        ),
        IgnorePointer(
          child: RepaintBoundary(
            child: CustomPaint(painter: TwinklingSparkles(_twinkle)),
          ),
        ),
        widget.child,
      ],
    );
  }
}

// Four-point stars that pulse in size and brightness, each on its own phase, and float gently
class TwinklingSparkles extends CustomPainter {
  TwinklingSparkles(this.animation) : super(repaint: animation);

  final Animation<double> animation;

  // x, y, radius, phase
  static const _stars = [
    (0.08, 0.07, 7.0, 0.0),
    (0.2, 0.12, 4.0, 0.3),
    (0.12, 0.2, 5.0, 0.6),
    (0.85, 0.16, 4.0, 0.15),
    (0.3, 0.04, 3.0, 0.8),
    (0.92, 0.06, 5.0, 0.45),
    (0.7, 0.1, 3.0, 0.7),
    (0.9, 0.42, 3.0, 0.25),
    (0.05, 0.55, 4.0, 0.9),
    (0.94, 0.7, 4.0, 0.55),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final (x, y, r, phase) in _stars) {
      final wave = math.sin((animation.value + phase) * math.pi * 2);
      final pulse = 0.5 + 0.5 * wave;
      final radius = r * (0.55 + 0.6 * pulse);
      final c = Offset(size.width * x, size.height * y + 4 * wave);

      // Soft halo behind the star
      paint
        ..color = Colors.yellow.withValues(alpha: 0.18 * pulse)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawCircle(c, radius * 1.4, paint);

      paint
        ..color = Colors.yellow.withValues(alpha: 0.35 + 0.55 * pulse)
        ..maskFilter = null;
      final path = Path()
        ..moveTo(c.dx, c.dy - radius)
        ..quadraticBezierTo(c.dx, c.dy, c.dx + radius, c.dy)
        ..quadraticBezierTo(c.dx, c.dy, c.dx, c.dy + radius)
        ..quadraticBezierTo(c.dx, c.dy, c.dx - radius, c.dy)
        ..quadraticBezierTo(c.dx, c.dy, c.dx, c.dy - radius);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant TwinklingSparkles oldDelegate) => false;
}

// Glowing ripple that keeps pulsing out from behind the child, used on the logo
class PulseGlow extends StatefulWidget {
  const PulseGlow({super.key, required this.child, this.color = kTeal, this.size = 30});

  final Widget child;
  final Color color;
  final double size;

  @override
  State<PulseGlow> createState() => _PulseGlowState();
}

class _PulseGlowState extends State<PulseGlow> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 2000),
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
      child: widget.child,
      builder: (context, child) {
        final t = Curves.easeOut.transform(_controller.value);
        return Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Container(
              width: widget.size * (1 + 0.8 * t),
              height: widget.size * (1 + 0.8 * t),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: widget.color.withValues(alpha: 0.6 * (1 - t)), width: 2),
              ),
            ),
            Transform.rotate(angle: 0.25 * math.sin(_controller.value * math.pi * 2), child: child),
          ],
        );
      },
    );
  }
}

// Shrinks a child slightly while it is being pressed
class PressScale extends StatefulWidget {
  const PressScale({super.key, required this.child});

  final Widget child;

  @override
  State<PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<PressScale> {
  bool _pressed = false;

  void _set(bool value) => setState(() => _pressed = value);

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _set(true),
      onPointerUp: (_) => _set(false),
      onPointerCancel: (_) => _set(false),
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1,
        duration: Duration(milliseconds: 140),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

// A light band that sweeps across the child every few seconds
class Shimmer extends StatefulWidget {
  const Shimmer({super.key, required this.child, this.radius = 27});

  final Widget child;
  final double radius;

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 3000),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: IgnorePointer(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(widget.radius),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  // Sweep during the first half, rest during the second
                  final t = Curves.easeInOut.transform((_controller.value * 2).clamp(0.0, 1.0));
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.white.withValues(alpha: 0.55), Colors.transparent],
                        stops: [0.4, 0.5, 0.6],
                        begin: Alignment(-1, -0.4),
                        end: Alignment(1, 0.4),
                        transform: _SlideGradient(-1.2 + 2.4 * t),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SlideGradient extends GradientTransform {
  const _SlideGradient(this.percent);

  final double percent;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * percent, 0, 0);
  }
}

// Gives a quick springy pop whenever [trigger] flips to true
class PopOnSelect extends StatelessWidget {
  const PopOnSelect({super.key, required this.trigger, required this.child});

  final bool trigger;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(trigger),
      tween: Tween(begin: trigger ? 0.6 : 1, end: 1),
      duration: Duration(milliseconds: 500),
      curve: Curves.elasticOut,
      child: child,
      builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
    );
  }
}
