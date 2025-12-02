import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';
import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

class GetNotification {
  final NotificationRepository repository;

  GetNotification({required this.repository});

  Future<Either<Failure, NotificationPaginatedEntity>> call(
      {required NotificationParams params}) {
    return repository.getNotification(params: params);
  }
}
