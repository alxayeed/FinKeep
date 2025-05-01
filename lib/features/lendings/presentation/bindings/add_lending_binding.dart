import 'package:get/get.dart';
import 'package:spendly/features/lendings/domain/usecases/add_lending_usecase.dart'; // Ensure correct import
import 'package:spendly/features/lendings/presentation/controllers/add_lending_controller.dart';

class AddLendingBinding extends Bindings {
  @override
  void dependencies() {
    final AddLendingUseCase addLendingUseCase =
        Get.put(AddLendingUseCase(repository: Get.find()));

    Get.lazyPut<AddLendingController>(() => AddLendingController(
          addLendingUseCase: addLendingUseCase,
        ));
  }
}
