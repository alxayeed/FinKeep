import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onReady() {
    super.onReady();
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        Get.offAllNamed('/login');
      } else {
        Get.offAllNamed('/');
      }
    });
  }
}
