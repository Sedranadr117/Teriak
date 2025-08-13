import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/exceptions.dart';
import 'package:teriak/features/purchase_invoice/AllPurchaseInvoice/domain/entities/purchase_invoice_entity.dart';

import '../../../../../core/connection/network_info.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';
import '../../domain/repositories/add_purchase_invoice_repository.dart';
import '../datasources/add_purchase_invoice_remote_data_source.dart';

class  AddPurchaseInvoiceRepositoryImpl extends  AddPurchaseInvoiceRepository {
  final NetworkInfo networkInfo;
  final  AddPurchaseInvoiceRemoteDataSource remoteDataSource;
   AddPurchaseInvoiceRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure,PurchaseInvoiceEntity>> postAddPurchaseInvoice(
      {required  LanguageParam params,required Map<String,dynamic> body }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteAddPurchaseInvoice = await remoteDataSource.postAddPurchaseInvoice(params,body);
        return Right(remoteAddPurchaseInvoice);
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
