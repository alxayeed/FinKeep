import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure();

  @override
  List<Object?> get props => [];
}

class NetworkFailure extends Failure {
  final String message;

  const NetworkFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  final String message;

  const ServerFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthenticationFailure extends Failure {
  final String message;

  const AuthenticationFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
