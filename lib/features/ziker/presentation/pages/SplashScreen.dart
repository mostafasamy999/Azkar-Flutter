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
    _startVisibilityTimer();
    Timer(Duration(seconds: 3),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                CategoryScreen()
            )
        )
    );
  }
  bool _isVisible = false; // Start as invisible
  bool _startAnimation = false; // Flag to start the animation
  late Timer _timer;

  void _startVisibilityTimer() {
    _timer = Timer(Duration(seconds: 2), () {
      setState(() {
        _startAnimation = true; // Start the animation after 2 seconds
      });
    });
  }

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
              SvgPicture.asset(
                'assets/images/ic_launcher.svg',
                width: 160,
                height: 160,
              ),

              SizedBox(height: 20), // Add some spacing
               Text(
                    'صحيح الأذكار',
                    style: TextStyle(
                      fontSize: 40,
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
            ],
          ),
        ),
      ),
    ));
  }
}
