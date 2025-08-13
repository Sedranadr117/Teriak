import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/exceptions.dart';
import 'package:teriak/features/purchase_invoice/AllPurchaseInvoice/domain/entities/purchase_invoice_entity.dart';
import '../../../../../core/connection/network_info.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';
import '../../domain/repositories/edit_purchase_invoice_repository.dart';
import '../datasources/edit_purchase_invoice_remote_data_source.dart';

class EditPurchaseInvoiceRepositoryImpl extends EditPurchaseInvoiceRepository {
  final NetworkInfo networkInfo;
  final EditPurchaseInvoiceRemoteDataSource remoteDataSource;
  EditPurchaseInvoiceRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, PurchaseInvoiceEntity>> putEditPurchaseInvoice(
      {required EditPurchaseInvoiceParams params,required Map<String,dynamic> body}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteEditPurchaseInvoice =
            await remoteDataSource.putEditPurchaseInvoice(params,body);
        return Right(remoteEditPurchaseInvoice);
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
