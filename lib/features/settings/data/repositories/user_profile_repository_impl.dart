import 'package:dartz/dartz.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/errors/exceptions.dart';
import 'package:teriak/core/errors/failure.dart';
import 'package:teriak/features/settings/data/datasources/user_profile_remote_data_source.dart';
import 'package:teriak/features/settings/domain/entities/user_profile_entity.dart';
import 'package:teriak/features/settings/domain/repositories/user_profile_repository.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final NetworkInfo networkInfo;
  final UserProfileRemoteDataSource remoteDataSource;

  UserProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserProfileEntity>> getUserProfile() async {
    try {
      final remoteUserProfile = await remoteDataSource.getUserProfile();
      return Right(remoteUserProfile);
    } on ServerException catch (e) {
      return Left(Failure(
        errMessage: e.errorModel.errorMessage,
        statusCode: e.errorModel.status,
      ));
    } catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }
}
