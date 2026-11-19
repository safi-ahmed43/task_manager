import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskly/Core/app_colors.dart';
import 'package:taskly/Core/app_strings.dart';
import 'package:taskly/Presentation/features/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(Duration(seconds: 3), _goToHome);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();

  }


  void _goToHome() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(24),
                boxShadow:[
                  BoxShadow(color: AppColors.primary.withValues(alpha: 0.32))
                ]
              ),
              child: Icon(Icons.note_alt_sharp,color: AppColors.background,size: 48,),
            ),
          ),
          SizedBox(height: 15,),
          Text(
            AppStrings.appName,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800
            ),
          ),
          Text(
            AppStrings.appTagline,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400
            ),
          ),
        ],
      ),
    );
  }
}
