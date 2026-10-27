import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'sign_in_animations.dart';

const kSkyTop = Color(0xFF3E93DE);
const kSkyBottom = Color(0xFF1B4F8F);
const kCard = Color(0x33062A55);
const kCardSelected = Color(0x4D2F7BD0);
const kButton = Color(0xFF6CC0F7);
const kTeal = Color(0xFF5ED6D0);
const kMuted = Color(0xB3FFFFFF);

TextStyle font(double size, {FontWeight weight = FontWeight.w400, Color color = Colors.white}) =>
    GoogleFonts.plusJakartaSans(fontSize: size, fontWeight: weight, color: color);

// Teal "T" circle next to the app name
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PulseGlow(
          child: Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: kTeal, shape: BoxShape.circle),
            child: Text(
              "T",
              style: font(15, weight: FontWeight.w700, color: kSkyBottom),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text("Traverlo", style: font(18, weight: FontWeight.w700)),
      ],
    );
  }
}

// See-through card that stacks fields with thin lines between them
class FieldsCard extends StatelessWidget {
  const FieldsCard({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(18)),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const Divider(height: 1, color: Colors.white12),
            children[i],
          ],
        ],
      ),
    );
  }
}

// Small label above the value, icon on the right
class InfoField extends StatelessWidget {
  const InfoField({super.key, required this.label, required this.value, required this.icon, this.isPassword = false});

  final String label;
  final String value;
  final IconData icon;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: font(11, color: kMuted)),
                TextFormField(
                  initialValue: value,
                  obscureText: isPassword,
                  obscuringCharacter: '•',
                  cursorColor: Colors.white,
                  style: font(15, weight: FontWeight.w600),
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 6),
                  ),
                ),
              ],
            ),
          ),
          Icon(icon, color: kMuted, size: 18),
        ],
      ),
    );
  }
}

// Light blue pill with a soft glow
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: PressScale(
        child: Shimmer(
          child: Container(
            height: 54,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: kButton,
              borderRadius: BorderRadius.circular(27),
              boxShadow: [BoxShadow(color: kButton.withValues(alpha: 0.4), blurRadius: 20, offset: const Offset(0, 6))],
            ),
            child: Text(
              label,
              style: font(15, weight: FontWeight.w600, color: kSkyBottom),
            ),
          ),
        ),
      ),
    );
  }
}

// Line, text, line
class OrDivider extends StatelessWidget {
  const OrDivider({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Colors.white24)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(text, style: font(11, color: kMuted)),
        ),
        const Expanded(child: Divider(color: Colors.white24)),
      ],
    );
  }
}

// Pill that glows and fills its radio dot when picked
class SocialTile extends StatelessWidget {
  const SocialTile({super.key, required this.icon, required this.label, required this.selected, required this.onTap});

  final Widget icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  static const _duration = Duration(milliseconds: 250);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: PressScale(
        child: AnimatedContainer(
          duration: _duration,
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: selected ? kCardSelected : kCard,
            borderRadius: BorderRadius.circular(27),
            border: Border.all(color: selected ? kButton : Colors.transparent, width: 1.5),
            boxShadow: selected ? [BoxShadow(color: kButton.withValues(alpha: 0.45), blurRadius: 18)] : [],
          ),
          child: Row(
            children: [
              SizedBox(
                width: 26,
                child: Center(
                  child: PopOnSelect(trigger: selected, child: icon),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(label, style: font(14, weight: FontWeight.w600)),
              ),
              AnimatedContainer(
                duration: _duration,
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? Colors.white : Colors.transparent,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: AnimatedScale(
                  scale: selected ? 1 : 0,
                  duration: _duration,
                  curve: Curves.easeOutBack,
                  child: selected ? const Icon(Icons.check, size: 11, color: kSkyBottom) : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
