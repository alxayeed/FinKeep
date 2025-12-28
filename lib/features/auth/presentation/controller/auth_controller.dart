import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:spendly/core/usecase/usecase.dart';
import 'package:spendly/features/auth/domain/entity/user_entity.dart';
import 'package:spendly/features/auth/domain/usecases/login_usecase.dart';
import 'package:spendly/features/auth/domain/usecases/logout_usecase.dart';
import 'package:spendly/features/auth/domain/usecases/register_usecase.dart';

class AuthController extends GetxController {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;

  AuthController({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
  });

  final Rx<UserEntity?> _user = Rx<UserEntity?>(null);

  UserEntity? get user => _user.value;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserFromFirebase();
  }

  void _loadUserFromFirebase() {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      _user.value = UserEntity(email: firebaseUser.email, id: firebaseUser.uid);
    }
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    errorMessage.value = '';
    final result = await loginUseCase(
      LoginParams(email: email, password: password),
    );
    result.fold(
      (failure) => errorMessage.value =
          failure.message ?? 'Unknown error ${failure.message}',
      (userEntity) => _user.value = userEntity,
    );
    isLoading.value = false;
  }

  Future<void> register(String email, String password) async {
    isLoading.value = true;
    errorMessage.value = '';
    final result = await registerUseCase(
      RegisterParams(email: email, password: password),
    );
    result.fold(
      (failure) => errorMessage.value =
          failure.message ?? 'Unknown error ${failure.message}',
      (userEntity) => _user.value = userEntity,
    );
    isLoading.value = false;
  }

  Future<void> logout() async {
    isLoading.value = true;
    errorMessage.value = '';
    final result = await logoutUseCase(NoParams());
    result.fold(
      (failure) => errorMessage.value =
          failure.message ?? 'Unknown error ${failure.message}',
      (_) => _user.value = null,
    );
    isLoading.value = false;
  }
}
