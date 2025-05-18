import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

Future<void> checkForUpdate() async {
  final packageInfo = await PackageInfo.fromPlatform();
  final currentVersion = packageInfo.version;

  final response = await http.get(Uri.parse(
    'https://itunes.apple.com/lookup?bundleId=com.samy.azkar2'
  ));

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    final latestVersion = json['results'][0]['version'];

    if (currentVersion != latestVersion) {
      // Show update dialog
    }
  }
}
