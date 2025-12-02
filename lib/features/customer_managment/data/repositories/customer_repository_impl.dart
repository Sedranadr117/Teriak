import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:teriak/core/errors/exceptions.dart';
import 'package:teriak/core/errors/failure.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/customer_managment/data/datasources/customer_remote_data_source.dart';
import 'package:teriak/features/customer_managment/data/datasources/customer_local_data_source.dart';
import 'package:teriak/features/customer_managment/domain/entities/customer_debts_entity.dart';
import 'package:teriak/features/customer_managment/domain/entities/customer_entity.dart';
import 'package:teriak/features/customer_managment/domain/repositories/customer_repository.dart';

import '../../domain/entities/payment_entity.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerRemoteDataSource remoteDataSource;
  final CustomerLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  CustomerRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<CustomerEntity>>> getCustomers() async {
    try {
      // Return cached data immediately if available (fast response)
      final cachedCustomers = localDataSource.getCachedCustomers();
      if (cachedCustomers.isNotEmpty) {
        print('📦 Returning ${cachedCustomers.length} cached customers');

        // Update cache in background when online (non-blocking)
        final isConnected = await networkInfo.isConnected;
        if (isConnected) {
          remoteDataSource.getAllCustomers().then((remoteCustomers) {
            localDataSource.cacheCustomers(remoteCustomers);
            print('🔄 Updated cached customers in background');
          }).catchError((e) {
            // Silently fail background update, we already have cached data
            print('⚠️ Background customer update failed: $e');
          });
        }

        return Right(cachedCustomers);
      }

      // No cache available, fetch from remote
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        return Left(Failure(
          errMessage:
              'No cached customer data available. Please connect to internet to load customers first.'
                  .tr,
        ));
      }

      final result = await remoteDataSource.getAllCustomers();

      // Cache the fetched customers
      await localDataSource.cacheCustomers(result);
      print('✅ Fetched and cached ${result.length} customers');

      // CustomerModel extends CustomerEntity, so we can return it directly
      return Right(result.map((e) => e as CustomerEntity).toList());
    } on ServerException catch (e) {
      // If remote fails, try to return cached data as fallback
      final cachedCustomers = localDataSource.getCachedCustomers();
      if (cachedCustomers.isNotEmpty) {
        print('⚠️ Remote fetch failed, returning cached customers as fallback');
        return Right(cachedCustomers);
      }

      return Left(Failure(
        errMessage: e.toString(),
        statusCode: e.errorModel.status,
      ));
    } catch (e) {
      // If any other error, try to return cached data as fallback
      final cachedCustomers = localDataSource.getCachedCustomers();
      if (cachedCustomers.isNotEmpty) {
        print('⚠️ Error occurred, returning cached customers as fallback');
        return Right(cachedCustomers);
      }

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
      final isConnected = await networkInfo.isConnected;

      if (!isConnected) {
        // Search in cache when offline
        final cachedResults =
            localDataSource.searchCachedCustomers(params.name);
        if (cachedResults.isNotEmpty) {
          print(
              '📦 Returning ${cachedResults.length} cached search results for: "${params.name}"');
          return Right(cachedResults);
        } else {
          return Left(Failure(
            errMessage:
                'No cached customers found. Please connect to internet to search.'
                    .tr,
          ));
        }
      }

      // Online: search from remote
      final remoteSearchCustomer =
          await remoteDataSource.searchCustomer(params);

      // CustomerModel extends CustomerEntity, so we can return it directly
      return Right(
          remoteSearchCustomer.map((e) => e as CustomerEntity).toList());
    } on ServerException catch (e) {
      // If remote fails, try to search in cache as fallback
      final cachedResults = localDataSource.searchCachedCustomers(params.name);
      if (cachedResults.isNotEmpty) {
        print(
            '⚠️ Remote search failed, returning cached search results as fallback');
        return Right(cachedResults);
      }

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
