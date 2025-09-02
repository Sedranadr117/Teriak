import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/failure.dart';
import 'package:teriak/features/settings/domain/entities/user_profile_entity.dart';

abstract class UserProfileRepository {
  Future<Either<Failure, UserProfileEntity>> getUserProfile();
}
