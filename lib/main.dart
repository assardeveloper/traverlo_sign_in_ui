import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'sign_in_animations.dart';
import 'sign_in_widgets.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignInPage(),
    );
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage>
    with SingleTickerProviderStateMixin {
  static final _providers = <(String, Widget)>[
    ("Facebook", const Icon(Icons.facebook, color: Colors.white, size: 22)),
    ("Google", Text("G", style: font(20, weight: FontWeight.w800))),
    ("Apple", const Icon(Icons.apple, color: Colors.white, size: 24)),
  ];

  String _provider = "Facebook";

  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..forward();

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  // Each call takes the next slot in the staggered entrance
  int _slot = 0;
  Widget _enter(Widget child) =>
      FadeSlideIn(controller: _entrance, index: _slot++, child: child);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: kSkyBottom,
        body: AnimatedSkyBackground(
          child: SafeArea(
            child: LayoutBuilder(
              // Center vertically, but still scroll when the screen is short
              builder: (context, constraints) => SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 48,
                  ),
                  child: Center(child: _form()),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _form() {
    _slot = 0;
    return Column(
      children: [
        _enter(const BrandLogo()),
        const SizedBox(height: 28),
        _enter(
          Text(
            "Sign in",
            style: font(
              32,
              weight: FontWeight.w700,
            ).copyWith(letterSpacing: -0.6),
          ),
        ),
        const SizedBox(height: 8),
        _enter(
          Text("Please fill your information,", style: font(13, color: kMuted)),
        ),
        SizedBox(height: 28),
        _enter(
          const FieldsCard(
            children: [
              InfoField(
                label: "Email",
                value: "assardev58@gmail.com",
                icon: Icons.mail_outline_outlined,
              ),
              InfoField(
                label: "Password",
                value: "password1234",
                icon: Icons.lock_outline_rounded,
                isPassword: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        _enter(PrimaryButton(label: "Sign in now")),
        const SizedBox(height: 18),
        _enter(
          Text(
            "Sign up",
            style: font(12, weight: FontWeight.w500).copyWith(
              decoration: TextDecoration.underline,
              decorationColor: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 22),
        _enter(const OrDivider(text: "or continue with")),
        const SizedBox(height: 6),
        for (final (label, icon) in _providers)
          Padding(
            padding: EdgeInsetsGeometry.only(top: 12),
            child: _enter(
              SocialTile(
                icon: icon,
                label: label,
                selected: _provider == label,
                onTap: () => setState(() {
                  _provider = label;
                }),
              ),
            ),
          ),
      ],
    );
  }
}
