import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sahih_azkar/features/ziker/presentation/pages/CategoryScreen.dart';

import '../../../../core/colors.dart';
import 'MainScreen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    // Timer(Duration(seconds: 3),
    //         ()=>Navigator.pushReplacement(context,
    //         MaterialPageRoute(builder:
    //             (context) =>
    //             CategoryScreen()
    //         )
    //     )
    // );
  }
  bool _startAnimation = false; // Flag to start the animation
  late Timer _timer;



  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child:AnimatedOpacity(
              opacity: _startAnimation ? 1.0 : 0.0, // Animate opacity
              duration: Duration(seconds: 1), // Duration of the fade-in effect
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // Center vertically
            crossAxisAlignment: CrossAxisAlignment.center,
            // Center horizontally
            children: [
              Image.asset(
                'assets/images/ic_launcher.png',
                width: 260,
                height: 260,
                // fit: BoxFit.cover,
              ),

              SizedBox(height: 100), // Add some spacing
               Text(
                    'لفضيلة الدكتور وليد الرفاعي',
                 style: TextStyle(
                     fontFamily: 'alfont',
                     fontWeight: FontWeight.bold,
                     // color: AppColors.c4Actionbar,
                     fontSize: 60),
               )

            ],
          ),
        ),
      ),
    ));
  }
}
