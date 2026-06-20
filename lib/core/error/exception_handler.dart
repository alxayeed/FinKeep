import 'dart:developer' as developer;
import 'package:finkeep/core/constants/app_strings.dart';
import 'exceptions.dart';
import 'failure.dart';

class ExceptionHandler {
  /// Handles, logs, and maps any exception to a [Failure] object.
  /// 
  /// [exception] is the caught error (dynamic).
  /// [stackTrace] is the optional StackTrace.
  /// [context] is a description of where the error occurred (e.g., 'AuthController.login').
  static Failure handle(dynamic exception, [StackTrace? stackTrace, String? context]) {
    final logMessage = 'Exception caught${context != null ? ' in $context' : ''}';
    
    // Log the error and stack trace to the console
    developer.log(
      logMessage,
      name: 'ExceptionHandler',
      error: exception,
      stackTrace: stackTrace,
    );

    // Map to Failure if it is an Exception we recognize
    if (exception is Failure) {
      return exception;
    } else if (exception is NetworkException) {
      return NetworkFailure(message: exception.message);
    } else if (exception is ServerException) {
      return ServerFailure(message: exception.message);
    } else if (exception is ParsingException) {
      return ParsingFailure(message: exception.message);
    } else if (exception is AuthenticationException) {
      return AuthenticationFailure(message: exception.message);
    } else if (exception is UnknownException) {
      return UnknownFailure(message: exception.message);
    } else if (exception is Exception) {
      // General exception
      return UnknownFailure(message: exception.toString().replaceAll('Exception: ', ''));
    }

    // Dynamic error fallback
    final message = exception?.toString() ?? AppStrings.unknownError;
    return UnknownFailure(message: message);
  }
}
