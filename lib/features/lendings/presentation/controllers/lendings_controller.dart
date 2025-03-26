import 'package:get/get.dart';
import 'package:spendly/core/error/failure.dart';
import 'package:spendly/features/lendings/domain/usecases/get_all_lendings_usecase.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entity/lend_entity.dart';

class LendingController extends GetxController {
  final GetAllLendingsUseCase getAllLendingsUseCase;

  LendingController({required this.getAllLendingsUseCase});

  var lendings = <LendingEntity>[].obs;
  var isLoading = false.obs;
  var errorMessage = RxnString();

  Future<void> getAllLendings() async {
    isLoading.value = true;
    errorMessage.value = null;

    final result = await getAllLendingsUseCase(NoParams());

    result.fold(
      (failure) => errorMessage.value = (failure as ServerFailure).message,
      (data) => lendings.assignAll(data),
    );

    isLoading.value = false;
  }
}
