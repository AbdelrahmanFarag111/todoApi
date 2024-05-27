import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todoapi/view/auth/login_screen.dart';
import 'package:todoapi/view_model/utils/app_assets.dart';
import 'package:todoapi/view_model/utils/navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(
        seconds: 2,
      ),
      () => Navigation.pushAndRemove(context, const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          AppAssets.todo,
          height: 200.h,
        ),
      ),
    );
  }
}
