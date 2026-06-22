import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:url_launcher/url_launcher.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> isBiometricsAvailable() async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await _auth.isDeviceSupported();
      return canAuthenticate;
    } catch (e, st) {
      log('Error checking biometrics availability: $e\n$st');
      return false;
    }
  }

  Future<bool> isBiometricHardwareAvailable() async {
    try {
      return await _auth.canCheckBiometrics;
    } catch (e, st) {
      log('Error checking biometric hardware availability: $e\n$st');
      return false;
    }
  }

  Future<bool> hasEnrolledBiometrics() async {
    try {
      final List<BiometricType> availableBiometrics = await _auth.getAvailableBiometrics();
      return availableBiometrics.isNotEmpty;
    } catch (e, st) {
      log('Error checking enrolled biometrics: $e\n$st');
      return false;
    }
  }

  Future<bool> openBiometricSettings() async {
    try {
      if (Platform.isAndroid) {
        const intent = AndroidIntent(
          action: 'android.settings.SECURITY_SETTINGS',
        );
        await intent.launch();
        return true;
      } else if (Platform.isIOS) {
        final Uri url = Uri.parse('app-settings:');
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
          return true;
        }
      }
      return false;
    } catch (e, st) {
      log('Error opening biometric settings: $e\n$st');
      return false;
    }
  }

  Future<bool> authenticate() async {
    try {
      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'Please authenticate to unlock FinKeep',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false, // Falls back to device PIN/Pattern/Password if biometric is not enrolled or fails
        ),
      );
      return didAuthenticate;
    } on PlatformException catch (e, st) {
      log('PlatformException during biometric authentication: $e\n$st');
      return false;
    } catch (e, st) {
      log('Error during biometric authentication: $e\n$st');
      return false;
    }
  }
}
