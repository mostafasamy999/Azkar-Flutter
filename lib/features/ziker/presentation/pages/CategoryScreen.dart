import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sahih_azkar/core/colors.dart';
import 'package:sahih_azkar/features/ziker/presentation/pages/MainScreen.dart';

import '../../../../core/utils/notification_helper.dart';
import '../widgets/TitlePageWidget/DrawerWidget.dart';
import 'ZikerScreen.dart';

// Alternative version with Islamic-themed icons and colors
class CategoryScreen extends StatelessWidget {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  void _initializeNotifications(BuildContext context) async {
    NotificationHelper.requestPermissions();
    NotificationHelper.updatePrayersTime(context);
    // _handleOnClickNotificationEvent(widget.title);
  }
  @override
  Widget build(BuildContext context) {
    _initializeNotifications(context);
    // checkForUpdateAndShowDialog(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Color(0xFFF8F9FA),
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.dehaze),
              onPressed: () {
                if (_scaffoldKey.currentState!.isDrawerOpen == false) {
                  _scaffoldKey.currentState!.openDrawer();
                } else {
                  _scaffoldKey.currentState!.openEndDrawer();
                }
              }),
          title: Text(
            'صحيح الأذكار',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          elevation: 2,
        ),

        body: Scaffold(
            key: _scaffoldKey,
            drawer: const Opacity(
              opacity: 0.8,
              child: DrawerWidget(),
            ),
            body:
            Container(
            padding: EdgeInsets.all(20.0),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 20.0,
              mainAxisSpacing: 20.0,
              childAspectRatio: 0.95,
              children: [
                _buildIslamicCard(
                    title: 'الأذكار اليومية',
                    icon: Icons.auto_stories,
                    gradient: LinearGradient(
                      colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainScreen(
                            type: 1,
                          ),
                        ),
                      );
                    }),
                _buildIslamicCard(
                    title: 'القراءه في الصلوات',
                    icon: Icons.schedule,
                    gradient: LinearGradient(
                      colors: [Color(0xFF2196F3), Color(0xFF1565C0)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainScreen(type: 2)));
                    }),
                _buildIslamicCard(
                    title: 'دليل الحج',
                    icon: Icons.place,
                    gradient: LinearGradient(
                      colors: [Color(0xFF9C27B0), Color(0xFF6A1B9A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainScreen(type: 3)));
                    }),
                _buildIslamicCard(
                    title: 'دليل العمرة',
                    icon: Icons.location_city,
                    gradient: LinearGradient(
                      colors: [Color(0xFFFF9800), Color(0xFFE65100)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainScreen(type: 4)));
                    }),
              ],
            ))),
      ),
    );
  }

  Widget _buildIslamicCard({
    required String title,
    required IconData icon,
    required LinearGradient gradient,
    GestureTapCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(35),
              ),
              child: Icon(
                icon,
                size: 35,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 6),
          ],
        ),
      ),
    );
  }

  // void _handleOnClickNotificationEvent(String? title,context) {
  //   if (title == null) return;
  //   if (title == 1) {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => ZikerScreen(
  //           zikerTitle: title,
  //           type: type,
  //         ),
  //       ),
  //     );
  //   }
  // }
}
