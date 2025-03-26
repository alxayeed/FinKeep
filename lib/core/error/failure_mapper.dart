import '../constants/app_strings.dart';
import 'failure.dart';

class FailureMapper {
  static String mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    } else if (failure is NetworkFailure) {
      return failure.message;
    } else if (failure is AuthenticationFailure) {
      return failure.message;
    } else if (failure is UnknownFailure) {
      return AppStrings.exceptionNotHandled;
    } else {
      return AppStrings.exceptionNotHandled;
    }
  }
}
