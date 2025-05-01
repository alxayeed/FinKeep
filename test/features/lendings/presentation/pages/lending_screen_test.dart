// import 'package:dartz/dartz.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:get/get.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:spendly/core/common/widgets/error_widget.dart';
// import 'package:spendly/features/lendings/domain/entity/lend_entity.dart';
// import 'package:spendly/features/lendings/domain/repositories/lending_repository.dart';
// import 'package:spendly/features/lendings/domain/usecases/get_all_lendings_usecase.dart';
// import 'package:spendly/features/lendings/presentation/controllers/lendings_controller.dart';
// import 'package:spendly/features/lendings/presentation/screens/lending_list_screen.dart';
// import 'package:spendly/features/lendings/presentation/widgets/lending_list_item.dart';
// import 'package:spendly/features/lendings/presentation/widgets/loading_indicator_widget.dart';
//
// class MockLendingRepository extends Mock implements LendingRepository {}
//
// void main() {
//   late MockLendingRepository mockLendingRepository;
//   late GetAllLendingsUseCase getAllLendingsUseCase;
//   late LendingController controller;
//
//   setUp(() {
//     mockLendingRepository = MockLendingRepository();
//     getAllLendingsUseCase = GetAllLendingsUseCase(mockLendingRepository);
//
//     controller =
//         LendingController(getAllLendingsUseCase: getAllLendingsUseCase);
//     Get.put(
//         controller); // Initialize the controller with fresh state for each test
//   });
//
//   tearDown(() {
//     Get.delete<LendingController>(); // Clean up the controller after each test
//   });
//
//   testWidgets('LendingScreen displays a list of lending cards', (tester) async {
//     final lendings = [
//       LendingEntity(
//         id: '1',
//         amount: 500,
//         date: DateTime.now(),
//         dueDate: DateTime.now().add(Duration(days: 7)),
//         lenderId: 'lender_1',
//         borrowerName: 'John Doe',
//         type: LendingType.given,
//         note: 'Test note',
//       ),
//       LendingEntity(
//         id: '2',
//         amount: 300,
//         date: DateTime.now(),
//         dueDate: DateTime.now().add(Duration(days: 7)),
//         lenderId: 'lender_2',
//         borrowerName: 'Jane Doe',
//         type: LendingType.taken,
//         note: null,
//       ),
//     ];
//
//     when(() => mockLendingRepository.getAllLendings()).thenAnswer(
//       (_) async => Right(lendings),
//     );
//
//     await controller.getAllLendings();
//
//     await tester.pumpWidget(
//       MaterialApp(
//         home: LendingScreen(),
//       ),
//     );
//
//     expect(find.byType(LendingCardWidget), findsNWidgets(2));
//     expect(find.text('Amount: 500'), findsOneWidget);
//     expect(find.text('Amount: 300'), findsOneWidget);
//     expect(find.text('Borrower: John Doe'), findsOneWidget);
//     expect(find.text('Borrower: Jane Doe'), findsOneWidget);
//   });
//
//   testWidgets('LendingScreen shows loading indicator when loading',
//       (tester) async {
//     controller.isLoading.value = true;
//
//     await tester.pumpWidget(
//       MaterialApp(
//         home: LendingScreen(),
//       ),
//     );
//
//     expect(find.byType(LoadingIndicatorWidget), findsOneWidget);
//   });
//
//   testWidgets('LendingScreen shows error indicator when error occurs',
//       (tester) async {
//     controller.errorMessage.value = 'An error occurred';
//
//     await tester.pumpWidget(
//       MaterialApp(
//         home: LendingScreen(),
//       ),
//     );
//
//     expect(find.byType(ErrorIndicatorWidget), findsOneWidget);
//     expect(find.text('An error occurred'), findsOneWidget);
//   });
//
//   testWidgets('LendingScreen displays empty state when no lendings available',
//       (tester) async {
//     controller.lendings.clear();
//
//     await tester.pumpWidget(
//       MaterialApp(
//         home: LendingScreen(),
//       ),
//     );
//
//     expect(find.text('No lendings available'), findsOneWidget);
//   });
// }
