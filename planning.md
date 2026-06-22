# Biometric Verification Enhancement Plan

A streamlined overview of the biometric improvements.

---

## User Journeys (Non-Technical)

- [x] **Enable Lock**: Prompts for fingerprint/Face ID to turn on.
- [x] **No Hardware**: Displays error: "Biometrics are not supported on this device."
- [x] **Hardware exists but not configured**: Shows setup dialog that links to system settings.
- [x] **Disable Lock**: Requires biometric validation before turning security off.
- [x] **Lockout Prevention**: Auto-disables app lock if device credentials are deleted from OS settings.

---

## Code Changes (Technical)

- [x] **[biometric_service.dart](file:///Volumes/DEV/Projects/FinKeep/FinKeep/lib/core/services/biometric_service.dart)**: Add capability/enrollment check methods and launch settings using `android_intent_plus` and `url_launcher`.
- [x] **[main.dart](file:///Volumes/DEV/Projects/FinKeep/FinKeep/lib/main.dart)**: Bypass lock screen and reset preference if device credentials are completely missing on startup.
- [x] **[settings_screen.dart](file:///Volumes/DEV/Projects/FinKeep/FinKeep/lib/core/common/settings_screen.dart)**: Update switch toggle to check setup status, show settings dialog if unconfigured, and authenticate on disable.

---

## Verification

- [x] **Manual Testing**: Validate behavior with setup, unconfigured, and no-hardware setups on Android and iOS.
- [x] **Lockout Test**: Ensure app is accessible if OS security is removed while app lock is active.
