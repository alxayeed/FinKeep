import 'package:get/get.dart';
import 'package:finkeep/core/error/exception_handler.dart';
import '../../domain/entities/expense_category_entity.dart';
import '../../domain/usecases/add_expense_category_usecase.dart';
import '../../domain/usecases/get_expense_categories_usecase.dart';
import '../../domain/usecases/update_expense_category_usecase.dart';
import '../../domain/usecases/delete_expense_category_usecase.dart';

class ExpenseCategoryController extends GetxController {
  final AddExpenseCategoryUseCase addCategoryUseCase;
  final GetExpenseCategoriesUseCase getCategoriesUseCase;
  final UpdateExpenseCategoryUseCase updateCategoryUseCase;
  final DeleteExpenseCategoryUseCase deleteCategoryUseCase;

  ExpenseCategoryController({
    required this.addCategoryUseCase,
    required this.getCategoriesUseCase,
    required this.updateCategoryUseCase,
    required this.deleteCategoryUseCase,
  });

  static const List<ExpenseCategoryEntity> defaultCategories = [
    ExpenseCategoryEntity(id: 'exp_food', displayLabel: 'Food', emoji: '🍔', isCustom: false),
    ExpenseCategoryEntity(id: 'exp_transport', displayLabel: 'Transport', emoji: '🚗', isCustom: false),
    ExpenseCategoryEntity(id: 'exp_family', displayLabel: 'Family', emoji: '🏠', isCustom: false),
    ExpenseCategoryEntity(id: 'exp_personal', displayLabel: 'Personal', emoji: '👤', isCustom: false),
    ExpenseCategoryEntity(id: 'exp_clothing', displayLabel: 'Clothing', emoji: '👕', isCustom: false),
    ExpenseCategoryEntity(id: 'exp_hangout', displayLabel: 'Travelling', emoji: '✈️', isCustom: false), // Using old exp_hangout ID for seamless backward compatibility
    ExpenseCategoryEntity(id: 'exp_utilities', displayLabel: 'Utilities', emoji: '⚡', isCustom: false),
    ExpenseCategoryEntity(id: 'exp_other', displayLabel: 'Other', emoji: '📦', isCustom: false),
  ];

  var categories = <ExpenseCategoryEntity>[].obs;
  var isLoading = false.obs;

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
      final customList = list.where((c) => c.isCustom).toList();
      categories.assignAll([...defaultCategories, ...customList]);
    } catch (e, stackTrace) {
      ExceptionHandler.handle(e, stackTrace, 'ExpenseCategoryController.fetchCategories');
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

    final category = ExpenseCategoryEntity(
      id: 'exp_custom_${DateTime.now().millisecondsSinceEpoch}',
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
      ExceptionHandler.handle(e, stackTrace, 'ExpenseCategoryController.createCategory');
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
      ExceptionHandler.handle(e, stackTrace, 'ExpenseCategoryController.softDeleteCategory');
    } finally {
      isLoading.value = false;
    }
  }

  ExpenseCategoryEntity resolveCategory(String categoryName) {
    final normalized = categoryName.trim().toLowerCase();
    
    // Legacy maps
    if (normalized == 'lend') {
      return categories.firstWhere((c) => c.id == 'exp_other', orElse: () => defaultCategories.last);
    }
    if (normalized == 'hangout') {
      return categories.firstWhere((c) => c.id == 'exp_hangout', orElse: () => defaultCategories[5]);
    }
    
    // Match by ID or displayLabel
    return categories.firstWhere(
      (c) => c.id.toLowerCase() == normalized || c.displayLabel.toLowerCase() == normalized,
      orElse: () => categories.firstWhere((c) => c.id == 'exp_other', orElse: () => defaultCategories.last),
    );
  }
}
