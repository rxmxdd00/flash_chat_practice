import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat_tutorial/components/round_reusable_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation? animation;
  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );
    //

    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller!);
    // animation = CurvedAnimation(parent: controller!, curve: Curves.decelerate);
    controller!.forward();
    // animation!.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     controller!.reverse(from: 1.0);
    //   } else if (status == AnimationStatus.dismissed) {
    //     controller!.forward();
    //   }
    // });
    controller!.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation!.value,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Hero(
                  tag: 'logo',
                  child: Container(
                    height: 60.0,
                    child: const Image(
                      image: AssetImage('images/logo.png'),
                    ),
                  ),
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Flash chat',
                      textStyle: TextStyle(
                        color: Colors.grey.shade900,
                        fontSize: 45.0,
                        fontWeight: FontWeight.w900,
                      ),
                      speed: const Duration(milliseconds: 200),
                    )
                  ],
                  totalRepeatCount: 4,
                  pause: const Duration(milliseconds: 200),
                  displayFullTextOnTap: true,
                  stopPauseOnTap: true,
                ),
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            RoundReusableButton(
              title: 'Log In',
              color: Colors.lightBlueAccent,
              onPressed: () {
                setState(() {
                  setState(() {
                    Navigator.pushNamed(context, 'login_screen');
                  });
                });
              },
            ),
            RoundReusableButton(
              title: 'Register',
              color: Colors.blueAccent,
              onPressed: () {
                setState(() {
                  setState(() {
                    Navigator.pushNamed(context, 'registration_screen');
                  });
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
