// // core/platform/device_authenticator.dart
//
// import 'package:local_auth/local_auth.dart';
//
// abstract class DeviceAuthenticator {
//   Future<bool> authenticate({
//     String reason = 'Authenticate to continue',
//   });
// }
//
// class LocalAuthDeviceAuthenticator implements DeviceAuthenticator {
//   final LocalAuthentication _auth = LocalAuthentication();
//
//   @override
//   Future<bool> authenticate({String reason = 'Authenticate'}) async {
//     try {
//       return await _auth.authenticate(
//         localizedReason: reason,
//         options: const AuthenticationOptions(
//           biometricOnly: false,
//           stickyAuth: true,
//         ),
//       );
//     } catch (_) {
//       return false;
//     }
//   }
// }
