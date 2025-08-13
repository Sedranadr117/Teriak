import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/exceptions.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/domain/entities/paginated_purchase_entity.dart';

import '../../../../../core/connection/network_info.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';
import '../../domain/repositories/all_purchase_repository.dart';
import '../datasources/all_purchase_remote_data_source.dart';

class AllPurchaseOrdersRepositoryImpl extends AllPurchaseOrdersRepository {
  final NetworkInfo networkInfo;
  final AllPurchaseOrdersRemoteDataSource remoteDataSource;
  AllPurchaseOrdersRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, PaginatedPurchaseOrderEntity>> getAllPurchaseOrders(
      {required PaginationParams params}) async {
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
