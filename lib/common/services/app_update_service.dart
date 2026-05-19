import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

class UpdateInfo {
  const UpdateInfo({
    required this.versionCode,
    required this.versionName,
    required this.apkUrl,
    this.notes,
  });

  final int versionCode;
  final String versionName;
  final String apkUrl;
  final String? notes;

  factory UpdateInfo.fromJson(Map<String, dynamic> json) {
    return UpdateInfo(
      versionCode: _parseInt(json['versionCode']),
      versionName: json['versionName']?.toString() ?? '',
      apkUrl: json['apkUrl']?.toString() ?? '',
      notes: json['notes']?.toString(),
    );
  }

  static int _parseInt(Object? value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class AppUpdateService {
  AppUpdateService({this.updateInfoUrl});

  final String? updateInfoUrl;

  String get _url => updateInfoUrl ?? 
    'https://raw.githubusercontent.com/Harsh-6361/CCQ-task-mangement-app/main/update.json';

  Future<UpdateInfo?> checkForUpdate() async {
    try {
      final info = await fetchUpdateInfo();
      if (info == null || info.apkUrl.isEmpty) return null;

      final packageInfo = await PackageInfo.fromPlatform();
      final localBuildNumber = int.tryParse(packageInfo.buildNumber) ?? 0;
      final localVersion = packageInfo.version;

      if (info.versionCode > localBuildNumber) return info;

      if (info.versionName.isNotEmpty && info.versionName != localVersion) {
        return info;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<UpdateInfo?> fetchUpdateInfo() async {
    try {
      final response = await http.get(Uri.parse(_url)).timeout(
        const Duration(seconds: 10),
      );
      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body);
      if (data is! Map<String, dynamic>) return null;

      return UpdateInfo.fromJson(data);
    } catch (e) {
      return null;
    }
  }
}
