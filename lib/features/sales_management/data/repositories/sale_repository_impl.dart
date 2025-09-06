import 'package:dartz/dartz.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/errors/exceptions.dart';
import 'package:teriak/core/errors/failure.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/sales_management/data/datasources/sale_local_date_source.dart';
import 'package:teriak/features/sales_management/data/datasources/sale_remote_data_source.dart';
import 'package:teriak/features/sales_management/data/models/hive_invoice_model.dart';
import 'package:teriak/features/sales_management/domain/repositories/sale_repository.dart';
import 'package:teriak/features/sales_management/data/models/invoice_model.dart';
import 'package:teriak/features/sales_management/domain/entities/invoice_entity.dart';
import 'package:teriak/features/sales_management/domain/entities/refund_entity.dart';

class SaleRepositoryImpl extends SaleRepository {
  final NetworkInfo networkInfo;
  final SaleRemoteDataSource remoteDataSource;
  final LocalSaleDataSourceImpl localDataSource;

  SaleRepositoryImpl(this.localDataSource,
      {required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, void>> cancelSalelProcess(int saleId) {
    // TODO: implement cancelSalelProcess
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, InvoiceEntity>> createSalelProcess(
      SaleProcessParams parms) async {
    final connected = await networkInfo.isConnected;
    if (connected) {
      try {
        final remoteSale = await remoteDataSource.createSale(parms);
        return Right(remoteSale);
      } on ServerException catch (e) {
        return Left(Failure(
            errMessage: e.errorModel.errorMessage,
            statusCode: e.errorModel.status));
      }
    } else {
      final offlineInvoice = HiveSaleInvoice.fromSaleParams(parms);

      final success = await localDataSource.addInvoice(offlineInvoice);
      if (success) {
        print("✅ تخزنت الفاتورة أوفلاين");
      } else {
        print("❌ صار خطأ وما تخزنت");
      }

      // تحويل الـ HiveSaleInvoice إلى InvoiceModel مؤقتًا للإرجاع
      final invoiceModel = InvoiceModel.fromHiveInvoice(offlineInvoice);
      return Right(invoiceModel);
    }
  }

  @override
  Future<Either<Failure, List<InvoiceEntity>>> getAllSales() async {
    try {
      final remoteInvoice = await remoteDataSource.getAllInvoices();
      return Right(remoteInvoice);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<InvoiceEntity>>> searchInvoiceByDateRange(
      {required SearchInvoiceByDateRangeParams params}) async {
    try {
      final remoteInvoice =
          await remoteDataSource.searchInvoiceByDateRange(params);
      return Right(remoteInvoice);
    } on ServerException catch (e) {
      return Left(
          Failure(errMessage: e.toString(), statusCode: e.errorModel.status));
    }
  }

  @override
  Future<Either<Failure, SaleRefundEntity>> createRefund({
    required int saleInvoiceId,
    required SaleRefundParams params,
  }) async {
    try {
      final remoteRefund = await remoteDataSource.createRefund(
          saleInvoiceId: saleInvoiceId, params: params);
      return Right(remoteRefund);
    } on ServerException catch (e) {
      return Left(Failure(
        errMessage: e.toString(),
        statusCode: e.errorModel.status,
      ));
    }
  }

  @override
  Future<Either<Failure, List<SaleRefundEntity>>> getRefunds() async {
    try {
      final remote = await remoteDataSource.getRefunds();
      return Right(remote);
    } on ServerException catch (e) {
      return Left(Failure(
        errMessage: e.toString(),
        statusCode: e.errorModel.status,
      ));
    }
  }
}
