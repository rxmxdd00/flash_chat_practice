import 'package:flutter/material.dart';
import 'package:flash_chat_tutorial/screens/welcome_screen.dart';
import 'package:flash_chat_tutorial/screens/login_screen.dart';
import 'package:flash_chat_tutorial/screens/registration_screen.dart';
import 'package:flash_chat_tutorial/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: 'AIzaSyCsAjdHeHSyXHErC6UhS__0Rk-JBZgBPRE',
    appId: '1:1016292503438:android:512fff4579bf7d3eca3edf',
    messagingSenderId: 'sendid',
    projectId: 'flash-chat-fabb8',
  ));
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black54),
        ),
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },
    );
  }
}
