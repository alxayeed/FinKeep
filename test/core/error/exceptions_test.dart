import 'package:flutter_test/flutter_test.dart';
import 'package:spendly/core/constants/app_strings.dart';
import 'package:spendly/core/error/exceptions.dart';

void main() {
  group('Exceptions', () {
    test('NetworkException should throw and store the correct message', () {
      try {
        throw NetworkException(message: AppStrings.noInternet);
      } catch (e) {
        expect(e, isA<NetworkException>());
        expect((e as NetworkException).message, AppStrings.noInternet);
      }
    });

    test('ServerException should throw and store the correct message', () {
      try {
        throw ServerException(message: AppStrings.internalServerError);
      } catch (e) {
        expect(e, isA<ServerException>());
        expect((e as ServerException).message, AppStrings.internalServerError);
      }
    });

    test('AuthenticationException should throw and store the correct message',
        () {
      try {
        throw AuthenticationException(message: AppStrings.invalidCredentials);
      } catch (e) {
        expect(e, isA<AuthenticationException>());
        expect((e as AuthenticationException).message,
            AppStrings.invalidCredentials);
      }
    });

    test(
        'ValidationException should throw and store the correct field and error message',
        () {
      try {
        throw ValidationException(
            field: 'email', message: AppStrings.invalidEmailFormat);
      } catch (e) {
        expect(e, isA<ValidationException>());
        expect((e as ValidationException).field, 'email');
        expect(e.message, AppStrings.invalidEmailFormat);
      }
    });

    test('CacheException should throw and store the correct message', () {
      try {
        throw CacheException(message: AppStrings.cacheNotFound);
      } catch (e) {
        expect(e, isA<CacheException>());
        expect((e as CacheException).message, AppStrings.cacheNotFound);
      }
    });
  });
}
