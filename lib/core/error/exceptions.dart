abstract class CustomException implements Exception {
  final String message;

  const CustomException({required this.message});
}

class NetworkException extends CustomException {
  const NetworkException({required super.message});
}

class ServerException extends CustomException {
  const ServerException({required super.message});
}

class AuthenticationException extends CustomException {
  const AuthenticationException({required super.message});
}

class ValidationException extends CustomException {
  final String field;

  const ValidationException({required this.field, required super.message});
}

class CacheException extends CustomException {
  const CacheException({required super.message});
}
