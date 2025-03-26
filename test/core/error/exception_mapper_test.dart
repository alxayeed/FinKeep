import 'package:flutter_test/flutter_test.dart';
import 'package:spendly/core/constants/app_strings.dart';
import 'package:spendly/core/error/exception_mapper.dart';
import 'package:spendly/core/error/exceptions.dart';
import 'package:spendly/core/error/failure.dart';

void main() {
  late ExceptionMapper exceptionMapper;

  setUp(() {
    exceptionMapper = ExceptionMapper();
  });

  group('ExceptionMapper', () {
    test('should map NetworkException to NetworkFailure', () {
      final exception = NetworkException(message: AppStrings.noInternet);
      final result = exceptionMapper.map(exception);
      expect(result, isA<NetworkFailure>());
      expect((result as NetworkFailure).message, AppStrings.noInternet);
    });

    test('should map ServerException to ServerFailure', () {
      final exception =
          ServerException(message: AppStrings.internalServerError);
      final result = exceptionMapper.map(exception);
      expect(result, isA<ServerFailure>());
      expect((result as ServerFailure).message, AppStrings.internalServerError);
    });

    test('should map AuthenticationException to AuthenticationFailure', () {
      final exception =
          AuthenticationException(message: AppStrings.invalidCredentials);
      final result = exceptionMapper.map(exception);
      expect(result, isA<AuthenticationFailure>());
      expect((result as AuthenticationFailure).message,
          AppStrings.invalidCredentials);
    });

    test('should throw UnimplementedError for unknown exception types', () {
      final exception = Exception('Unknown exception');
      expect(() => exceptionMapper.map(exception),
          throwsA(isA<UnimplementedError>()));
    });

    test(
        'should map UnknownException to ServerFailure with unknownError message',
        () {
      final exception = UnknownException(message: AppStrings.unknownError);
      final result = exceptionMapper.map(exception);
      expect(result, isA<UnknownFailure>());
      expect((result as UnknownFailure).message, AppStrings.unknownError);
    });
  });
}
