import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/failure.dart';
import 'package:teriak/features/settings/domain/entities/user_profile_entity.dart';
import 'package:teriak/features/settings/domain/repositories/user_profile_repository.dart';

class GetUserProfile {
  final UserProfileRepository repository;

  GetUserProfile({required this.repository});

  Future<Either<Failure, UserProfileEntity>> call() {
    return repository.getUserProfile();
  }
}
