import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:finkeep/features/expense/data/datasources/expense_local_datasource.dart';
import 'package:finkeep/features/expense/data/datasources/expense_remote_datasource.dart';
import 'package:finkeep/features/expense/data/models/expense_category_model.dart';
import 'package:finkeep/features/expense/data/models/expense_model.dart';
import 'package:finkeep/features/expense/data/repositories/expense_repository_impl.dart';
import 'package:finkeep/features/expense/domain/entities/category_delete_result.dart';
import 'package:finkeep/features/expense/domain/usecases/add_expense_category_usecase.dart';
import 'package:finkeep/features/expense/domain/usecases/delete_expense_category_usecase.dart';
import 'package:finkeep/features/expense/domain/usecases/get_expense_categories_usecase.dart';
import 'package:finkeep/features/expense/domain/usecases/update_expense_category_usecase.dart';
import 'package:finkeep/features/expense/presentation/controllers/expense_category_controller.dart';

class MockExpenseLocalDataSource extends Mock implements ExpenseLocalDataSource {}
class MockExpenseRemoteDataSource extends Mock implements ExpenseRemoteDataSource {}

void main() {
  late MockExpenseLocalDataSource mockLocalDataSource;
  late MockExpenseRemoteDataSource mockRemoteDataSource;
  late ExpenseRepositoryImpl repository;

  setUp(() {
    mockLocalDataSource = MockExpenseLocalDataSource();
    mockRemoteDataSource = MockExpenseRemoteDataSource();
    repository = ExpenseRepositoryImpl(
      localDataSource: mockLocalDataSource,
      remoteDataSource: mockRemoteDataSource,
    );
  });

  group('Option 2 Category Deletion Logic', () {
    test('Hard deletes category when it has 0 associated expense records', () async {
      final category = ExpenseCategoryModel(
        id: 'exp_custom_1',
        displayLabel: 'Yo',
        emoji: '📦',
        isCustom: true,
        isDeleted: false,
      );

      when(() => mockLocalDataSource.getCategories())
          .thenAnswer((_) async => [category]);
      when(() => mockLocalDataSource.getExpenses())
          .thenAnswer((_) async => []);
      when(() => mockLocalDataSource.deleteCategory('exp_custom_1', hardDelete: true))
          .thenAnswer((_) async {});

      final result = await repository.deleteCategory('exp_custom_1');

      expect(result, equals(CategoryDeleteResult.hardDeleted));
      verify(() => mockLocalDataSource.deleteCategory('exp_custom_1', hardDelete: true)).called(1);
      verifyNever(() => mockLocalDataSource.deleteCategory('exp_custom_1', hardDelete: false));
    });

    test('Soft deletes category when it has at least 1 associated expense record (matched by display label)', () async {
      final category = ExpenseCategoryModel(
        id: 'exp_custom_2',
        displayLabel: 'Gym',
        emoji: '🏋️',
        isCustom: true,
        isDeleted: false,
      );
      final expense = ExpenseModel(
        id: 'e1',
        amount: 50.0,
        category: 'Gym',
        date: DateTime.now(),
      );

      when(() => mockLocalDataSource.getCategories())
          .thenAnswer((_) async => [category]);
      when(() => mockLocalDataSource.getExpenses())
          .thenAnswer((_) async => [expense]);
      when(() => mockLocalDataSource.deleteCategory('exp_custom_2', hardDelete: false))
          .thenAnswer((_) async {});

      final result = await repository.deleteCategory('exp_custom_2');

      expect(result, equals(CategoryDeleteResult.softDeleted));
      verify(() => mockLocalDataSource.deleteCategory('exp_custom_2', hardDelete: false)).called(1);
      verifyNever(() => mockLocalDataSource.deleteCategory('exp_custom_2', hardDelete: true));
    });

    test('Soft deletes category when it has at least 1 associated expense record (matched by id)', () async {
      final category = ExpenseCategoryModel(
        id: 'exp_custom_3',
        displayLabel: 'Freelance',
        emoji: '💻',
        isCustom: true,
        isDeleted: false,
      );
      final expense = ExpenseModel(
        id: 'e2',
        amount: 150.0,
        category: 'exp_custom_3',
        date: DateTime.now(),
      );

      when(() => mockLocalDataSource.getCategories())
          .thenAnswer((_) async => [category]);
      when(() => mockLocalDataSource.getExpenses())
          .thenAnswer((_) async => [expense]);
      when(() => mockLocalDataSource.deleteCategory('exp_custom_3', hardDelete: false))
          .thenAnswer((_) async {});

      final result = await repository.deleteCategory('exp_custom_3');

      expect(result, equals(CategoryDeleteResult.softDeleted));
      verify(() => mockLocalDataSource.deleteCategory('exp_custom_3', hardDelete: false)).called(1);
    });

    test('Auto-purges stale soft-deleted category with 0 expenses on getCategories', () async {
      final activeCategory = ExpenseCategoryModel(
        id: 'exp_food',
        displayLabel: 'Food',
        emoji: '🍔',
        isCustom: false,
        isDeleted: false,
      );
      final staleYoCategory = ExpenseCategoryModel(
        id: 'exp_custom_yo',
        displayLabel: 'Yo',
        emoji: '📦',
        isCustom: true,
        isDeleted: true,
      );

      when(() => mockLocalDataSource.getCategories())
          .thenAnswer((_) async => [activeCategory, staleYoCategory]);
      when(() => mockLocalDataSource.getExpenses())
          .thenAnswer((_) async => []);
      when(() => mockLocalDataSource.deleteCategory('exp_custom_yo', hardDelete: true))
          .thenAnswer((_) async {});

      final categories = await repository.getCategories();

      // "Yo" should be permanently purged and omitted from returned categories
      expect(categories.length, equals(1));
      expect(categories.first.id, equals('exp_food'));
      verify(() => mockLocalDataSource.deleteCategory('exp_custom_yo', hardDelete: true)).called(1);
    });

    test('Retains soft-deleted category with >=1 expense on getCategories for historical integrity', () async {
      final historicalCategory = ExpenseCategoryModel(
        id: 'exp_custom_old',
        displayLabel: 'Old Gym',
        emoji: '🏋️',
        isCustom: true,
        isDeleted: true,
      );
      final expense = ExpenseModel(
        id: 'e3',
        amount: 80.0,
        category: 'Old Gym',
        date: DateTime.now(),
      );

      when(() => mockLocalDataSource.getCategories())
          .thenAnswer((_) async => [historicalCategory]);
      when(() => mockLocalDataSource.getExpenses())
          .thenAnswer((_) async => [expense]);

      final categories = await repository.getCategories();

      expect(categories.length, equals(1));
      expect(categories.first.id, equals('exp_custom_old'));
      expect(categories.first.isDeleted, isTrue);
      verifyNever(() => mockLocalDataSource.deleteCategory(any(), hardDelete: true));
    });
  });

  group('ExpenseCategoryController Delete Flow', () {
    test('deleteCategory calls usecase and returns result', () async {
      final mockAdd = MockAddExpenseCategoryUseCase();
      final mockGet = MockGetExpenseCategoriesUseCase();
      final mockUpdate = MockUpdateExpenseCategoryUseCase();
      final mockDelete = MockDeleteExpenseCategoryUseCase();

      when(() => mockGet.call()).thenAnswer((_) async => []);
      when(() => mockDelete.call('cat_1')).thenAnswer((_) async => CategoryDeleteResult.hardDeleted);

      final controller = ExpenseCategoryController(
        addCategoryUseCase: mockAdd,
        getCategoriesUseCase: mockGet,
        updateCategoryUseCase: mockUpdate,
        deleteCategoryUseCase: mockDelete,
      );

      final result = await controller.deleteCategory('cat_1');

      expect(result, equals(CategoryDeleteResult.hardDeleted));
      verify(() => mockDelete.call('cat_1')).called(1);
    });
  });
}

class MockAddExpenseCategoryUseCase extends Mock implements AddExpenseCategoryUseCase {}
class MockGetExpenseCategoriesUseCase extends Mock implements GetExpenseCategoriesUseCase {}
class MockUpdateExpenseCategoryUseCase extends Mock implements UpdateExpenseCategoryUseCase {}
class MockDeleteExpenseCategoryUseCase extends Mock implements DeleteExpenseCategoryUseCase {}
