import 'package:flutter_test/flutter_test.dart';
import 'package:spendly/core/constants/app_strings.dart';
import 'package:spendly/core/error/failure.dart';
import 'package:spendly/core/error/failure_mapper.dart';

void main() {
  group('FailureMapper', () {
    test('should map ServerFailure to internalServerError message', () {
      final failure = ServerFailure(message: AppStrings.internalServerError);
      final message = FailureMapper.mapFailureToMessage(failure);

      expect(message, AppStrings.internalServerError);
    });

    test('should map NetworkFailure to noInternet message', () {
      final failure = NetworkFailure(message: AppStrings.noInternet);
      final message = FailureMapper.mapFailureToMessage(failure);

      expect(message, AppStrings.noInternet);
    });

    test('should map AuthenticationFailure to invalidCredentials message', () {
      final failure =
          AuthenticationFailure(message: AppStrings.invalidCredentials);
      final message = FailureMapper.mapFailureToMessage(failure);

      expect(message, AppStrings.invalidCredentials);
    });

    test('should map unknown Failure to exceptionNotHandled message', () {
      final failure = UnknownFailure(); // Using the UnknownFailure class
      final message = FailureMapper.mapFailureToMessage(failure);

      expect(message, AppStrings.exceptionNotHandled);
    });
  });
}
