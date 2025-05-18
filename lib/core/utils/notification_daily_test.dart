import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> checkPendingNotificationRequests(BuildContext context, FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  // Fetch the list of pending notifications
  List<PendingNotificationRequest> pendingNotificationRequests = await flutterLocalNotificationsPlugin.pendingNotificationRequests();

  // Retrieve stored times
  final prefs = await SharedPreferences.getInstance();
  Map<int, DateTime?> notificationTimes = {};

  for (var notification in pendingNotificationRequests) {
    // Retrieve the time from SharedPreferences
    String? timeString = prefs.getString('notification_time_${notification.id}');
    if (timeString != null) {
      notificationTimes[notification.id] = DateTime.parse(timeString);
    } else {
      notificationTimes[notification.id] = null; // Default to null if not found
    }
  }

  // Display the pending notifications in a dialog
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Pending Notifications'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: pendingNotificationRequests.length,
            itemBuilder: (BuildContext context, int index) {
              // Each notification contains an id, title, body, and payload
              final notification = pendingNotificationRequests[index];
              final notificationTime = notificationTimes[notification.id];

              return ListTile(
                title: Text('ID: ${notification.id}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Title: ${notification.title ?? 'No title'}'),
                    Text('Body: ${notification.body ?? 'No body'}'),
                    Text('Payload: ${notification.payload ?? 'No payload'}'),
                    Text('Scheduled Time: ${notificationTime?.toLocal() ?? 'Unknown'}'), // Display the time
                  ],
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
