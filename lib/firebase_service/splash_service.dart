import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/ui/home_screen.dart';
import 'package:quizapp/ui/login_screen.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;

    final user = auth.currentUser;

    if (user != null) {
      if (!user.isAnonymous) {
        // User is signed in with Google
        Timer(
          const Duration(seconds: 3),
          () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
          ),
        );
        //   } else {
        //     // User is signed in as a guest (anonymous)
        //     Timer(
        //       const Duration(seconds: 3),
        //       () => Navigator.of(context).pushReplacement(
        //         MaterialPageRoute(builder: (context) => const ()),
        //       ),
        //     );
        //   }
      } else {
        Timer(
          const Duration(seconds: 3),
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginScreen())
              // () => Navigator.of(context).pushReplacement(
              //   MaterialPageRoute(builder: (context) => const LoginScreen()),
              ),
        );
      }
    }
  }
}
