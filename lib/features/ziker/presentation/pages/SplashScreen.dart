import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
    Timer(Duration(seconds: 3),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                CategoryScreen()
            )
        )
    );
  }




  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHigh = MediaQuery.of(context).size.height;
    return Scaffold(
      body:
      SingleChildScrollView(child:
      Container(
        color: Colors.white,
        height:screenHigh ,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // Center vertically
            crossAxisAlignment: CrossAxisAlignment.center,
            // Center horizontally
            children: [
              Image.asset(
                'assets/images/ic_launcher.png',
                width: screenWidth * 80 /100,
                height: screenWidth * 80 /100,
                // fit: BoxFit.cover,
              ),

              SizedBox(height: screenWidth * 20 /100), // Add some spacing
               Text(
                    'لفضيلة الدكتور / وليد الرفاعي',
                 textAlign: TextAlign.center,
                 style: TextStyle(
                     fontFamily: 'alfont',
                     fontWeight: FontWeight.bold,
                     color: AppColors.primary,
                     fontSize: screenWidth * 10 /100),
               ),
              SizedBox(height: screenWidth * 4 /100), // Add some spacing
              SpinKitCircle(
                size: screenWidth * 0.2,
                itemBuilder: (BuildContext context, int index) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    ),);
  }
}
