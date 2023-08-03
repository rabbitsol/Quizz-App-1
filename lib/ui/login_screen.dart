import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quizapp/model/appcolors.dart';
import 'package:quizapp/model/appicons.dart';
import 'package:quizapp/ui/home_screen.dart';
import 'package:quizapp/utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Quizz App',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                  color: AppColors.optionnotselectedcolor)),

          // const SizedBox(height: 70),
          Center(child: Image.asset(AppIcons.splash, height: 150, width: 150)),
          InkWell(
            onTap: () async {
              try {
                UserCredential userCredential = await signin();
                User? user = userCredential.user;

                if (user != null) {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .set({
                    'uid': user.uid,
                    'displayName': user.displayName,
                    'email': user.email,
                    'photoURL': user.photoURL,
                    'lastUpdated': DateTime.now(),
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(user: user),
                    ),
                  );
                }
              } catch (e) {
                Utils().toastmessage(e.toString());
                debugPrint(e.toString());
              }
            },
            child: Card(
              child: SizedBox(
                height: 50,
                width: 250,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child:
                          Image.asset(AppIcons.google, fit: BoxFit.fitHeight),
                    ),
                    const Text(
                      'Sign in with Google',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final FirebaseAuth auth = FirebaseAuth.instance;
Future<UserCredential> signin() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

// Future<UserCredential> signInAnonymously() async {
//   return await FirebaseAuth.instance.signInAnonymously();
// }
