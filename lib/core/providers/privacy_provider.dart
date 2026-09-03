import 'package:flutter/material.dart';
import '../services/biometric_service.dart';

class PrivacyProvider extends ValueNotifier<bool> with WidgetsBindingObserver {
  static PrivacyProvider? _instance;
  final BiometricService _biometricService = BiometricService();

  PrivacyProvider._internal() : super(true) {
    WidgetsBinding.instance.addObserver(this);
  }

  factory PrivacyProvider() {
    _instance ??= PrivacyProvider._internal();
    return _instance!;
  }

  bool get isMasked => value;

  bool _isAuthenticating = false;

  /// Always force privacy mask (Eye OFF) when app enters background state
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Ignore inactive state when system biometric prompt dialog is active
    if (_isAuthenticating) return;

    if (state == AppLifecycleState.paused) {
      mask();
    }
  }

  /// Lock privacy mode (Eye OFF)
  void mask() {
    if (!value) {
      value = true;
    }
  }

  /// Ensure the user is authenticated (prompts biometric/PIN auth if masked)
  Future<bool> authenticate(BuildContext context) async {
    if (!value) {
      return true; // Already revealed / authenticated
    }
    return toggleWithBiometrics(context);
  }

  /// Toggle privacy mode (Eye ON requires biometric/PIN authentication)
  Future<bool> toggleWithBiometrics(BuildContext context) async {
    if (value) {
      // Currently masked (Eye OFF) -> user wants to reveal (Eye ON)
      final canCheck = await _biometricService.isBiometricsAvailable();
      if (!canCheck) {
        if (context.mounted) {
          _showBiometricSetupDialog(context);
        }
        return false;
      }

      _isAuthenticating = true;
      final authenticated = await _biometricService.authenticate();
      _isAuthenticating = false;

      if (authenticated) {
        value = false; // Reveal digits (Eye ON)
        return true;
      }
      return false;
    } else {
      // Currently revealed -> user wants to mask again (Eye OFF)
      value = true;
      return true;
    }
  }

  void _showBiometricSetupDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        title: const Text('Biometric Security Required'),
        content: const Text(
          'To reveal private financial data, please enable Face ID, Fingerprint, or Device PIN in your device security settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _biometricService.openBiometricSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

/// InheritedNotifier wrapper for automatic Flutter reactive rebuilds
class PrivacyTheme extends InheritedNotifier<PrivacyProvider> {
  const PrivacyTheme({
    super.key,
    required super.notifier,
    required super.child,
  });

  static bool isMaskedOf(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<PrivacyTheme>()?.notifier;
    return provider?.isMasked ?? true;
  }
}
