import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:teriak/core/errors/exceptions.dart';
import 'package:teriak/features/stock_management/data/datasources/Stock_remote_data_source.dart';
import 'package:teriak/features/stock_management/data/datasources/stock_local_data_source.dart';
import 'package:teriak/features/stock_management/data/models/Stock_model.dart';
import 'package:teriak/features/stock_management/domain/entities/stock_entity.dart';
import 'package:teriak/features/stock_management/domain/entities/stock_item_entity.dart'
    show StockDetailsEntity;
import '../../../../../core/connection/network_info.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';
import '../../domain/repositories/stock_repository.dart';

class StockRepositoryImpl extends StockRepository {
  final NetworkInfo networkInfo;
  final StockRemoteDataSource remoteDataSource;
  final StockLocalDataSource localDataSource;
  StockRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<StockEntity>>> getStock() async {
    // Return cached data immediately if available (fast response)
    final cachedStocks = localDataSource.getStocks();
    if (cachedStocks.isNotEmpty) {
      // Update cache in background when online (non-blocking)
      final isConnected = await networkInfo.isConnected;
      if (isConnected) {
        remoteDataSource.getStock().then((remoteStock) {
          localDataSource.cacheStocks(remoteStock);
        }).catchError((e) {
          // Silently fail background update, we already have cached data
          print('Background stock update failed: $e');
        });
      }
      return Right(cachedStocks);
    }

    // No cache available, fetch from remote
    final isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        final remoteStock = await remoteDataSource.getStock();
        await localDataSource.cacheStocks(remoteStock);

        // Note: Arabic names will be cached when user searches with Arabic language
        // This happens in the searchStock method when lang='ar'

        return Right(remoteStock);
      } on ServerException catch (e) {
        return Left(Failure(
          errMessage: e.toString(),
          statusCode: e.errorModel.status,
        ));
      }
    } else {
      return Left(
        Failure(
          errMessage: 'No cached stock data available for offline use.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<StockEntity>>> searchStock(
      {required SearchStockParams params}) async {
    // Always search cached data first for fast results (works online and offline)
    final cachedResults = localDataSource.searchStocks(params.keyword);
    final allCachedStocks = localDataSource.getStocks();
    final isConnected = await networkInfo.isConnected;

    print('🔍 Searching for: "${params.keyword}"');
    print('📦 Cache has ${allCachedStocks.length} total items');
    print('✅ Found ${cachedResults.length} matching items in cache');

    // When online, always check remote to get Arabic names and cache them
    if (isConnected) {
      try {
        final remoteResults = await remoteDataSource.searchStock(params);

        // Cache search results (will merge Arabic names for existing items)
        if (remoteResults.isNotEmpty) {
          final stockModels = remoteResults
              .map((entity) => StockModel.fromEntity(entity))
              .toList();
          try {
            await localDataSource.mergeSearchResults(
              stockModels,
              isArabicSearch: params.lang == 'ar',
            );
            print(
                '✅ Cached ${stockModels.length} search results for offline use');
          } catch (e) {
            print('⚠️ Failed to cache search results: $e');
          }
        }

        // Return remote results when online (they have correct language)
        return Right(remoteResults);
      } on ServerException catch (e) {
        // If remote fails, fall back to cached results
        print('Remote search failed, using cache: $e');
        if (cachedResults.isNotEmpty) {
          return Right(cachedResults);
        }
      }
    }

    // When offline, use cached results
    if (cachedResults.isNotEmpty) {
      return Right(cachedResults);
    }

    // If cache is empty and we're online, fetch and cache all stock first
    if (allCachedStocks.isEmpty && isConnected) {
      try {
        print('📥 Cache is empty, fetching all stock...');
        // Fetch all stock to populate cache
        final remoteStock = await remoteDataSource.getStock();
        await localDataSource.cacheStocks(remoteStock);
        print('✅ Cached ${remoteStock.length} items');

        // Now search the freshly cached data
        final searchResults = localDataSource.searchStocks(params.keyword);
        print('🔍 Found ${searchResults.length} items after caching');
        return Right(searchResults);
      } on ServerException catch (e) {
        return Left(Failure(
          errMessage: e.toString(),
          statusCode: e.errorModel.status,
        ));
      }
    }

    // If cache has data but search returned empty
    if (allCachedStocks.isEmpty) {
      return Left(
        Failure(
          errMessage:
              'No cached stock data available. Please connect to internet to load stock data first.',
        ),
      );
    }

    // Cache has data but no matches found
    print(
        '⚠️ Cache has ${allCachedStocks.length} items but no matches for "${params.keyword}"');
    if (allCachedStocks.isNotEmpty) {
      print(
          '📝 Sample cached names: ${allCachedStocks.take(3).map((s) => s.productName).join(", ")}');
      print(
          '💡 Cache might have English names only. Go online and load full stock list to refresh cache with all items.');
    }
    return Right([]);
  }

  @override
  Future<Either<Failure, StockEntity>> editStock(
      {required int stockItemeId, required StockParams params}) async {
    try {
      final updatedStock =
          await remoteDataSource.editStock(stockItemeId, params);
      return Right(updatedStock);
    } on ServerException catch (e) {
      return Left(
        Failure(
          errMessage: e.toString(),
          statusCode: e.errorModel.status,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteStock(int id) async {
    try {
      await remoteDataSource.deleteStock(id);

      return const Right(null);
    } on ServerException catch (e) {
      return Left(
        Failure(
          errMessage: e.toString(),
          statusCode: e.errorModel.status,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, StockDetailsEntity>> getDetailsStock(
      {required int productId, required String productType}) async {
    try {
      // Check cache first
      final cachedDetails =
          localDataSource.getCachedStockDetails(productId, productType);
      if (cachedDetails != null) {
        print(
            '📦 Returning cached stock details for productId: $productId, productType: $productType');

        // Update cache in background when online (non-blocking)
        final isConnected = await networkInfo.isConnected;
        if (isConnected) {
          remoteDataSource
              .getDetailsStock(
            productId: productId,
            productType: productType,
          )
              .then((remoteDetails) {
            // Cache the updated details
            localDataSource.cacheStockDetails(
                remoteDetails, productId, productType);
            print(
                '🔄 Updated cached stock details in background for productId: $productId');
          }).catchError((e) {
            // Silently fail background update, we already have cached data
            print('⚠️ Background stock details update failed: $e');
          });
        }

        return Right(cachedDetails);
      }

      // No cache available, fetch from remote
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        return Left(Failure(
          errMessage:
              'No cached stock details available. Please connect to internet to load stock details first.'
                  .tr,
        ));
      }

      final details = await remoteDataSource.getDetailsStock(
        productId: productId,
        productType: productType,
      );

      // Cache the fetched details
      await localDataSource.cacheStockDetails(details, productId, productType);
      print(
          '✅ Fetched and cached stock details for productId: $productId, productType: $productType');

      return Right(details.toEntity());
    } on ServerException catch (e) {
      // If remote fails, try to return cached data as fallback
      final cachedDetails =
          localDataSource.getCachedStockDetails(productId, productType);
      if (cachedDetails != null) {
        print(
            '⚠️ Remote fetch failed, returning cached stock details as fallback');
        return Right(cachedDetails);
      }

      return Left(Failure(
        errMessage: e.toString(),
        statusCode: e.errorModel.status,
      ));
    }
  }
}
