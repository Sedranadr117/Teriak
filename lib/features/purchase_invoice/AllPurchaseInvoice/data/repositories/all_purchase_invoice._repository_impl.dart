import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/exceptions.dart';
import 'package:teriak/features/purchase_invoice/AllPurchaseInvoice/domain/entities/paginated_purchase_invoice_entity.dart';
import '../../../../../core/connection/network_info.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';
import '../../domain/repositories/all_purchase_invoice_repository.dart';
import '../datasources/all_purchase_invoice._remote_data_source.dart';

class AllPurchaseInvoiceRepositoryImpl extends AllPurchaseInvoiceRepository {
  final NetworkInfo networkInfo;
  final AllPurchaseInvoiceRemoteDataSource remoteDataSource;
  AllPurchaseInvoiceRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, PaginatedInvoiceEntity>> getAllPurchaseInvoice(
      {required PaginationParams params}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteAllPurchaseInvoice =
            await remoteDataSource.getAllPurchaseInvoice(params);
        return Right(remoteAllPurchaseInvoice);
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
