import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/failure.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/pharmacy/domain/entities/area_entity.dart';
import 'package:teriak/features/pharmacy/domain/entities/pharmacy_entity.dart';

abstract class PharmacyRepository {
  Future<Either<Failure, PharmacyEntity>> addPharmacy(PhaParams params);
  Future<Either<Failure, List<PharmacyEntity>>> getAllPharmacies();
  Future<Either<Failure, List<AreaEntity>>> getAreas();
  // Future<Either<Failure, PharmacyEntity>> getPharmacyById(String id);
  // Future<Either<Failure, bool>> deletePharmacy(String id);
}
