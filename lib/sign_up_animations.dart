import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:youtube_videos/sign_up_widgets.dart';

// Fades and slides a child up when its slot in the entrance timeline is reached
class FadeSlideIn extends StatelessWidget {
  const FadeSlideIn({
    super.key,
    required this.controller,
    required this.index,
    required this.child,
    this.step = 0.07,
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
      curve: Interval(start, start + 0.4, curve: Curves.easeOutCubic),
    );

    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        final t = animation.value;
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, 36 * (1 - t)),
            child: Transform.scale(scale: 0.96 + 0.04 * t, child: child),
          ),
        );
      },
    );
  }
}

// Sky gradient that slowly breathes, with a soft light drifting across the top
class AnimatedSkyBackground extends StatefulWidget {
  const AnimatedSkyBackground({super.key, required this.child});

  final Widget child;

  @override
  State<AnimatedSkyBackground> createState() => _AnimatedSkyBackgroundState();
}

class _AnimatedSkyBackgroundState extends State<AnimatedSkyBackground> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(seconds: 6),
  )..repeat(reverse: true);

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
        final t = Curves.easeInOut.transform(_controller.value);
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [kSky, kTeal, kNight],
              stops: [0, 0.16 + 0.05 * t, 0.32 + 0.06 * t],
              begin: Alignment(-0.3 + 0.6 * t, -1),
              end: Alignment.bottomCenter,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.8 + 1.6 * t, -1.05),
                radius: 0.9,
                colors: [Colors.white.withValues(alpha: 0.22), Colors.transparent],
              ),
            ),
            child: child,
          ),
        );
      },
    );
  }
}

// Spinning ring with a glowing tail, used in the logo
class SpinningRing extends StatefulWidget {
  const SpinningRing({super.key, this.size = 22});

  final double size;

  @override
  State<SpinningRing> createState() => _SpinningRingState();
}

class _SpinningRingState extends State<SpinningRing> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 2200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: CustomPaint(size: Size.square(widget.size), painter: _RingPainter()),
    );
  }
}

class _RingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final stroke = 3.0;
    final rect = Rect.fromLTWH(stroke / 2, stroke / 2, size.width - stroke, size.height - stroke);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        colors: [Colors.white.withValues(alpha: 0.15), Colors.white],
      ).createShader(rect);

    canvas.drawArc(rect, 0, math.pi * 2, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
  const Shimmer({super.key, required this.child, this.color = kSky});

  final Widget child;
  final Color color;

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 2800),
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
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                // Sweep during the first half, rest during the second
                final t = Curves.easeInOut.transform((_controller.value * 2).clamp(0.0, 1.0));
                return DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, widget.color.withValues(alpha: 0.35), Colors.transparent],
                      stops: [0.35, 0.5, 0.65],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      transform: _SlideGradient(-1.2 + 2.4 * t),
                    ),
                  ),
                );
              },
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
