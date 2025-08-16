import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/exceptions.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/domain/entities/paginated_purchase_entity.dart';

import '../../../../../core/connection/network_info.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';
import '../../domain/repositories/search_purchase_order_repository.dart';
import '../datasources/search_purchase_order_remote_data_source.dart';

class SearchPurchaseOrderRepositoryImpl extends SearchPurchaseOrderRepository {
  final NetworkInfo networkInfo;
  final SearchPurchaseOrderRemoteDataSource remoteDataSource;
  SearchPurchaseOrderRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, PaginatedPurchaseOrderEntity>> getSearchPurchaseOrderBySupplier(
      {required SearchBySupplierParams params}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteSearchPurchaseOrder =
            await remoteDataSource.getSearchPurchaseOrderBySupplier(params);
        return Right(remoteSearchPurchaseOrder);
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
  @override
  Future<Either<Failure, PaginatedPurchaseOrderEntity>> getSearchPurchaseOrderByDateRange(
      {required SearchByDateRangeParams params}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteSearchPurchaseOrder =
            await remoteDataSource.getSearchPurchaseOrderByDateRange(params);
        return Right(remoteSearchPurchaseOrder);
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
