import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/failure.dart';
import 'package:teriak/features/pharmacy/domain/entities/pharmacy_entity.dart';
import 'package:teriak/features/pharmacy/domain/repositories/pharmacy_repository.dart';

class GetAllPharmacies {
  final PharmacyRepository repository;

  GetAllPharmacies({required this.repository});

  Future<Either<Failure, List<PharmacyEntity>>> call() {
    return repository.getAllPharmacies();
  }
}
