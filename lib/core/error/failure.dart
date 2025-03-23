import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure();

  @override
  List<Object?> get props => [];
}

class NetworkFailure extends Failure {
  final String message;

  const NetworkFailure(this.message);

  @override
  List<Object?> get props =>
      [message]; // Refers to the 'message' field of NetworkFailure
}
