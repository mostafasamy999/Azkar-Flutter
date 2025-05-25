import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/utils/FontSize.dart';
import '../../../../core/utils/Utils.dart';
import '../../../../core/colors.dart';
import '../bloc/azkar/setting/SettingBloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AboutScreen extends StatelessWidget {
  AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: _buildAppbar(context),
          body: _buildBody(),
        ));
  }

  AppBar _buildAppbar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () async {
          Navigator.pop(context);
        },
      ),
      title: BlocBuilder<SettingBloc, SettingState>(
        builder: (context, state) {
          if (state is LoadedSettingState) {
            return Text(
              'عن البرنامج',
              style: TextStyle(fontSize: Utils().fontSize(state.setting.fontSize)),
            );
          }

          return const Text('عن البرنامج');
        },
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<SettingBloc, SettingState>(builder: (context, state) {
      if (state is LoadedSettingState) {
        final _textSize = Utils().fontSize(state.setting.fontSize);
        return _bodyContent(_textSize);
      }
      return _bodyContent(Utils().fontSize(FontSize.Median));
    });
  }

  Widget _bodyContent(double fontSize) {
    return Container(
      // color: AppColors.c2Read,
      padding: EdgeInsets.only(left: 6.0, right: 6, top: 16, bottom: 16),
      child: SingleChildScrollView( // Add SingleChildScrollView here
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // Align text to the start
                    children: [
                      Text(
                        "الحمد لله رب العالمين والصلاة والسلام على رسول الله صلى الله عليه وسلم وبعد: \n" +
                            "فهذا تطبيق صحيح الأذكار وهو مأخوذ من مؤلفات",
                        style: TextStyle(
                            // color: AppColors.c4Actionbar,
                          fontSize: fontSize),
                      ),
                      SizedBox(height: 10), // Space between text
                      Center(
                          child: Text(
                            'الشيخ الدكتور / ابو وسام وليد الرفاعي',
                            style: TextStyle(
                                fontFamily: 'alfont',
                                fontWeight: FontWeight.bold,
                                // color: AppColors.c4Actionbar,
                                fontSize: fontSize * 2),
                          )),
                      SizedBox(height: 10), // Space between text
                      Text(
                        "كما نرحب بالاقتراحات والملاحظات عبر نموذج التواصل بالموقع.\n" +
                            "ندعو الله عز وجل أن يتقبل منا هذا العمل وينفعنا وإياكم به. رجاءا لا تنسونا من صالح دعائكم وساهموا معنا في نشر تطبيق صحيح الأذكار والأدعية النبوية.",
                        style: TextStyle(
                            // color: AppColors.c4Actionbar,
                            fontSize: fontSize),
                      ),
                      SizedBox(height: 30), // Space between text
                      Center(
                        child: GestureDetector(
                            onTap: () async {
                              const facebookUrl =
                                  'https://www.facebook.com/waleed.elrefaiee';
                              if (await canLaunch(facebookUrl)) {
                                await launch(facebookUrl);
                              } else {
                                throw 'Could not launch $facebookUrl';
                              }
                            },
                            child: SvgPicture.asset(
                              'assets/images/facebook.svg',
                              width: 100,
                              height: 100,
                              placeholderBuilder: (BuildContext context) =>
                                  CircularProgressIndicator(),
                            )),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
