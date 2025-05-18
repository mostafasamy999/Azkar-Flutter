import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/new_version/new_version_android.dart';
import '../../../../core/utils/FontSize.dart';
import '../../../../core/utils/Utils.dart';
import '../../../../core/utils/notification_helper.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../bloc/azkar/azkar/AzkarBloc.dart';
import '../bloc/azkar/setting/SettingBloc.dart';
import '../widgets/TitlePageWidget/DrawerWidget.dart';
import '../widgets/titlePageWidget/TitlesListPageWidget.dart';
import '../widgets/titlePageWidget/message_display_widget.dart';
import 'ZikerScreen.dart';

class MainScreen extends StatefulWidget {
  final String? title;

  MainScreen({super.key, this.title});

  @override
  _MyHomePageState createState() => _MyHomePageState(title);
}

class _MyHomePageState extends State<MainScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  final String? title;

  _MyHomePageState(this.title);
  @override
  void initState() {
    super.initState();

    _initializeNotifications();
  }

  void _initializeNotifications() async {
    NotificationHelper.requestPermissions();
    NotificationHelper.updatePrayersTime(context);
    _handleOnClickNotificationEvent(title);
    //test notification
    // NotificationHelper.showTestNotification();
    // NotificationHelper.testScheduledNotification();
    // NotificationHelper.scheduleTestNotificationIn5Minutes('title', 'body');
    // print('areNotificationsEnabled: ${NotificationHelper.areNotificationsEnabled()}');
  }

  @override
  Widget build(BuildContext context) {
    checkForUpdateAndShowDialog(context);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: _appBar(),
          body: _drawerAndBody(),
        ));
  }

  AppBar _appBar() => AppBar(
      title: BlocBuilder<AzkarBloc, AzkarState>(
        builder: (context, state) {
          if (state is LoadedAzkarState) {
            return BlocBuilder<SettingBloc, SettingState>(
              builder: (context, state) {
                if (state is LoadedSettingState) {
                  return Text(
                    'صحيح الأذكار',
                    style: TextStyle(
                        fontSize: Utils().fontSize(state.setting.fontSize)),
                  );
                }

                return Text(
                  'صحيح الأذكار',
                  style: TextStyle(fontSize: Utils().fontSize(FontSize.Median)),
                );
              },
            );
          } else if (state is ErrorAzkarState) {}
          return const Text('صحيح الأذكار');
        },
      ),
      leading: IconButton(
          icon: Icon(Icons.dehaze),
          onPressed: () {
            if (_scaffoldKey.currentState!.isDrawerOpen == false) {
              _scaffoldKey.currentState!.openDrawer();
            } else {
              _scaffoldKey.currentState!.openEndDrawer();
            }
            // NotificationHelper.requestPermissions();//todo
          }));

  Widget _drawerAndBody() {
    return Scaffold(
        key: _scaffoldKey,
        body: _buildBody(),
        drawer: const Opacity(
          opacity: 0.7,
          child: DrawerWidget(),
        ));
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: BlocBuilder<AzkarBloc, AzkarState>(
        builder: (context, state) {
          if (state is LoadingAzkarState) {
            return LoadingWidget();
          } else if (state is LoadedAzkarState) {
            return Container(child: AzkarListWidget(azkarWithoutPray: state.azkarWithoutPray,prayAzkar: state.pryaAzkar,));
          } else if (state is ErrorAzkarState) {
            return MessageDisplayWidget(message: state.message);
          }
          return const LoadingWidget();
        },
      ),
    );
  }

  void _handleOnClickNotificationEvent(String? title) {
    if (title == null) return;
    if (title == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ZikerScreen(zikerTitle: title),
        ),
      );
    }
  }
}
