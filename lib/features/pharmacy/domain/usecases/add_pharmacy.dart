import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/failure.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/pharmacy/domain/entities/pharmacy_entity.dart';
import 'package:teriak/features/pharmacy/domain/repositories/pharmacy_repository.dart';

class AddPharmacy {
  final PharmacyRepository repository;

  AddPharmacy({required this.repository});

  Future<Either<Failure, PharmacyEntity>> call(PhaParams params) {
    return repository.addPharmacy(params);
  }
}
