import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AppPermissionHandler {
  static Future<bool> request(Permission permission,
      {BuildContext? context}) async {
    if (Platform.isAndroid || Platform.isIOS) {
      final status = await permission.request();

      if (status.isGranted) return true;

      if (status.isDenied && context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Permission ${permission.toString()} is required.'),
          ),
        );
      }

      if (status.isPermanentlyDenied) {
        openAppSettings();
      }

      return false;
    }

    return true;
  }
}
