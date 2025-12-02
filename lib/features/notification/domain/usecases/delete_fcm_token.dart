import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/failure.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/notification/domain/repositories/notification_repository.dart';

class DeleteFcmToken {
  final NotificationRepository repository;

  DeleteFcmToken({required this.repository});

  Future<Either<Failure, Unit>> call({required DeleteFcmTokenParams params}) {
    return repository.deleteFcmToken(params: params);
  }
}
