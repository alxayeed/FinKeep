import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

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
