import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/FontSize.dart';
import '../../../../core/utils/Utils.dart';
import '../../../../core/utils/notification_helper.dart';
import '../bloc/PrayerTime/PrayerTimeCubit.dart';
import '../bloc/azkar/setting/SettingBloc.dart';
import 'package:get_it/get_it.dart';

import '../../domain/entities/Setting.dart';
import '../widgets/SettingPageWidget/SettingWidget.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  Setting setting = Setting(
    fontSize: FontSize.Median,
    noisy: true,
    vibrate: true,
    transfer: true,
    walkUp: TimeOfDay(hour: 6, minute: 30),
    isWalkUp: true,
    sleep: TimeOfDay(hour: 22, minute: 0),
    isSleep: true,
    morning: TimeOfDay(hour: 9, minute: 0),
    isMorning: true,
    evening: TimeOfDay(hour: 17, minute: 0),
    isEvening: true,
    fager: TimeOfDay(hour: 4, minute: 30),
    isFager: false,
    duher: TimeOfDay(hour: 12, minute: 30),
    isDuher: false,
    aser: TimeOfDay(hour: 16, minute: 0),
    isAser: false,
    magrep: TimeOfDay(hour: 18, minute: 10),
    isMagrep: false,
    isha: TimeOfDay(hour: 19, minute: 0),
    isIsha: false,
  );
  int _fontSizeType = 2;
  bool isInitialedSize = true; // to initialize setting first time only

  void _updateSetting(Setting newSetting) {
    setState(() {
      setting = newSetting;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => GetIt.instance<PrayerTimesCubit>(),
        child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: _buildAppbar(context),
              body: _buildBody(),
            )));
  }

  AppBar _buildAppbar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () async {
          _done();
        },
      ),
      title: Text(
        'الإعدادات',
        style: TextStyle(fontSize: 24),
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              _done();
            },
            child: Text('تم',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: Utils().fontSize(_fontSizeType)))),
      ],
    );
  }

  Widget _buildBody() {
    return SettingWidget(
        setting: setting,
        onSettingChanged: _updateSetting,
        pageFontSize: _fontSizeType);
  }

  void _done() async {
    BlocProvider.of<SettingBloc>(context) //.updateSetting(setting);
        .add(UpdateSettingEvent(setting: setting));

    //when the updateEvent is done will start getSettingEvent
    final settingBloc = context.read<SettingBloc>();
    await for (final state in settingBloc.stream) {
      if (state is MessageUpdateSettingState) {
        settingBloc.add(GetOldSettingEvent());
        break;
      }
    }
    NotificationHelper.pushNotification(setting);
    //
    Navigator.pop(context);
  }

  void _initialSetting(Setting setting) {
    if (isInitialedSize) {
      isInitialedSize = false;
      this.setting = setting;
      _fontSizeType = _getItemSelected(setting.fontSize);
      _initialSizeState(setting.fontSize);
    }
  }

  void _initialSizeState(FontSize fontSize) {
    switch (fontSize) {
      case FontSize.Median:
        _fontSizeType = 2;
        break;
      case FontSize.Small:
        _fontSizeType = 1;
        break;
      case FontSize.Large:
        _fontSizeType = 3;
        break;
    }
  }

  int _getItemSelected(FontSize fontSize) {
    switch (fontSize) {
      case FontSize.Small:
        return 1;
      case FontSize.Median:
        return 2;
      case FontSize.Large:
        return 3;
    }
  }
}
