import 'dart:io';
import 'package:dartz/dartz.dart';

import '../../../../../core/connection/network_info.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_data_source.dart';

class NotificationRepositoryImpl extends NotificationRepository {
  final NetworkInfo networkInfo;
  final NotificationRemoteDataSource remoteDataSource;
  NotificationRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, NotificationPaginatedEntity>> getNotification(
      {required NotificationParams params}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteNotification =
            await remoteDataSource.getNotification(params);
        return Right(remoteNotification);
      } on ServerException catch (e) {
        return Left(Failure(
          errMessage: e.errorModel.errorMessage,
          statusCode: e.errorModel.status,
        ));
      } on SocketException catch (e) {
        return Left(Failure(
          errMessage: 'Connection error: ${e.message}',
          statusCode: 0,
        ));
      } on Exception catch (e) {
        return Left(Failure(
          errMessage: 'An error occurred: ${e.toString()}',
          statusCode: 0,
        ));
      }
    } else {
      return Left(Failure(errMessage: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Unit>> postFcmToken(
      {required FcmTokenParams params}) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.postFcmToken(params);
        return Right(unit);
      } on ServerException catch (e) {
        return Left(Failure(
          errMessage: e.errorModel.errorMessage,
          statusCode: e.errorModel.status,
        ));
      } on SocketException catch (e) {
        return Left(Failure(
          errMessage: 'Connection error: ${e.message}',
          statusCode: 0,
        ));
      } on Exception catch (e) {
        return Left(Failure(
          errMessage: 'An error occurred: ${e.toString()}',
          statusCode: 0,
        ));
      }
    } else {
      return Left(Failure(errMessage: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteFcmToken(
      {required DeleteFcmTokenParams params}) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteFcmToken(params);
        return Right(unit);
      } on ServerException catch (e) {
        return Left(Failure(
          errMessage: e.errorModel.errorMessage,
          statusCode: e.errorModel.status,
        ));
      }
    } else {
      return Left(Failure(errMessage: 'No internet connection'));
    }
  }
}
