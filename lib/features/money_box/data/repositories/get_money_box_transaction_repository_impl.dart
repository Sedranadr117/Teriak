import 'package:dartz/dartz.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/money_box/data/datasources/money_box_transaction_local_data_source.dart';
import 'package:teriak/features/money_box/data/models/money_box_transaction_model.dart';

import '../../../../../core/connection/network_info.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failure.dart';
import '../../domain/repositories/get_money_box_transaction_repository.dart';
import '../datasources/get_money_box_transaction_remote_data_source.dart';

class MoneyBoxTransactionRepositoryImpl extends MoneyBoxTransactionRepository {
  final NetworkInfo networkInfo;
  final MoneyBoxTransactionRemoteDataSource remoteDataSource;
  final MoneyBoxTransactionLocalDataSource localDataSource;

  MoneyBoxTransactionRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, MoneyBoxTransactionPaginatedModel>> getMoneyBoxTransactions(
      {required GetMoneyBoxTransactionParams params}) async {
    try {
      // Try to return cached data immediately if available (fast response)
      final cachedTransactions =
          localDataSource.getCachedMoneyBoxTransactions(params);

      if (cachedTransactions != null) {
        print(
            '📦 Returning cached money box transactions: ${cachedTransactions.content.length} items (page ${params.page})');

        // Update cache in background when online (non-blocking)
        final isConnected = await networkInfo.isConnected;
        if (isConnected) {
          remoteDataSource
              .getMoneyBoxTransaction(params)
              .then((remoteData) async {
            await localDataSource.cacheMoneyBoxTransactions(remoteData, params);
            print('🔄 Updated cached money box transactions in background');
          }).catchError((e) {
            // Silently fail background update, we already have cached data
            print('⚠️ Background money box transactions update failed: $e');
          });
        }

        // Convert to model for return
        return Right(MoneyBoxTransactionPaginatedModel(
          content: cachedTransactions.content
              .map((e) => e as MoneyBoxTransactionModel)
              .toList(),
          page: cachedTransactions.page,
          size: cachedTransactions.size,
          totalElements: cachedTransactions.totalElements,
          totalPages: cachedTransactions.totalPages,
          hasNext: cachedTransactions.hasNext,
          hasPrevious: cachedTransactions.hasPrevious,
        ));
      }

      // No cache available, fetch from remote
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        return Left(Failure(
          errMessage:
              'No cached money box transactions data available. Please connect to internet to load transactions first.',
        ));
      }

      final remoteTransactions =
          await remoteDataSource.getMoneyBoxTransaction(params);

      // Cache the fetched transactions
      await localDataSource.cacheMoneyBoxTransactions(remoteTransactions, params);
      print(
          '✅ Fetched and cached money box transactions: ${remoteTransactions.content.length} items (page ${params.page})');

      return Right(remoteTransactions);
    } on UnauthorizedException catch (e) {
      // Specific handling for 401
      final cachedTransactions =
          localDataSource.getCachedMoneyBoxTransactions(params);
      if (cachedTransactions != null) {
        print(
            '⚠️ Unauthorized, returning cached money box transactions as fallback');
        return Right(MoneyBoxTransactionPaginatedModel(
          content: cachedTransactions.content
              .map((e) => e as MoneyBoxTransactionModel)
              .toList(),
          page: cachedTransactions.page,
          size: cachedTransactions.size,
          totalElements: cachedTransactions.totalElements,
          totalPages: cachedTransactions.totalPages,
          hasNext: cachedTransactions.hasNext,
          hasPrevious: cachedTransactions.hasPrevious,
        ));
      }
      return Left(Failure(
        errMessage: e.errorModel.errorMessage,
        statusCode: e.errorModel.status,
      ));
    } on ServerException catch (e) {
      // If remote fails, try to return cached data as fallback
      final cachedTransactions =
          localDataSource.getCachedMoneyBoxTransactions(params);
      if (cachedTransactions != null) {
        print(
            '⚠️ Remote fetch failed, returning cached money box transactions as fallback');
        return Right(MoneyBoxTransactionPaginatedModel(
          content: cachedTransactions.content
              .map((e) => e as MoneyBoxTransactionModel)
              .toList(),
          page: cachedTransactions.page,
          size: cachedTransactions.size,
          totalElements: cachedTransactions.totalElements,
          totalPages: cachedTransactions.totalPages,
          hasNext: cachedTransactions.hasNext,
          hasPrevious: cachedTransactions.hasPrevious,
        ));
      }

      return Left(Failure(
        errMessage: e.errorModel.errorMessage,
        statusCode: e.errorModel.status,
      ));
    } catch (e) {
      // If any other error, try to return cached data as fallback
      final cachedTransactions =
          localDataSource.getCachedMoneyBoxTransactions(params);
      if (cachedTransactions != null) {
        print(
            '⚠️ Error occurred, returning cached money box transactions as fallback');
        return Right(MoneyBoxTransactionPaginatedModel(
          content: cachedTransactions.content
              .map((e) => e as MoneyBoxTransactionModel)
              .toList(),
          page: cachedTransactions.page,
          size: cachedTransactions.size,
          totalElements: cachedTransactions.totalElements,
          totalPages: cachedTransactions.totalPages,
          hasNext: cachedTransactions.hasNext,
          hasPrevious: cachedTransactions.hasPrevious,
        ));
      }

      return Left(Failure(errMessage: e.toString()));
    }
  }
}
