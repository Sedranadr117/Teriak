import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/exceptions.dart';
import 'package:teriak/core/errors/failure.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/customer_managment/data/datasources/customer_remote_data_source.dart';
import 'package:teriak/features/customer_managment/domain/entities/customer_debts_entity.dart';
import 'package:teriak/features/customer_managment/domain/entities/customer_entity.dart';
import 'package:teriak/features/customer_managment/domain/repositories/customer_repository.dart';

import '../../domain/entities/payment_entity.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CustomerRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<CustomerEntity>>> getCustomers() async {
    try {
      final result = await remoteDataSource.getAllCustomers();
      return Right(result);
    } catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CustomerEntity>> createCustomer(
      CustomerParams params) async {
    try {
      final remoteCustomer = await remoteDataSource.createCustomer(params);
      return Right(remoteCustomer);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CustomerEntity>>> searchCustomer(
      {required SearchParams params}) async {
    try {
      final remoteSearchCustomer =
          await remoteDataSource.searchCustomer(params);

      return Right(remoteSearchCustomer);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errorMessage));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCustomer(int id) async {
    try {
      await remoteDataSource.deleteCustomer(id);

      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure(
          errMessage: e.errorModel.errorMessage,
          statusCode: e.errorModel.status));
    }
  }

  @override
  Future<Either<Failure, CustomerEntity>> editCustomer(
      {required int customereId, required CustomerParams params}) async {
    try {
      final updatedCustomer =
          await remoteDataSource.editCustomerInfo(customereId, params);
      return Right(updatedCustomer);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaymentEntity>> addPayment(
      int customerId, PaymentParams params) async {
    try {
      final payment = await remoteDataSource.addPayment(customerId, params);
      return Right(payment);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CustomerDebtEntity>>> getCustomersDebts(
      int customerId) async {
    try {
      final customerDebts =
          await remoteDataSource.getCustomersDebts(customerId);
      return Right(customerDebts);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }
}
