import 'package:dartz/dartz.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/errors/exceptions.dart';
import 'package:teriak/core/errors/failure.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/pharmacy/data/datasources/pharmacy_remote_data_source.dart';
import 'package:teriak/features/pharmacy/domain/entities/pharmacy_entity.dart';
import 'package:teriak/features/pharmacy/domain/repositories/pharmacy_repository.dart';

class PharmacyRepositoryImpl implements PharmacyRepository {
  final PharmacyRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PharmacyRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, PharmacyEntity>> addPharmacy(PhaParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final pharmacyModel =
            await remoteDataSource.addPharmacy(params as dynamic);
        return Right(pharmacyModel);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.toString()));
      }
    } else {
      return Left(Failure(errMessage: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<PharmacyEntity>>> getAllPharmacies() async {
    try {
      final pharmacies = await remoteDataSource.getAllPharmacies();
      return Right(pharmacies);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }

  // @override
  // Future<Either<Failure, PharmacyEntity>> getPharmacyById(String id) async {
  //   if (await networkInfo.isConnected) {
  //     try {
  //       final pharmacy = await remoteDataSource.getPharmacyById(id);
  //       await localDataSource.cachePharmacy(pharmacy);
  //       return Right(pharmacy);
  //     } on ServerException catch (e) {
  //       return Left(Failure(errMessage: e.toString()));
  //     }
  //   } else {
  //     try {
  //       final cachedPharmacy = await localDataSource.getCachedPharmacy(id);
  //       if (cachedPharmacy != null) {
  //         return Right(cachedPharmacy);
  //       } else {
  //         return Left(Failure(errMessage: 'Pharmacy not found in cache'));
  //       }
  //     } on CacheExeption catch (e) {
  //       return Left(Failure(errMessage: e.errorMessage));
  //     }
  //   }
  // }

  // @override
  // Future<Either<Failure, bool>> deletePharmacy(String id) async {
  //   if (await networkInfo.isConnected) {
  //     try {
  //       final result = await remoteDataSource.deletePharmacy(id);
  //       return Right(result);
  //     } on ServerException catch (e) {
  //       return Left(Failure(errMessage: e.toString()));
  //     }
  //   } else {
  //     return Left(Failure(errMessage: 'No internet connection'));
  //   }
  // }
}
