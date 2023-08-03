import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/firebase_options.dart';
import 'package:quizapp/model/appcolors.dart';
import 'package:quizapp/ui/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
       theme: ThemeData(
          
          colorScheme:
              ColorScheme.fromSeed(seedColor: AppColors.profilebgcolor),
          useMaterial3: true,
        ),
        home: const LoginScreen());
  }
}
