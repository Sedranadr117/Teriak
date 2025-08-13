import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/exceptions.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/purchase_order/delete_purchase_order/data/datasources/delete_supplier_remote_data_source.dart';
import 'package:teriak/features/purchase_order/delete_purchase_order/domain/repositories/delete_supplier_repository.dart';
import '../../../../../core/connection/network_info.dart';
import '../../../../../core/errors/failure.dart';

class DeletePurchaseOrderRepositoryImpl extends DeletePurchaseOrderRepository {
  final NetworkInfo networkInfo;
  final DeletePurchaseOrderRemoteDataSource remoteDataSource;
  DeletePurchaseOrderRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, void>> deletePurchaseOrder(
      {required DeletePurchaseOrderParams params}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteDeleteDeletePurchaseOrder =
            await remoteDataSource.deletePurchaseOrder(params);
        return Right(remoteDeleteDeletePurchaseOrder);
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
