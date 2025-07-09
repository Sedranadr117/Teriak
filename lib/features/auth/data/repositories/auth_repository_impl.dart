import 'package:dartz/dartz.dart';
import 'package:teriak/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:teriak/features/auth/data/datasources/auth_remote_data_source.dart';

import '../../../../../core/connection/network_info.dart';
import '../../../../../core/errors/expentions.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';
import '../../domain/entities/auth_entitiy.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final NetworkInfo networkInfo;
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  AuthRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});
  @override
  Future<Either<Failure, AuthEntity>> getAuth(
      {required AuthParams params}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteAuth = await remoteDataSource.getAuth(params);
        localDataSource.cacheAuth(remoteAuth);
        return Right(remoteAuth);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      try {
        final localAuth = await localDataSource.getLastAuth();
        return Right(localAuth);
      } on CacheExeption catch (e) {
        return Left(Failure(errMessage: e.errorMessage));
      }
    }
  }
}
