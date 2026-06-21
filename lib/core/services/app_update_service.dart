import 'dart:developer';
import 'package:app_version_update/app_version_update.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppUpdateResult {
  final bool canUpdate;
  final String? storeVersion;
  final String? storeUrl;

  AppUpdateResult({
    required this.canUpdate,
    this.storeVersion,
    this.storeUrl,
  });
}

class AppUpdateService {
  Future<AppUpdateResult> checkForUpdates() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final packageName = packageInfo.packageName;

      // Query Play Store version details directly using app_version_update
      final result = await AppVersionUpdate.checkForUpdates(
        playStoreId: packageName,
      );

      return AppUpdateResult(
        canUpdate: result.canUpdate == true,
        storeVersion: result.storeVersion,
        storeUrl: result.storeUrl,
      );
    } catch (e, st) {
      log('Error in AppUpdateService checking updates: $e\n$st');
      rethrow;
    }
  }
}
