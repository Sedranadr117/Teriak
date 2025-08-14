import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/exceptions.dart';
import 'package:teriak/features/purchase/all_purchase_orders/domain/entities/purchase_entity%20.dart';

import '../../../../../core/connection/network_info.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';

import '../../domain/repositories/details_purchase_repository.dart';
import '../datasources/details_purchase_remote_data_source.dart';

class DetailsPurchaseOrdersRepositoryImpl
    extends DetailsPurchaseOrdersRepository {
  final NetworkInfo networkInfo;
  final DetailsPurchaseOrdersRemoteDataSource remoteDataSource;
  DetailsPurchaseOrdersRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, PurchaseOrderEntity>> getDetailsPurchaseOrders(
      {required DetailsPurchaseOrdersParams params}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteDetailsPurchaseOrders =
            await remoteDataSource.getDetailsPurchaseOrders(params);
        return Right(remoteDetailsPurchaseOrders);
      } on ServerException catch (e) {
        return Left(Failure(
          errMessage: e.errorModel.errorMessage,
          statusCode: e.errorModel.status,
        ));
      }
    } else {
      return Left(Failure(errMessage: 'No internet connection'));
    }
  }
}
