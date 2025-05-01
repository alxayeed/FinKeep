import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spendly/core/constants/app_strings.dart';
import 'package:spendly/core/error/failure.dart';
import 'package:spendly/core/usecase/usecase.dart';
import 'package:spendly/features/lendings/domain/entity/lend_entity.dart';
import 'package:spendly/features/lendings/domain/usecases/get_all_lendings_usecase.dart';
import 'package:spendly/features/lendings/presentation/controllers/lendings_controller.dart';

class MockGetAllLendingsUseCase extends Mock implements GetAllLendingsUseCase {}

class FakeNoParams extends Fake implements NoParams {}

void main() {
  late LendingController controller;
  late MockGetAllLendingsUseCase mockGetAllLendingsUseCase;

  setUpAll(() {
    // Register NoParams as a fake to be used with mocktail
    registerFallbackValue(FakeNoParams());
  });

  setUp(() {
    mockGetAllLendingsUseCase = MockGetAllLendingsUseCase();
    controller =
        LendingController(getAllLendingsUseCase: mockGetAllLendingsUseCase);
  });

  test('initial values are correct', () {
    expect(controller.lendings, isEmpty);
    expect(controller.isLoading.value, false);
    expect(controller.errorMessage.value, isNull);
  });

  test('getAllLendings updates lendings on success', () async {
    final lendingList = [
      LendingEntity(
        id: '1',
        amount: 1000,
        date: DateTime(2024, 1, 1),
        dueDate: DateTime(2024, 2, 1),
        lenderId: 'lender1',
        borrowerName: 'John Doe',
        type: LendingType.given,
        note: 'Test note',
      ),
    ];

    when(() => mockGetAllLendingsUseCase(any()))
        .thenAnswer((_) async => Right(lendingList));

    await controller.getAllLendings();

    expect(controller.isLoading.value, false);
    expect(controller.lendings, lendingList);
    expect(controller.errorMessage.value, isNull);
  });

  test('getAllLendings updates errorMessage on failure', () async {
    when(() => mockGetAllLendingsUseCase(any())).thenAnswer(
      (_) async => Left(
        ServerFailure(message: AppStrings.internalServerError),
      ),
    );

    await controller.getAllLendings();

    expect(controller.isLoading.value, false);
    expect(controller.lendings, isEmpty);
    expect(controller.errorMessage.value, AppStrings.internalServerError);
  });
}
