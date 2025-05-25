import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sahih_azkar/features/ziker/domain/usecases/GetOldSettingUsecase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_all;

import '../../features/ziker/domain/entities/PrayerTime.dart';
import '../../features/ziker/domain/entities/Setting.dart';
import '../../features/ziker/domain/usecases/GetPrayerTimesUsecase.dart';
import '../../features/ziker/domain/usecases/SetNewSettingUsecase.dart';
import '../../features/ziker/presentation/bloc/azkar/setting/SettingBloc.dart';
import '../../injection_container.dart';
import 'FontSize.dart';
import 'location_helper.dart';

class NotificationHelper {
  static late final FlutterLocalNotificationsPlugin _notification;

  // Static getter to access the _notification instance
  static FlutterLocalNotificationsPlugin getNotificationInstance() {
    return _notification;
  }

  static Future<void> requestPermissions() async {
    try {
      if (Platform.isAndroid) {
        // Check Android version
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        final sdkInt = androidInfo.version.sdkInt;

        if (sdkInt >= 33) {
          // Android 13 or higher
          // Request notification permission using the new API
          final status = await Permission.notification.status;

          if (status.isDenied) {
            final newStatus = await Permission.notification.request();
            debugPrint('Android 13+ Permission Status: ${newStatus.isGranted}');
          }
        } else {
          // For Android 12 and below
          final status = await Permission.notification.status;

          if (status.isDenied) {
            final newStatus = await Permission.notification.request();
            debugPrint('Android Permission Status: ${newStatus.isGranted}');
          }
        }
      } else if (Platform.isIOS) {
        // For iOS
        final bool? iosGranted = await _notification
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            );
        debugPrint('iOS Permission Status: $iosGranted');
      }
    } catch (e) {
      debugPrint('Permission Request Error: $e');
    }
  }

  static init() {
    _notification = FlutterLocalNotificationsPlugin();

    // Create the notification channel explicitly
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'scheduled_channel',
      'Scheduled Notifications',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    // Register the channel with the system
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    _notification.initialize(
        const InitializationSettings(
            android: AndroidInitializationSettings('@mipmap/ic_launcher'),
            iOS: DarwinInitializationSettings()),
        onDidReceiveNotificationResponse:
            (NotificationResponse response) async {
      final payload = response.payload;
      if (payload != null) {}
    });

    tz_all.initializeTimeZones();
    final String timeZoneName = tz.local.name;
    print('timeZoneName: $timeZoneName');
  }

  static NotificationDetails _notificationDetails() {
    var androidDetail = const AndroidNotificationDetails(
        'scheduled_channel','Scheduled Notifications',
        // description: 'Channel for scheduled notifications',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true);
    var iosDetail = const DarwinNotificationDetails(
      presentSound: true,
      presentAlert: true,
      presentBadge: true,
    );
    return NotificationDetails(android: androidDetail, iOS: iosDetail);
  }

  static tz.TZDateTime _createScheduleTime(DateTime selectedTime) {
    final now = DateTime.now();
    final scheduleDate = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    // If time has already passed today, schedule for tomorrow
    final scheduleDateTime = scheduleDate.isBefore(now)
        ? scheduleDate.add(const Duration(days: 1))
        : scheduleDate;

    debugPrint('Creating schedule time:');
    debugPrint('Now: ${now.toString()}');
    debugPrint('Initial date: ${scheduleDate.toString()}');
    debugPrint('Final date: ${scheduleDateTime.toString()}');

    return tz.TZDateTime.from(scheduleDateTime, tz.local);
  }

  static Future<void> scheduledDailyNotification(
      {required int id,
      required String title,
      required String body,
      required DateTime selectedTime}) async {
    final tz.TZDateTime zonedTime = _createScheduleTime(selectedTime);

    debugPrint('Scheduling notification #$id:');
    debugPrint('Title: $title');
    debugPrint('Body: $body');
    debugPrint('Zoned time: ${zonedTime.toString()}');

    try {
      await _notification.zonedSchedule(
        id,
        title,
        body,
        zonedTime,
        _notificationDetails(),
        // androidAllowWhileIdle: true,
        payload: body,
        androidScheduleMode: AndroidScheduleMode.exact,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      debugPrint('Notification #$id scheduled successfully');
    } catch (e) {
      debugPrint('Error scheduling notification #$id: $e');
    }
  }

  static void pushNotification(Setting setting) {
    DateTime now = DateTime.now();
    _setTimeNotification(
        id: 1, time: setting.walkUp, turnOn: setting.isWalkUp, now: now);
    _setTimeNotification(
        id: 2, time: setting.sleep, turnOn: setting.isSleep, now: now);
    _setTimeNotification(
        id: 3, time: setting.morning, turnOn: setting.isMorning, now: now);
    _setTimeNotification(
        id: 4, time: setting.evening, turnOn: setting.isEvening, now: now);
    _setTimeNotification(
        id: 5, time: setting.fager, turnOn: setting.isFager, now: now);
    _setTimeNotification(
        id: 6, time: setting.duher, turnOn: setting.isDuher, now: now);
    _setTimeNotification(
        id: 7, time: setting.aser, turnOn: setting.isAser, now: now);
    _setTimeNotification(
        id: 8, time: setting.magrep, turnOn: setting.isMagrep, now: now);
    _setTimeNotification(
        id: 9, time: setting.isha, turnOn: setting.isIsha, now: now);
  }

  static void _setTimeNotification(
      {required int id,
      required TimeOfDay time,
      required bool turnOn,
      required now}) {
    if (turnOn) {
      scheduledDailyNotification(
          id: id,
          title: "صحيح الأذكار",
          body: _body(id: id),
          selectedTime: _selectedTime(time, now));
    } else {
      cancelNotification(id);
    }
  }

  static DateTime _selectedTime(TimeOfDay time, DateTime now) {
    return DateTime(now.year, now.month, now.day, time.hour, time.minute);
  }

  static String _body({required int id}) {
    if (id == 1)
      return "أذكار الإستيقاظ";
    else if (id == 2)
      return 'أذكار النوم';
    else if (id == 3)
      return 'أذكار الصباح';
    else if (id == 4)
      return 'أذكار المساء';
    else if (id == 5)
      return 'أذكار دبر صلاة الفجر';
    else if (id == 6)
      return 'أذكار دبر صلاة الظهر';
    else if (id == 7)
      return 'أذكار دبر صلاة العصر';
    else if (id == 8)
      return 'أذكار دبر صلاة المغرب';
    else if (id == 9)
      return 'أذكار دبر صلاة العشاء';
    else
      return '';
  }

  static Future<void> cancelNotification(int notificationId) async {
    await _notification.cancel(notificationId);
  }

  // Test function for debugging
  static void testScheduledNotification() {
    final DateTime now = DateTime.now();
    final DateTime scheduledTime = now.add(const Duration(minutes: 2));

    debugPrint('Current time: ${now.toString()}');
    debugPrint('Scheduling test notification for: ${scheduledTime.toString()}');

    _notification
        .zonedSchedule(
      888,
      'Test Scheduled Notification',
      'This should appear 2 minutes after being scheduled',
      tz.TZDateTime.from(scheduledTime, tz.local),
      _notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exact,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    )
        .then((_) {
      debugPrint('Test notification scheduled successfully');
    }).catchError((error) {
      debugPrint('Error scheduling test notification: $error');
    });
  }
/*  // Rest of your methods remain the same...
  static void firstTimeOnly(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final bool isFirstRun = prefs.getBool('isFirstRun') ?? true;
    if (isFirstRun) {
      try {
        final locationData = await LocationUtils.getCurrentCityAndCountry();
        final city = locationData['city'] ?? 'Cairo';
        final country = locationData['country'] ?? 'Egypt';

        // 1. Fetch Prayer Times from Usecase
        final prayerTimes =
            await sl<GetPrayerTimesUsecase>().call(city, country);
        if (prayerTimes.isError) return;
        final Setting setting =
            _getSettingWithNewPrayersTime(prayerTimes.data as PrayerTime);
        // 2. Save it to Settings using UpdateSettingUsecase
        await sl<UpdateSettingUsecase>().call(setting);

        // 3. Update SettingBloc
        context.read<SettingBloc>().add(GetOldSettingEvent());

        pushNotification(setting);
        await prefs.setBool('isFirstRun', false);
      } catch (e) {
        print("Error occurred while initializing settings: $e");
        // Handle any errors such as network issues or data parsing problems
      }
    }
  }*/

  static void updatePrayersTime(BuildContext context) async {
    try {
      print('mossamy:init');
      final locationData = await LocationUtils.getCurrentCityAndCountry();
      final city = locationData['city'] ?? 'Cairo';
      final country = locationData['country'] ?? 'Egypt';
      print('mossamy:notification class updatePrayersTime');

      // 1. Fetch Prayer Times from Usecase
      final prayerTimes = await sl<GetPrayerTimesUsecase>().call(city, country);
      final oldSetting = await sl<GetOldSettingUsecase>().call();
      if (prayerTimes.isError) return;
      final Setting setting =
          _getSettingWithNewPrayersTime(oldSetting as Setting,prayerTimes.data as PrayerTime);
      // 2. Save it to Settings using UpdateSettingUsecase
      await sl<UpdateSettingUsecase>().call(setting);

      // 3. Update SettingBloc
      context.read<SettingBloc>().add(GetOldSettingEvent());

      pushNotification(setting);
      print("notification helper update prayer times settings: $setting");
    } catch (e) {
      print("Error occurred while initializing settings: $e");
      // Handle any errors such as network issues or data parsing problems
    }
  }

  static Setting _getSettingWithNewPrayersTime(Setting oldSetting, PrayerTime prayerTimes) {
    return Setting(
      fontSize:oldSetting.fontSize,
      noisy: oldSetting.noisy,
      vibrate: oldSetting.vibrate,
      transfer: oldSetting.transfer,
      walkUp: TimeOfDay(hour: oldSetting.walkUp.hour, minute: oldSetting.walkUp.minute),
      isWalkUp: oldSetting.isWalkUp,
      sleep: TimeOfDay(hour: oldSetting.sleep.hour, minute: oldSetting.sleep.minute),
      isSleep: oldSetting.isSleep,
      morning: TimeOfDay(hour: oldSetting.morning.hour, minute: oldSetting.morning.minute),
      isMorning: oldSetting.isMorning,
      evening: TimeOfDay(hour: oldSetting.evening.hour, minute: oldSetting.evening.minute),
      isEvening: oldSetting.isEvening,
      fager: prayerTimes.fajr,
      isFager: oldSetting.isFager,
      duher: prayerTimes.dhuhr,
      isDuher: oldSetting.isDuher,
      aser: prayerTimes.asr,
      isAser: oldSetting.isAser,
      magrep: prayerTimes.maghrib,
      isMagrep: oldSetting.isMagrep,
      isha: prayerTimes.isha,
      isIsha: oldSetting.isIsha,
    );
  }
}
