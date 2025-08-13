import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/exceptions.dart';
import 'package:teriak/features/purchase_invoice/AllPurchaseInvoice/domain/entities/purchase_invoice_entity.dart';
import 'package:teriak/features/purchase_invoice/PurchaseInvoiceDetails/data/datasources/purchase_invoice_details_remote_data_source.dart';
import 'package:teriak/features/purchase_invoice/PurchaseInvoiceDetails/domain/repositories/purchase_invoice_details_repository.dart';

import '../../../../../core/connection/network_info.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';

class PurchaseInvoiceDetailsRepositoryImpl
    extends PurchaseInvoiceDetailsRepository {
  final NetworkInfo networkInfo;
  final PurchaseInvoiceDetailsRemoteDataSource remoteDataSource;
  PurchaseInvoiceDetailsRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, PurchaseInvoiceEntity>>
      getPurchaseInvoiceDetails(
          {required PurchaseInvoiceDetailsParams params}) async {
    if (await networkInfo.isConnected) {
      try {
        final remotePurchaseInvoiceDetails =
            await remoteDataSource.getPurchaseInvoiceDetails(params);
        return Right(remotePurchaseInvoiceDetails);
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
