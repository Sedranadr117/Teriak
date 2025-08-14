import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/exceptions.dart';
import 'package:teriak/features/purchase/all_purchase_orders/domain/entities/purchase_entity%20.dart';

import '../../../../../core/connection/network_info.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';

import '../../domain/repositories/add_purchase_repository.dart';
import '../datasources/add_purchase_remote_data_source.dart';

class AddPurchaseOrderRepositoryImpl extends AddPurchaseOrderRepository {
  final NetworkInfo networkInfo;
  final AddPurchaseOrderRemoteDataSource remoteDataSource;
  AddPurchaseOrderRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, PurchaseOrderEntity>> postAddPurchaseOrder(
      {required LanguageParam params,required Map<String, dynamic> body}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteAddPurchaseOrder =
            await remoteDataSource.postAddPurchaseOrder(params,body);
        return Right(remoteAddPurchaseOrder);
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
