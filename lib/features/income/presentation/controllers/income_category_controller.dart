import 'package:get/get.dart';
import 'package:finkeep/core/error/exception_handler.dart';
import '../../domain/entities/income_category/income_category_entity.dart';
import '../../domain/usecases/add_income_category_usecase.dart';
import '../../domain/usecases/get_income_categories_usecase.dart';
import '../../domain/usecases/update_income_category_usecase.dart';
import '../../domain/usecases/delete_income_category_usecase.dart';

class IncomeCategoryController extends GetxController {
  final AddIncomeCategoryUseCase addCategoryUseCase;
  final GetIncomeCategoriesUseCase getCategoriesUseCase;
  final UpdateIncomeCategoryUseCase updateCategoryUseCase;
  final DeleteIncomeCategoryUseCase deleteCategoryUseCase;

  IncomeCategoryController({
    required this.addCategoryUseCase,
    required this.getCategoriesUseCase,
    required this.updateCategoryUseCase,
    required this.deleteCategoryUseCase,
  });

  static const List<IncomeCategoryEntity> defaultCategories = [
    IncomeCategoryEntity(id: 'cat_salary', displayLabel: 'Salary', emoji: '💼', isCustom: false),
    IncomeCategoryEntity(id: 'cat_freelance', displayLabel: 'Freelance', emoji: '💻', isCustom: false),
    IncomeCategoryEntity(id: 'cat_business', displayLabel: 'Business', emoji: '📈', isCustom: false),
    IncomeCategoryEntity(id: 'cat_allowance', displayLabel: 'Allowance', emoji: '🎁', isCustom: false),
    IncomeCategoryEntity(id: 'cat_investment', displayLabel: 'Investment', emoji: '🪙', isCustom: false),
    IncomeCategoryEntity(id: 'cat_other', displayLabel: 'Other', emoji: '💰', isCustom: false),
  ];

  var categories = <IncomeCategoryEntity>[].obs;
  var isLoading = false.obs;

  // Premium configurations limit gates
  final int maxCustomCategoryLimit = 3;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    isLoading.value = true;
    try {
      final list = await getCategoriesUseCase();
      // Keep only custom categories from DB (to prevent duplicates with hardcoded defaults)
      final customList = list.where((c) => c.isCustom).toList();
      categories.assignAll([...defaultCategories, ...customList]);
    } catch (e, stackTrace) {
      ExceptionHandler.handle(e, stackTrace, 'IncomeCategoryController.fetchCategories');
    } finally {
      isLoading.value = false;
    }
  }

  int get customCategoryCount {
    return categories.where((c) => c.isCustom && !c.isDeleted).length;
  }

  bool get canAddCustomCategory {
    return customCategoryCount < maxCustomCategoryLimit;
  }

  Future<bool> createCategory({
    required String displayLabel,
    required String emoji,
  }) async {
    if (!canAddCustomCategory) {
      return false;
    }

    final category = IncomeCategoryEntity(
      id: 'cat_custom_${DateTime.now().millisecondsSinceEpoch}',
      displayLabel: displayLabel,
      emoji: emoji,
      isCustom: true,
      isDeleted: false,
    );

    isLoading.value = true;
    try {
      await addCategoryUseCase(category);
      await fetchCategories();
      return true;
    } catch (e, stackTrace) {
      ExceptionHandler.handle(e, stackTrace, 'IncomeCategoryController.createCategory');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> softDeleteCategory(String id) async {
    isLoading.value = true;
    try {
      await deleteCategoryUseCase(id);
      await fetchCategories();
    } catch (e, stackTrace) {
      ExceptionHandler.handle(e, stackTrace, 'IncomeCategoryController.softDeleteCategory');
    } finally {
      isLoading.value = false;
    }
  }
}
