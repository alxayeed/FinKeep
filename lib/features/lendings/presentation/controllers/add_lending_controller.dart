// import 'package:get/get.dart';
//
// import '../../domain/entity/lending/lending_entity.dart';
// import '../../domain/entity/lending_person_entity.dart';
// import '../../domain/entity/repayment/repayment_entity.dart';
// import '../../domain/usecases/add_lending_usecase.dart';
// import '../../domain/usecases/delete_lending_usecase.dart';
// import '../../domain/usecases/get_lendings_usecase.dart';
// import '../../domain/usecases/lending_person/add_person_usecase.dart';
// import '../../domain/usecases/lending_person/delete_person_usecase.dart';
// import '../../domain/usecases/lending_person/get_user_persons_usecase.dart';
// import '../../domain/usecases/lending_person/update_person_usecase.dart';
// import '../../domain/usecases/repayment/add_repayment_usecase.dart';
// import '../../domain/usecases/repayment/delete_repayment_usecase.dart';
// import '../../domain/usecases/repayment/get_repayments_for_lending_usecase.dart';
// import '../../domain/usecases/repayment/update_repayment_usecase.dart';
// import '../../domain/usecases/update_lending_usecase.dart';
//
// class LendingsController extends GetxController {
//   final AddLendingUseCase addLendingUseCase;
//   final GetLendingsUseCase getLendingsUseCase;
//   final UpdateLendingUseCase updateLendingUseCase;
//   final DeleteLendingUseCase deleteLendingUseCase;
//   final AddPersonUseCase addPersonUseCase;
//   final GetUserPersonsUseCase getUserPersonsUseCase;
//   final UpdatePersonUseCase updatePersonUseCase;
//   final DeletePersonUseCase deletePersonUseCase;
//   final AddRepaymentUseCase addRepaymentUseCase;
//   final GetRepaymentsForLendingUseCase getRepaymentsUseCase;
//   final UpdateRepaymentUseCase updateRepaymentUseCase;
//   final DeleteRepaymentUseCase deleteRepaymentUseCase;
//
//   LendingsController({
//     required this.addLendingUseCase,
//     required this.getLendingsUseCase,
//     required this.updateLendingUseCase,
//     required this.deleteLendingUseCase,
//     required this.addPersonUseCase,
//     required this.getUserPersonsUseCase,
//     required this.updatePersonUseCase,
//     required this.deletePersonUseCase,
//     required this.addRepaymentUseCase,
//     required this.getRepaymentsUseCase,
//     required this.updateRepaymentUseCase,
//     required this.deleteRepaymentUseCase,
//   });
//
//   final lendings = <LendingEntity>[].obs;
//   final persons = <LendingPersonEntity>[].obs;
//   final repayments = <RepaymentEntity>[].obs;
//
//   final isLoading = false.obs;
//   final errorMessage = Rx<String?>(null);
//
//   // --- Lending Methods ---
//
//   Future<void> fetchLendings({bool showLoading = true}) async {
//     if (showLoading) isLoading.value = true;
//     errorMessage.value = null;
//     final result = await getLendingsUseCase();
//     result.fold(
//       (failure) => errorMessage.value = failure.message,
//       (list) => lendings.assignAll(list),
//     );
//     if (showLoading) isLoading.value = false;
//   }
//
//   Future<void> submitLending(LendingEntity lending) async {
//     isLoading.value = true;
//     errorMessage.value = null;
//
//     LendingEntity lendingToSave = lending;
//
//     if (lending.person.id.isEmpty) {
//       final personResult = await addPersonUseCase(lending.person);
//       personResult.fold(
//         (failure) => errorMessage.value = failure.message,
//         (createdPerson) =>
//             lendingToSave = lending.copyWith(person: createdPerson),
//       );
//       if (errorMessage.value != null) {
//         isLoading.value = false;
//         return;
//       }
//     }
//
//     final result = await addLendingUseCase(lendingToSave);
//     result.fold(
//       (failure) => errorMessage.value = failure.message,
//       (_) => fetchLendings(showLoading: false),
//     );
//     isLoading.value = false;
//   }
//
//   Future<void> updateLending(LendingEntity lending) async {
//     isLoading.value = true;
//     final result = await updateLendingUseCase(lending);
//     result.fold(
//       (failure) => errorMessage.value = failure.message,
//       (_) => fetchLendings(showLoading: false),
//     );
//     isLoading.value = false;
//   }
//
//   Future<void> deleteLending(String lendingId) async {
//     isLoading.value = true;
//     final result = await deleteLendingUseCase(lendingId);
//     result.fold(
//       (failure) => errorMessage.value = failure.message,
//       (_) => fetchLendings(showLoading: false),
//     );
//     isLoading.value = false;
//   }
//
//   // --- Person Methods ---
//
//   Future<void> fetchUserPersons(String userId, {String? nameFilter}) async {
//     isLoading.value = true;
//     final result = await getUserPersonsUseCase(userId, nameFilter: nameFilter);
//     result.fold(
//       (failure) => errorMessage.value = failure.message,
//       (list) => persons.assignAll(list),
//     );
//     isLoading.value = false;
//   }
//
//   Future<void> addPerson(LendingPersonEntity person) async {
//     isLoading.value = true;
//     final result = await addPersonUseCase(person);
//     result.fold(
//       (failure) => errorMessage.value = failure.message,
//       (createdPerson) => persons.add(createdPerson),
//     );
//     isLoading.value = false;
//   }
//
//   Future<void> updatePerson(LendingPersonEntity person) async {
//     isLoading.value = true;
//     final result = await updatePersonUseCase(person);
//     result.fold(
//       (failure) => errorMessage.value = failure.message,
//       (_) => fetchUserPersons(person.userId),
//     );
//     isLoading.value = false;
//   }
//
//   Future<void> deletePerson(String personId, String userId) async {
//     isLoading.value = true;
//     final result = await deletePersonUseCase(personId);
//     result.fold(
//       (failure) => errorMessage.value = failure.message,
//       (_) => fetchUserPersons(userId),
//     );
//     isLoading.value = false;
//   }
//
//   // --- Repayment Methods ---
//
//   Future<void> fetchRepayments(String lendingId) async {
//     isLoading.value = true;
//     final result = await getRepaymentsUseCase(lendingId);
//     result.fold(
//       (failure) => errorMessage.value = failure.message,
//       (list) => repayments.assignAll(list),
//     );
//     isLoading.value = false;
//   }
//
//   Future<void> addRepayment(RepaymentEntity repayment) async {
//     isLoading.value = true;
//     final result = await addRepaymentUseCase(repayment);
//     result.fold(
//       (failure) => errorMessage.value = failure.message,
//       (_) => fetchRepayments(repayment.lendingId),
//     );
//     isLoading.value = false;
//   }
//
//   Future<void> updateRepayment(RepaymentEntity repayment) async {
//     isLoading.value = true;
//     final result = await updateRepaymentUseCase(repayment);
//     result.fold(
//       (failure) => errorMessage.value = failure.message,
//       (_) => fetchRepayments(repayment.lendingId),
//     );
//     isLoading.value = false;
//   }
//
//   Future<void> deleteRepayment(RepaymentEntity repayment) async {
//     isLoading.value = true;
//     final result = await deleteRepaymentUseCase(repayment.id);
//     result.fold(
//       (failure) => errorMessage.value = failure.message,
//       (_) => fetchRepayments(repayment.lendingId),
//     );
//     isLoading.value = false;
//   }
// }
