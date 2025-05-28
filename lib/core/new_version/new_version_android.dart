import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dialog.dart';

void checkForUpdateAndShowDialog(BuildContext context) async {
  final isAndroid = Platform.isAndroid;
  final url = isAndroid
      ? 'https://play.google.com/store/apps/details?id=com.samy.azkar2&hl=en-US'
      : 'https://www.apple.com/app-store/';

  if (isAndroid) {
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;
    final currentBuildNumber = packageInfo.buildNumber;
    final updateResult = await checkForUpdate();

    print('mossamy');
    if (updateResult.updateAvailable) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        UpdateDialog.show(
          context,
          title: 'تحديث جديد متوفر',
          message:
          'هناك إصدار جديد من التطبيق متوفر. قم بالتحديث للحصول على أحدث الميزات والتحسينات.\n\n'
              'الإصدار الحالي: $currentVersion \n'
              'الإصدار الجديد: ${updateResult.latestVersion}${updateResult.latestBuildNumber != null ? " (${updateResult.latestBuildNumber})" : ""}',
          onUpdate: () {
            launchUrl(Uri.parse(url));
          },
          onLater: () {
            if (Navigator.of(context, rootNavigator: true).canPop()) {
              Navigator.of(context, rootNavigator: true).pop();
            }
          },
        );
      });
    }
  }
}

class UpdateResult {
  final bool updateAvailable;
  final String? latestVersion;
  final String? latestBuildNumber;

  UpdateResult(this.updateAvailable, this.latestVersion, this.latestBuildNumber);
}

Future<UpdateResult> checkForUpdate() async {
  try {
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;
    final currentBuildNumber = packageInfo.buildNumber;

    if (await _isPlayStoreInstall()) {
      print('checkForUpdate:t:if');
      // Use in_app_update for Play Store installs
      final updateInfo = await InAppUpdate.checkForUpdate();
      print('updateInfo.updateAvailability: ${updateInfo.updateAvailability}');
      print(
          'UpdateAvailability.updateAvailable: ${UpdateAvailability.updateAvailable}');

      // Note: in_app_update doesn't provide the new version string,
      // so we'll need to fall back to web scraping to get it
      String? latestVersion;
      String? latestBuildNumber;
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        final webInfo = await _getLatestVersionFromWeb(packageInfo.packageName);
        latestVersion = webInfo.version;
        latestBuildNumber = webInfo.buildNumber;
      }

      return UpdateResult(
          updateInfo.updateAvailability == UpdateAvailability.updateAvailable,
          latestVersion,
          latestBuildNumber
      );
    } else {
      print('checkForUpdate:t:else');
      // Fallback to web scraping for development/testing
      final result = await _checkPlayStoreWebpage();
      return result;
    }
  } catch (e) {
    print('checkForUpdate:c');
    print('Error checking for updates: $e');
    return UpdateResult(false, null, null);
  }
}

Future<bool> _isPlayStoreInstall() async {
  try {
    final updateInfo = await InAppUpdate.checkForUpdate();
    return true;
  } catch (e) {
    if (e is PlatformException && e.code == 'TASK_FAILURE') {
      return false; // Not installed from Play Store
    }
    rethrow;
  }
}

class VersionInfo {
  final String? version;
  final String? buildNumber;

  VersionInfo(this.version, this.buildNumber);
}

Future<VersionInfo> _getLatestVersionFromWeb(String packageName) async {
  try {
    final response = await http.get(
      Uri.parse('https://play.google.com/store/apps/details?id=$packageName'),
      headers: {
        'User-Agent':
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
      },
    );

    if (response.statusCode == 200) {
      // Version patterns
      final versionPatterns = [
        RegExp(r'\[\[\["([\d.]+)"\]\]'),  // New Play Store format
        RegExp(r'\"version\":\s*\"([\d.]+)\"'),  // JSON format
        RegExp(r'Version\s*([\d.]+)'), // Simple version format
        RegExp(r'version=([\d.]+)'),  // URL parameter format
      ];

      // Build number patterns - these are speculative since Play Store doesn't always show build numbers
      final buildPatterns = [
        RegExp(r'versionCode=([\d]+)'),
        RegExp(r'\"versionCode\":\s*\"?([\d]+)\"?'),
        RegExp(r'build\s*([\d]+)'),
      ];

      String? version;
      for (final pattern in versionPatterns) {
        final match = pattern.firstMatch(response.body);
        if (match != null) {
          version = match.group(1)!.trim();
          break;
        }
      }

      String? buildNumber;
      for (final pattern in buildPatterns) {
        final match = pattern.firstMatch(response.body);
        if (match != null) {
          buildNumber = match.group(1)!.trim();
          break;
        }
      }

      return VersionInfo(version, buildNumber);
    }
  } catch (e) {
    print('Error getting latest version from web: $e');
  }
  return VersionInfo(null, null);
}

Future<UpdateResult> _checkPlayStoreWebpage() async {
  print('_checkPlayStoreWebpage');
  try {
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;
    final currentBuildNumber = packageInfo.buildNumber;

    final response = await http.get(
      Uri.parse(
          'https://play.google.com/store/apps/details?id=${packageInfo.packageName}'),
      headers: {
        'User-Agent':
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
      },
    );

    if (response.statusCode == 200) {
      // Version patterns
      final versionPatterns = [
        RegExp(r'\[\[\["([\d.]+)"\]\]'),  // New Play Store format
        RegExp(r'\"version\":\s*\"([\d.]+)\"'),  // JSON format
        RegExp(r'Version\s*([\d.]+)'), // Simple version format
        RegExp(r'version=([\d.]+)'),  // URL parameter format
      ];

      // Build number patterns
      final buildPatterns = [
        RegExp(r'versionCode=([\d]+)'),
        RegExp(r'\"versionCode\":\s*\"?([\d]+)\"?'),
        RegExp(r'build\s*([\d]+)'),
      ];

      String? latestVersion;
      for (final pattern in versionPatterns) {
        final match = pattern.firstMatch(response.body);
        print('version match: $match');
        if (match != null) {
          latestVersion = match.group(1)!.trim();
          print('Found version: $latestVersion');
          break;
        }
      }

      String? latestBuildNumber;
      for (final pattern in buildPatterns) {
        final match = pattern.firstMatch(response.body);
        print('build match: $match');
        if (match != null) {
          latestBuildNumber = match.group(1)!.trim();
          print('Found build number: $latestBuildNumber');
          break;
        }
      }

      print('Current version: $currentVersion (build: $currentBuildNumber)');
      print('Latest version: $latestVersion (build: $latestBuildNumber)');

      // Update is available if either version or build number is different
      final updateAvailable = latestVersion != null && (
          latestVersion != currentVersion ||
              (latestBuildNumber != null && latestBuildNumber != currentBuildNumber)
      );

      return UpdateResult(updateAvailable, latestVersion, latestBuildNumber);
    } else {
      print('Failed to fetch Play Store page: ${response.statusCode}');
    }
  } catch (e) {
    print('Error in web scraping fallback: $e');
  }

  return UpdateResult(false, null, null);
}