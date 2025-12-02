import 'package:dartz/dartz.dart';
import 'package:teriak/features/money_box/data/datasources/get_money_box_remote_data_source.dart';
import 'package:teriak/features/money_box/data/datasources/money_box_local_data_source.dart';
import 'package:teriak/features/money_box/domain/entities/money_box_entity.dart';
import 'package:teriak/features/money_box/domain/repositories/get_money_box_repository.dart';

import '../../../../../core/connection/network_info.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failure.dart';

class MoneyBoxRepositoryImpl extends MoneyBoxRepository {
  final NetworkInfo networkInfo;
  final MoneyBoxRemoteDataSource remoteDataSource;
  final MoneyBoxLocalDataSource localDataSource;

  MoneyBoxRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, MoneyBoxEntity>> getMoneyBox() async {
    try {
      // Try to return cached data immediately if available (fast response)
      final cachedMoneyBox = localDataSource.getCachedMoneyBox();

      if (cachedMoneyBox != null) {
        print('📦 Returning cached money box: ID ${cachedMoneyBox.id}');

        // Update cache in background when online (non-blocking)
        final isConnected = await networkInfo.isConnected;
        if (isConnected) {
          remoteDataSource.getMoneyBox().then((remoteData) async {
            await localDataSource.cacheMoneyBox(remoteData);
            print('🔄 Updated cached money box in background');
          }).catchError((e) {
            // Silently fail background update, we already have cached data
            print('⚠️ Background money box update failed: $e');
          });
        }

        return Right(cachedMoneyBox);
      }

      // No cache available, fetch from remote
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        return Left(Failure(
          errMessage:
              'No cached money box data available. Please connect to internet to load money box first.',
        ));
      }

      final remoteMoneyBox = await remoteDataSource.getMoneyBox();

      // Cache the fetched money box
      await localDataSource.cacheMoneyBox(remoteMoneyBox);
      print('✅ Fetched and cached money box: ID ${remoteMoneyBox.id}');

      return Right(remoteMoneyBox);
    } on UnauthorizedException catch (e) {
      // Specific handling for 401
      final cachedMoneyBox = localDataSource.getCachedMoneyBox();
      if (cachedMoneyBox != null) {
        print('⚠️ Unauthorized, returning cached money box as fallback');
        return Right(cachedMoneyBox);
      }
      return Left(Failure(
        errMessage: e.errorModel.errorMessage,
        statusCode: e.errorModel.status,
      ));
    } on ServerException catch (e) {
      // If remote fails, try to return cached data as fallback
      final cachedMoneyBox = localDataSource.getCachedMoneyBox();
      if (cachedMoneyBox != null) {
        print('⚠️ Remote fetch failed, returning cached money box as fallback');
        return Right(cachedMoneyBox);
      }

      return Left(Failure(
        errMessage: e.errorModel.errorMessage,
        statusCode: e.errorModel.status,
      ));
    } catch (e) {
      // If any other error, try to return cached data as fallback
      final cachedMoneyBox = localDataSource.getCachedMoneyBox();
      if (cachedMoneyBox != null) {
        print('⚠️ Error occurred, returning cached money box as fallback');
        return Right(cachedMoneyBox);
      }

      return Left(Failure(errMessage: e.toString()));
    }
  }
}
