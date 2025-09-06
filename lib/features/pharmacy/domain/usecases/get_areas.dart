import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/failure.dart';
import 'package:teriak/features/pharmacy/domain/entities/area_entity.dart';
import 'package:teriak/features/pharmacy/domain/repositories/pharmacy_repository.dart';

class GetAreas {
  final PharmacyRepository repository;

  GetAreas({required this.repository});

  Future<Either<Failure, List<AreaEntity>>> call() {
    return repository.getAreas();
  }
}
