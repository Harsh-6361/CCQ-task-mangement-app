import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

const String updateInfoUrl =
  'https://github.com/Harsh-6361/CCQ-task-mangement-app/releases/latest/download/update.json';

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
  Future<UpdateInfo?> checkForUpdate() async {
    final info = await fetchUpdateInfo();
    if (info == null || info.apkUrl.isEmpty) return null;

    final packageInfo = await PackageInfo.fromPlatform();
    final localVersionCode = int.tryParse(packageInfo.buildNumber) ?? 0;

    if (info.versionCode <= localVersionCode) return null;
    return info;
  }

  Future<UpdateInfo?> fetchUpdateInfo() async {
    final response = await http.get(Uri.parse(updateInfoUrl));
    if (response.statusCode != 200) return null;

    final data = jsonDecode(response.body);
    if (data is! Map<String, dynamic>) return null;

    return UpdateInfo.fromJson(data);
  }
}
