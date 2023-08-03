import 'package:flutter/material.dart';
import 'package:quizapp/firebase_service/splash_service.dart';
import 'package:quizapp/model/appcolors.dart';
import 'package:quizapp/model/appicons.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashServices = SplashServices();
  @override
  void initState() {
    super.initState();
    splashServices.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      body: Center(
        child: Image.asset(
          AppIcons.splash,
          width: 100,
          height: 100,
        ),
      ),
    );
  }
}
