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
  Future<Either<Failure, InvoiceEntity>> createSalelProcess(
      SaleProcessParams parms) async {
    final connected = await networkInfo.isConnected;
    if (connected) {
      try {
        final remoteSale = await remoteDataSource.createSale(parms);
        await localDataSource.upsertInvoice(remoteSale);
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
    final connected = await networkInfo.isConnected;

    if (connected) {
      try {
        final remoteInvoice = await remoteDataSource.getAllInvoices();
        await localDataSource.cacheInvoices(remoteInvoice);
        return Right(remoteInvoice);
      } on ServerException catch (e) {
        final cachedInvoices = localDataSource.getInvoices();
        if (cachedInvoices.isNotEmpty) {
          return Right(cachedInvoices);
        }
        return Left(Failure(errMessage: e.toString()));
      }
    } else {
      final cachedInvoices = localDataSource.getInvoices();
      if (cachedInvoices.isNotEmpty) {
        return Right(cachedInvoices);
      }
      return Left(
        Failure(
          errMessage:
              'No offline invoices available. Please sync online first.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<InvoiceEntity>>> searchInvoiceByDateRange(
      {required SearchInvoiceByDateRangeParams params}) async {
    final connected = await networkInfo.isConnected;

    if (connected) {
      try {
        final remoteInvoice =
            await remoteDataSource.searchInvoiceByDateRange(params);
        return Right(remoteInvoice);
      } on ServerException catch (e) {
        final cachedResults = localDataSource.searchInvoicesByDateRange(
          params.startDate,
          params.endDate,
        );
        if (cachedResults.isNotEmpty) {
          return Right(cachedResults);
        }
        return Left(
          Failure(errMessage: e.toString(), statusCode: e.errorModel.status),
        );
      }
    } else {
      final cachedResults = localDataSource.searchInvoicesByDateRange(
        params.startDate,
        params.endDate,
      );
      if (cachedResults.isNotEmpty) {
        return Right(cachedResults);
      }
      return Left(
        Failure(
          errMessage:
              'No offline invoices match the selected date range. Please connect to the internet.',
        ),
      );
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

  /// Get all offline invoices (pending sync)
  Future<Either<Failure, List<InvoiceEntity>>> getOfflineInvoices() async {
    try {
      final offlineInvoices = localDataSource.getOfflineInvoices();
      return Right(offlineInvoices);
    } catch (e) {
      return Left(Failure(
        errMessage: 'Failed to get offline invoices: $e',
      ));
    }
  }

  /// Get count of offline invoices
  int getOfflineInvoicesCount() {
    return localDataSource.getOfflineInvoicesCount();
  }

  /// Sync offline invoices to server when back online
  Future<Either<Failure, List<InvoiceEntity>>> syncOfflineInvoices() async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return Left(Failure(
        errMessage: 'No internet connection. Cannot sync offline invoices.',
      ));
    }

    try {
      final offlineInvoices = localDataSource.getOfflineInvoices();
      if (offlineInvoices.isEmpty) {
        return Right([]);
      }

      final syncedInvoices = <InvoiceEntity>[];
      final failedInvoices = <InvoiceModel>[];

      for (final offlineInvoice in offlineInvoices) {
        try {
          // Convert InvoiceModel back to SaleProcessParams
          // NOTE: We don't pass the offline ID - backend will assign a new ID
          // The offline invoice will be deleted after successful sync
          final saleParams = SaleProcessParams(
            customerId: offlineInvoice.customerId,
            paymentType: offlineInvoice.paymentType,
            paymentMethod: offlineInvoice.paymentMethod,
            currency: offlineInvoice.currency,
            discountType: offlineInvoice.discountType,
            discountValue: offlineInvoice.discount,
            paidAmount: offlineInvoice.paidAmount,
            debtDueDate: offlineInvoice.debtDueDate,
            items: offlineInvoice.items
                .map((item) => SaleItemParams(
                      stockItemId: item.stockItemId,
                      quantity: item.quantity,
                      unitPrice: item.unitPrice,
                    ))
                .toList(),
          );

          // Create sale on server
          final remoteSale = await remoteDataSource.createSale(saleParams);
          syncedInvoices.add(remoteSale);

          // Remove offline invoice after successful sync
          await localDataSource.deleteOfflineInvoice(offlineInvoice.id);
        } catch (e) {
          // Keep failed invoices for retry later
          failedInvoices.add(offlineInvoice);
          print('Failed to sync invoice ${offlineInvoice.id}: $e');
        }
      }

      if (failedInvoices.isNotEmpty && syncedInvoices.isEmpty) {
        return Left(Failure(
          errMessage:
              'Failed to sync all offline invoices. ${failedInvoices.length} invoices failed.',
        ));
      }

      return Right(syncedInvoices);
    } catch (e) {
      return Left(Failure(
        errMessage: 'Failed to sync offline invoices: $e',
      ));
    }
  }

  /// Delete an offline invoice
  Future<Either<Failure, void>> deleteOfflineInvoice(int id) async {
    try {
      final success = await localDataSource.deleteOfflineInvoice(id);
      if (success) {
        return const Right(null);
      } else {
        return Left(Failure(
          errMessage: 'Failed to delete offline invoice',
        ));
      }
    } catch (e) {
      return Left(Failure(
        errMessage: 'Error deleting offline invoice: $e',
      ));
    }
  }
}
