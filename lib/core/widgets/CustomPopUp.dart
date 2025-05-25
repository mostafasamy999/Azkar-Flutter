import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../colors.dart';

class CustomPopupWidget extends StatelessWidget {
  final Function() onBack;

  const CustomPopupWidget(this.onBack, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: _DialogContent(context),
    );
  }

  Widget _DialogContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/ic_baseline_check_circle_24.svg',
                height: 72,
                // color: AppColors.c4Actionbar,
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "انتهى الذكر",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          GestureDetector(
              onTap: onBack,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  // color: AppColors.c4Actionbar,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "العودة الى القائمة الرئيسية",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              )),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                // color: AppColors.cCancelBG,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "الغاء",
                style: TextStyle(fontSize: 16,
                    // color: AppColors.c4Actionbar
                  ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}
