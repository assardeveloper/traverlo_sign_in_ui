import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:youtube_videos/sign_up_animations.dart';
import 'package:youtube_videos/sign_up_widgets.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with SingleTickerProviderStateMixin {
  // Drives the staggered entrance of every section on the page
  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 1800),
  )..forward();

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  Widget _reveal(int index, Widget child) {
    return FadeSlideIn(controller: _entrance, index: index, child: child);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kNight,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: AnimatedSkyBackground(
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 40),
                  _reveal(0, PipeLineLogo()),
                  SizedBox(height: 25),
                  _reveal(1, Text("Sign Up Account", style: outfit(30, weight: FontWeight.w600))),
                  SizedBox(height: 10),
                  _reveal(
                    2,
                    Text(
                      "Enter your personal data to create your account",
                      textAlign: TextAlign.center,
                      style: outfit(15.5, color: Colors.white70),
                    ),
                  ),
                  SizedBox(height: 32),
                  _reveal(
                    3,
                    Row(
                      children: [
                        Expanded(
                          child: SocialButton(label: "Google", icon: GoogleIcon(), onTap: () {}),
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: SocialButton(label: "Github", icon: GithubIcon(), onTap: () {}),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25,),
                  _reveal(4, OrDivider()),
                  SizedBox(height: 25),
                  _reveal(
                    5,
                    Row(
                      children: [
                        Expanded(
                          child: LabeledField(label: "First Name", hint: "eg. Assar"),
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: LabeledField(label: "Last Name", hint: "eg . Developer"),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  _reveal(
                    6,
                    LabeledField(
                      label: "Email",
                      hint: "eg . assardev58@gmail.com",
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  SizedBox(height: 24),
                  _reveal(7, PasswordField()),
                  SizedBox(height: 32),
                  _reveal(8, PrimaryButton(label: "Sign Up", onTap: () {})),
                  SizedBox(height: 25),
                  _reveal(
                    9,
                    Text.rich(
                      TextSpan(
                        text: "Already have an account?",
                        style: outfit(16, color: Colors.white70),
                        children: [
                          TextSpan(
                            text: "Log in",
                            style: outfit(16, weight: FontWeight.w700),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
