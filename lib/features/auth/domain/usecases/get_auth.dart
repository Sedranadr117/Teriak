import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class GetAuth {
  final AuthRepository repository;

  GetAuth({required this.repository});

  Future<Either<Failure, AuthEntity>> call({required AuthParams params}) {
    return repository.getAuth(params: params);
  }
}

class mangerLogin {
  final AuthRepository repository;

  mangerLogin({required this.repository});

  Future<Either<Failure, AuthEntity>> call({
    required String email,
    required String password,
  }) {
    return repository.getAuth(
      params: AuthParams(
        email: email,
        password: password,
        authType: AuthType.mangerLogin,
      ),
    );
  }
}
