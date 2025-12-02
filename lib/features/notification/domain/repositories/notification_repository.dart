import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';
import '../entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<Either<Failure, NotificationPaginatedEntity>> getNotification(
      {required NotificationParams params});
      
  Future<Either<Failure, Unit>> postFcmToken(
      {required FcmTokenParams params});

  Future<Either<Failure, Unit>> deleteFcmToken(
      {required DeleteFcmTokenParams params});

}