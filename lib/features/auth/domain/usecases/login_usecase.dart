import 'package:dartz/dartz.dart';
import 'package:spendly/core/error/failure.dart';
import 'package:spendly/core/usecase/usecase.dart';
import 'package:spendly/features/auth/domain/entity/user_entity.dart';
import 'package:spendly/features/auth/domain/repository/auth_repository.dart';

class LoginUseCase implements UseCase<UserEntity, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) async {
    return await repository.login(params.email, params.password);
  }
}

class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});
}
