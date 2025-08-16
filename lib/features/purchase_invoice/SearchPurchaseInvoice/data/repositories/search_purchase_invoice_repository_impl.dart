import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/exceptions.dart';
import 'package:teriak/features/purchase_invoice/AllPurchaseInvoice/domain/entities/paginated_purchase_invoice_entity.dart';
import 'package:teriak/features/purchase_invoice/SearchPurchaseInvoice/data/datasources/search_purchase_invoice_remote_data_source.dart';
import 'package:teriak/features/purchase_invoice/SearchPurchaseInvoice/domain/repositories/search_purchase_invoice_repository.dart';

import '../../../../../core/connection/network_info.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';

class SearchPurchaseInvoiceRepositoryImpl
    extends SearchPurchaseInvoiceRepository {
  final NetworkInfo networkInfo;
  final SearchPurchaseInvoiceRemoteDataSource remoteDataSource;
  SearchPurchaseInvoiceRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, PaginatedInvoiceEntity>>
      getSearchPurchaseInvoiceBySupplier(
          {required SearchBySupplierParams params}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteSearchPurchaseInvoice =
            await remoteDataSource.getSearchPurchaseInvoiceBySupplier(params);
        return Right(remoteSearchPurchaseInvoice);
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
  Future<Either<Failure, PaginatedInvoiceEntity>>
      getSearchPurchaseInvoiceByDateRange(
          {required SearchByDateRangeParams params}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteSearchPurchaseInvoice =
            await remoteDataSource.getSearchPurchaseInvoiceByDateRange(params);
        return Right(remoteSearchPurchaseInvoice);
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
