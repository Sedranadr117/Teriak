import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/exceptions.dart' show ServerException;
import 'package:teriak/features/products/all_products/data/datasources/product_local_data_source.dart';
import 'package:teriak/features/products/all_products/data/models/product_model.dart';
import 'package:teriak/features/products/all_products/domain/entities/paginated_products_entity.dart';
import 'package:teriak/features/products/search_product/data/datasources/search_product_remote_data_source.dart';
import 'package:teriak/features/products/search_product/domain/repositories/search_product_repository.dart';
import '../../../../../core/connection/network_info.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';

class SearchProductRepositoryImpl extends SearchProductRepository {
  final NetworkInfo networkInfo;
  final SearchProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;

  SearchProductRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, PaginatedProductsEntity>> searchProduct(
      {required SearchProductParams params}) async {
    try {
      // Always search in cached products first (works offline)
      final cachedResults = localDataSource.getCachedSearchResultsPaginated(
        keyword: params.keyword,
        page: params.page,
        size: params.size,
      );

      print(
          '🔍 Searched in cache for "${params.keyword}": Found ${cachedResults.totalElements} total results, returning ${cachedResults.content.length} for page ${params.page}');

      // Update cache in background when online (non-blocking)
      final isConnected = await networkInfo.isConnected;
      if (isConnected) {
        remoteDataSource.searchProduct(params).then((remoteResults) async {
          // Cache the fetched products to improve future searches
          final productsToCache =
              remoteResults.content.whereType<ProductModel>().toList();
          await localDataSource.cacheProducts(productsToCache);
          print('🔄 Updated cached products from remote search in background');
        }).catchError((e) {
          // Silently fail background update, we already have cached data
          print('⚠️ Background search update failed: $e');
        });
      }

      // Return cached results immediately (works offline)
      return Right(cachedResults);
    } on ServerException catch (e) {
      // If remote fails, still return cached data as fallback
      final cachedResults = localDataSource.getCachedSearchResultsPaginated(
        keyword: params.keyword,
        page: params.page,
        size: params.size,
      );
      if (cachedResults.content.isNotEmpty) {
        print('⚠️ Remote search failed, returning cached results as fallback');
        return Right(cachedResults);
      }

      return Left(Failure(
        errMessage: e.errorModel.errorMessage,
        statusCode: e.errorModel.status,
      ));
    } catch (e) {
      // If any other error, try to return cached data as fallback
      final cachedResults = localDataSource.getCachedSearchResultsPaginated(
        keyword: params.keyword,
        page: params.page,
        size: params.size,
      );
      if (cachedResults.content.isNotEmpty) {
        print('⚠️ Error occurred, returning cached search results as fallback');
        return Right(cachedResults);
      }

      return Left(Failure(errMessage: e.toString()));
    }
  }
}
