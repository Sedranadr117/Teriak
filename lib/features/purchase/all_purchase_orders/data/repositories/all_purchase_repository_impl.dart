import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/exceptions.dart';
import 'package:teriak/features/purchase/all_purchase_orders/domain/entities/purchase_entity%20.dart';

import '../../../../../core/connection/network_info.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';
import '../../domain/entities/product_item_entity.dart';
import '../../domain/repositories/all_purchase_repository.dart';
import '../datasources/all_purchase_remote_data_source.dart';

class AllPurchaseOrdersRepositoryImpl extends AllPurchaseOrdersRepository {
  final NetworkInfo networkInfo;
  final AllPurchaseOrdersRemoteDataSource remoteDataSource;
  AllPurchaseOrdersRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, List<PurchaseOrderEntity>>> getAllPurchaseOrders(
      {required LanguageParam params}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteAllPurchaseOrders =
            await remoteDataSource.getAllPurchaseOrders(params);
        return Right(remoteAllPurchaseOrders);
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
