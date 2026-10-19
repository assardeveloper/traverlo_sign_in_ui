import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_videos/sign_up_animations.dart';

// Colors for the dark PipeLine sign up design
const Color kSky = Color(0xFF2BC8FF);
const Color kTeal = Color(0xFF0E6C8F);
const Color kNight = Color(0xFF0A0812);
const Color kField = Color(0xFF1B1A26);
const Color kBorder = Color(0xFF2C2B3A);
const Color kHint = Color(0xFF6E6C85);
const Color kMuted = Color(0xFF8E8CA3);

const LinearGradient kSkyGradient = LinearGradient(
  colors: [kSky, kTeal, kNight],
  stops: [0, 0.18, 0.34],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

TextStyle outfit(double size, {FontWeight weight = FontWeight.w400, Color color = Colors.white}) {
  return GoogleFonts.outfit(fontSize: size, fontWeight: weight, color: color);
}

// Ring icon next to the "PipeLine" name
class PipeLineLogo extends StatelessWidget {
  const PipeLineLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SpinningRing(size: 22),
        SizedBox(width: 12),
        Text("PipeLine", style: outfit(24, weight: FontWeight.w600)),
      ],
    );
  }
}

// Dark outlined button with a brand icon, used for Google and Github
class SocialButton extends StatelessWidget {
  const SocialButton({super.key, required this.label, required this.icon, required this.onTap});

  final String label;
  final Widget icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PressScale(
      child: Material(
        color: kNight.withValues(alpha: 0.55),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: kBorder),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: SizedBox(
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                SizedBox(width: 12),
                Text(label, style: outfit(17, weight: FontWeight.w500)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GithubIcon extends StatelessWidget {
  const GithubIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return FaIcon(FontAwesomeIcons.github, color: Colors.white, size: 21);
  }
}

// Four colored arcs and a bar that make the Google "G"
class GoogleIcon extends StatelessWidget {
  const GoogleIcon({super.key, this.size = 20});

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.square(size), painter: _GooglePainter());
  }
}

class _GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 0.2;
    final rect = Rect.fromLTWH(stroke / 2, stroke / 2, size.width - stroke, size.height - stroke);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;

    double deg(double d) => d * math.pi / 180;

    // Angles go clockwise starting from the right side
    canvas.drawArc(rect, deg(-40), deg(-95), false, paint..color = Color(0xFFEA4335));
    canvas.drawArc(rect, deg(-135), deg(-90), false, paint..color = Color(0xFFFBBC05));
    canvas.drawArc(rect, deg(135), deg(-90), false, paint..color = Color(0xFF34A853));
    canvas.drawArc(rect, deg(45), deg(-45), false, paint..color = Color(0xFF4285F4));

    // Middle bar of the G
    final center = size.height / 2;
    canvas.drawRect(
      Rect.fromLTRB(size.width / 2, center - stroke / 2, size.width, center + stroke / 2),
      Paint()..color = Color(0xFF4285F4),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Thin lines with "Or" in the middle
class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: kBorder, thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 28),
          child: Text("Or", style: outfit(16, color: kHint)),
        ),
        Expanded(child: Divider(color: kBorder, thickness: 1)),
      ],
    );
  }
}

// Label above a dark rounded text field
class LabeledField extends StatefulWidget {
  const LabeledField({
    super.key,
    required this.label,
    required this.hint,
    this.obscure = false,
    this.suffix,
    this.keyboardType,
  });

  final String label;
  final String hint;
  final bool obscure;
  final Widget? suffix;
  final TextInputType? keyboardType;

  @override
  State<LabeledField> createState() => _LabeledFieldState();
}

class _LabeledFieldState extends State<LabeledField> {
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focused = _focus.hasFocus;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: kBorder),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedDefaultTextStyle(
          duration: Duration(milliseconds: 200),
          style: outfit(16, weight: FontWeight.w500, color: focused ? kSky : Colors.white),
          child: Text(widget.label),
        ),
        SizedBox(height: 12),
        AnimatedContainer(
          duration: Duration(milliseconds: 250),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: kSky.withValues(alpha: focused ? 0.35 : 0),
                blurRadius: focused ? 18 : 0,
                spreadRadius: focused ? 1 : 0,
              ),
            ],
          ),
          child: TextField(
            focusNode: _focus,
            obscureText: widget.obscure,
            keyboardType: widget.keyboardType,
            cursorColor: kSky,
            style: outfit(17),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: outfit(17, color: kHint),
              filled: true,
              fillColor: kField,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 19),
              suffixIcon: widget.suffix,
              enabledBorder: border,
              focusedBorder: border.copyWith(borderSide: BorderSide(color: kSky, width: 1.5)),
            ),
          ),
        ),
      ],
    );
  }
}

// Password field with an eye button to show or hide the text
class PasswordField extends StatefulWidget {
  const PasswordField({super.key});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _hidden = true;

  @override
  Widget build(BuildContext context) {
    return LabeledField(
      label: "Password",
      hint: "Enter your password",
      obscure: _hidden,
      suffix: Padding(
        padding: EdgeInsets.only(right: 8),
        child: IconButton(
          onPressed: () => setState(() => _hidden = !_hidden),
          icon: AnimatedSwitcher(
            duration: Duration(milliseconds: 250),
            transitionBuilder: (child, animation) => RotationTransition(
              turns: Tween(begin: 0.75, end: 1.0).animate(animation),
              child: ScaleTransition(scale: animation, child: child),
            ),
            child: Icon(
              _hidden ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              key: ValueKey(_hidden),
              color: kMuted,
            ),
          ),
        ),
      ),
    );
  }
}

// Big white pill button
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PressScale(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Shimmer(
          child: SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: kNight,
                elevation: 0,
                shape: StadiumBorder(),
              ),
              child: Text(
                label,
                style: outfit(19, weight: FontWeight.w600, color: kNight),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
