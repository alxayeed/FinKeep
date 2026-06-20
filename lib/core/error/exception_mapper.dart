import 'package:finkeep/core/constants/app_strings.dart';
import 'package:finkeep/core/error/exceptions.dart';

import 'failure.dart';

class ExceptionMapper {
  Failure map(Exception exception) {
    if (exception is NetworkException) {
      return NetworkFailure(message: exception.message);
    } else if (exception is ServerException) {
      return ServerFailure(message: exception.message);
    } else if (exception is ParsingException) {
      return ParsingFailure(message: exception.message);
    } else if (exception is AuthenticationException) {
      return AuthenticationFailure(message: exception.message);
    } else if (exception is UnknownException) {
      return UnknownFailure(message: exception.message);
    } else {
      throw UnimplementedError(AppStrings.exceptionNotHandled);
    }
  }
}
