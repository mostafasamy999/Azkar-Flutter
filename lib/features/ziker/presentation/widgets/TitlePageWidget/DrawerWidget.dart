import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/colors.dart';
import '../../bloc/azkar/setting/SettingBloc.dart';
import '../../pages/AboutScreen.dart';
import '../../pages/MyWillScreen.dart';
import '../../pages/SettingScreen.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topRight: Radius.circular(0))),
        width: 220,
        child: Container(
          color: AppColors.drawerBg1,
          child: ListView(padding: EdgeInsets.zero, children: [
            _buildHeader(),
            _buildFirstListTile(
              'assets/images/ic_menu.svg',
              'الأذكار',
              // AppColors.c4Actionbar,
            ),
            _buildListTileSVG(
              context,
              'assets/images/baseline_settings_24.svg',
              'الإعدادات',
              // AppColors.white,
            ),
            _buildListTileSVG(
              context,
              'assets/images/baseline_error_24_white.svg',
              'عن التطبيق'
              // AppColors.white,
            ),
            _buildListTileIcon(
              context,
              Icons.back_hand,
              'وصيتي',
              // AppColors.white,
            ),
            _buildListTileSVG(
              context,
              'assets/images/shar.svg',
              'مشاركة التطبيق',
              // AppColors.white,
            ),
            _buildListTileOurValue(
              context,
              Icons.star,
              'تقييم صحيح الأذكار'
              // Colors.yellow,
            ),
            _buildListTileJpg(
              context,
              'assets/images/icon_ganna.jpg',
              'من أسباب دخول الجنة',
              // AppColors.white,
            ),
          ]),
        ));
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(left: 14, bottom: 14, top: 14, right: 14),
      // decoration: BoxDecoration(color: AppColors.c4Actionbar),
      child: const Text(
        "ۛ ּڝــحۡــۑْۧــحۡ اﻷذڪــٰٱڕ",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'typesetting',
          color: Colors.white,
          fontSize: 56,
        ),
      ),
    );
  }

  Widget _buildFirstListTile(String asset, String title, ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.iconBackground,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        leading: SvgPicture.asset(
          asset,
          width: 16.0,
          height: 16.0,
          color: AppColors.azkarColor,
        ),
        title: Text(title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
        textColor: AppColors.azkarColor,
        onTap: () {
          //   Handle onTap
        },
      ),
    );
  }

  Widget _buildListTileSVG(
      BuildContext context, String asset, String title) {
    return ListTile(
      leading: SvgPicture.asset(
        asset,
        width: 24.0,
        height: 24.0,
        colorFilter: ColorFilter.mode(AppColors.iconBackground, BlendMode.srcIn),
      ),
      title: Text(title,style: TextStyle(fontSize: 20),),
      textColor: AppColors.iconBackground,
      onTap: () {
        if (Scaffold.of(context).isDrawerOpen) {
          Navigator.of(context).pop();
        }
        switch (title) {
          case 'الإعدادات':
            _gotoSettingPage(context);
            break;
          case 'عن التطبيق':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AboutScreen(),
              ),
            );
            break;
          case 'مشاركة التطبيق':
            _shareApp();
            break;
          default:
          // Default code block
        }
      },
    );
  }

  Widget _buildListTileIcon(
      BuildContext context, IconData asset, String title) {
    return ListTile(
      leading: Icon(
        asset,
        size: 24,
        color: AppColors.iconBackground,
      ),
      title: Text(title,style: TextStyle(fontSize: 20)),
      textColor: AppColors.iconBackground,
      onTap: () {
        if (Scaffold.of(context).isDrawerOpen) {
          Navigator.of(context).pop();
        }
        switch (title) {
          case 'الإعدادات':
            _gotoSettingPage(context);
            break;
          case 'عن التطبيق':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AboutScreen(),
              ),
            );
            break;
          case 'مشاركة التطبيق':
            _shareApp();
            break;
          case 'وصيتي':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MyWillScreen(),
              ),
            );
            break;
          default:
          // Default code block
        }
      },
    );
  }

  Widget _buildListTileJpg(
      BuildContext context, String asset, String title) {
    return ListTile(
      leading: ClipRRect(
          borderRadius: BorderRadius.circular(12.0), // Set the corner radius
          child: Image.asset(
            asset,
            width: 40.0,
            height: 40.0,
            fit: BoxFit.cover,
          )),
      title: Text(title,style: TextStyle(fontSize: 20)),
      textColor: AppColors.iconBackground,
      onTap: () {
        if (Scaffold.of(context).isDrawerOpen) {
          Navigator.of(context).pop();
        }
        openPlayStoreLink();
      },
    );
  }

  Widget _buildListTileOurValue(
      BuildContext context, IconData icon, String title) {
    return ListTile(
      leading: Icon(
        icon, // Pass the IconData here
        size: 40.0, // Set size of the icon
        color: AppColors.secondary, // Set color of the icon
      ),
      title: Text(title,style: TextStyle(fontSize: 20)),
      textColor: AppColors.iconBackground,
      onTap: () {
        if (Scaffold.of(context).isDrawerOpen) {
          Navigator.of(context).pop();
        }
        openAppReviewPage();
      },
    );
  }

  void openPlayStoreLink() async {
    const url = 'https://play.google.com/store/apps/details?id=com.samy.ganna';

    // Check if the Play Store app can handle the market scheme
    if (await canLaunch('market://details?id=com.samy.ganna')) {
      await launch(
          'market://details?id=com.samy.ganna'); // Opens in Play Store app
    } else {
      await launch(url); // Fallback to opening in browser
    }
  }

  void _gotoSettingPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SettingScreen(),
      ),
    );
  }

  void _shareApp() {
    try {
      const String appName = "صحيح الأذكار";
      const String appLink =
          "https://play.google.com/store/apps/details?id=com.samy.azkar2&hl=en-US";
      const String shareMessage = "$appName\n\n$appLink";

      Share.share(shareMessage).then((_) {
        print("Share completed successfully");
      }).catchError((error) {
        print("Share error: $error");
      });
    } catch (e) {
      print("Exception during share: $e");
    }
  }

  void openAppReviewPage() async {
    const packageName =
        'com.samy.azkar2'; // Replace with your app's package name
    const playStoreUrl =
        'https://play.google.com/store/apps/details?id=$packageName';
    const marketUrl = 'market://details?id=$packageName';

    // Check if the Play Store app can handle the market scheme
    if (await canLaunch(marketUrl)) {
      await launch(marketUrl); // Opens directly in Play Store app
    } else {
      await launch(playStoreUrl); // Fallback to opening in browser
    }
  }
}
