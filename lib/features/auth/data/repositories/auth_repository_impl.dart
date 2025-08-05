import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/exceptions.dart';
import 'package:teriak/features/auth/data/datasources/auth_remote_data_source.dart';

import '../../../../../core/connection/network_info.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final NetworkInfo networkInfo;
  final AuthRemoteDataSource remoteDataSource;
  AuthRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, AuthEntity>> getAuth(
      {required AuthParams params}) async {
    try {
      final remoteAuth = await remoteDataSource.getAuth(params);
      return Right(remoteAuth);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }
}
