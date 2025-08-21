import 'package:dartz/dartz.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/errors/exceptions.dart';
import 'package:teriak/core/errors/failure.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/sales_management/data/datasources/sale_remote_data_source.dart';
import 'package:teriak/features/sales_management/domain/repositories/sale_repository.dart';
import 'package:teriak/features/sales_management/data/models/invoice_model.dart';
import 'package:teriak/features/sales_management/domain/entities/invoice_entity.dart';

class SaleRepositoryImpl extends SaleRepository {
  final NetworkInfo networkInfo;
  final SaleRemoteDataSource remoteDataSource;
  SaleRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, void>> cancelSalelProcess(int saleId) {
    // TODO: implement cancelSalelProcess
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, InvoiceModel>> createSalelProcess(
      SaleProcessParams parms) async {
    try {
      final remoteSale = await remoteDataSource.createSale(parms);
      return Right(remoteSale);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.toString()));
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
}
