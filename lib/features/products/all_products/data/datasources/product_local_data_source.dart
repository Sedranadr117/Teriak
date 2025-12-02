import 'package:hive/hive.dart';
import 'package:teriak/features/products/all_products/data/models/hive_product_model.dart';
import 'package:teriak/features/products/all_products/data/models/product_model.dart';
import 'package:teriak/features/products/all_products/domain/entities/paginated_products_entity.dart';
import 'package:teriak/features/products/all_products/domain/entities/product_entity.dart';

abstract class ProductLocalDataSource {
  Future<void> cacheProducts(List<ProductModel> products);
  Future<void> cacheProduct(ProductModel product);
  Future<void> deleteCachedProduct(int id, String productType);
  Future<void> clearDuplicateProducts();
  List<ProductEntity> getCachedProducts();
  List<ProductEntity> searchCachedProducts(String keyword);
  PaginatedProductsEntity getCachedProductsPaginated({
    required int page,
    required int size,
  });
  PaginatedProductsEntity getCachedSearchResultsPaginated({
    required String keyword,
    required int page,
    required int size,
  });
  ProductEntity? getCachedProductById(int id, String productType);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final Box<HiveProductModel> productBox;

  ProductLocalDataSourceImpl({required this.productBox});

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    // Don't clear the box, just update/add products
    // This allows incremental caching for pagination
    // Deduplicate products by cache key AND barcode before caching
    final seenCacheKeys = <String>{};
    final seenBarcodes = <String>{};
    int cachedCount = 0;
    int updatedCount = 0;

    for (final product in products) {
      final hiveProduct = HiveProductModel.fromProductModel(product);
      final cacheKey = hiveProduct.cacheKey;
      final barcodeKey = hiveProduct.barcodeKey;
      final barcode = product.barcode.trim(); // Trim whitespace

      // Check if this product already exists in cache by cache key
      final existingByCacheKey = productBox.get(cacheKey);

      // Check if duplicate by cache key in this batch
      final isDuplicateByCacheKeyInBatch = seenCacheKeys.contains(cacheKey);

      // Check if duplicate by barcode in this batch (only for non-empty barcodes)
      // IMPORTANT: Only check barcode duplicates if barcode is actually not empty
      // Empty or whitespace-only barcodes should NOT be used for deduplication
      final isDuplicateByBarcodeInBatch = barcode.isNotEmpty &&
          barcodeKey.isNotEmpty &&
          seenBarcodes.contains(barcodeKey);

      // Check if duplicate by barcode in cache (only for non-empty barcodes)
      bool isDuplicateByBarcodeInCache = false;
      if (barcode.isNotEmpty) {
        // Check if any product in cache has this barcode
        for (final cachedProduct in productBox.values) {
          if (cachedProduct.barcode.trim() == barcode &&
              cachedProduct.cacheKey != cacheKey) {
            isDuplicateByBarcodeInCache = true;
            print(
                '⚠️ Product with barcode "$barcode" already exists in cache (ID=${cachedProduct.id}), updating existing entry');
            break;
          }
        }
      }

      // If it exists in cache by cache key, update it
      if (existingByCacheKey != null) {
        await productBox.put(cacheKey, hiveProduct);
        updatedCount++;
        seenCacheKeys.add(cacheKey);
        if (barcodeKey.isNotEmpty) {
          seenBarcodes.add(barcodeKey);
        }
        print(
            '🔄 Updated existing cached product: ${product.tradeName} (ID: ${product.id})');
      }
      // If it's a duplicate in this batch, skip it
      else if (isDuplicateByCacheKeyInBatch || isDuplicateByBarcodeInBatch) {
        if (isDuplicateByCacheKeyInBatch) {
          print(
              '⚠️ Skipping duplicate by cache key in batch: ID=${product.id}, Type=${product.productType}, TradeName=${product.tradeName}');
        }
        if (isDuplicateByBarcodeInBatch) {
          print(
              '⚠️ Skipping duplicate by barcode in batch: Barcode=$barcode, ID=${product.id}, TradeName=${product.tradeName}');
        }
      }
      // If it's a duplicate by barcode in cache, update the existing one
      else if (isDuplicateByBarcodeInCache) {
        // Find and update the existing product with this barcode
        for (final key in productBox.keys) {
          final cachedProduct = productBox.get(key);
          if (cachedProduct != null &&
              cachedProduct.barcode.trim() == barcode &&
              cachedProduct.cacheKey != cacheKey) {
            await productBox.put(cachedProduct.cacheKey, hiveProduct);
            updatedCount++;
            print(
                '🔄 Updated cached product by barcode: ${product.tradeName} (ID: ${product.id}, Old ID: ${cachedProduct.id})');
            break;
          }
        }
        seenCacheKeys.add(cacheKey);
        if (barcodeKey.isNotEmpty) {
          seenBarcodes.add(barcodeKey);
        }
      }
      // New product, cache it
      else {
        await productBox.put(cacheKey, hiveProduct);
        cachedCount++;
        seenCacheKeys.add(cacheKey);
        if (barcodeKey.isNotEmpty) {
          seenBarcodes.add(barcodeKey);
        }
        print('✅ Cached new product: ${product.tradeName} (ID: ${product.id})');
      }
    }

    print(
        '✅ Cached $cachedCount new products, updated $updatedCount existing products (${products.length - cachedCount - updatedCount} duplicates skipped)');
  }

  @override
  Future<void> cacheProduct(ProductModel product) async {
    final hiveProduct = HiveProductModel.fromProductModel(product);
    final key = hiveProduct.cacheKey;

    // Check if product already exists with this key
    final existing = productBox.get(key);
    if (existing != null) {
      print(
          '⚠️ Product already cached with key $key (ID: ${product.id}, Type: ${product.productType}), updating...');
    }

    await productBox.put(key, hiveProduct);
    print(
        '✅ Cached product: ${product.tradeName} (ID: ${product.id}, Type: ${product.productType}, Key: $key)');
  }

  @override
  Future<void> deleteCachedProduct(int id, String productType) async {
    // Normalize productType to match cache key generation
    final normalized = productType.toLowerCase().trim();
    final normalizedType = (normalized == 'صيدلية' || normalized == 'pharmacy')
        ? 'pharmacy'
        : (normalized == 'مركزي' || normalized == 'master')
            ? 'master'
            : normalized;
    final key = '${id}_$normalizedType';

    // Also try to delete by barcode if we can find the product
    final product = productBox.get(key);
    if (product != null && product.barcode.isNotEmpty) {
      // Delete all products with the same barcode
      for (final boxKey in productBox.keys) {
        final p = productBox.get(boxKey);
        if (p != null && p.barcode == product.barcode) {
          await productBox.delete(boxKey);
          print(
              '🗑️ Deleted cached product by barcode: Barcode=${p.barcode}, Key=$boxKey');
        }
      }
    } else {
      await productBox.delete(key);
    }
    print(
        '🗑️ Deleted cached product (ID: $id, Type: $productType, Normalized: $normalizedType, Key: $key)');
  }

  @override
  Future<void> clearDuplicateProducts() async {
    // Get all products and deduplicate them by cache key (id_productType) and barcode
    // Use maps to track which key to keep for each cache key/barcode
    final keysToKeep = <dynamic>[];
    final keysToDelete = <dynamic>[];
    final cacheKeyToKeep = <String, dynamic>{};

    print(
        '🔍 Starting duplicate cleanup. Total products in cache: ${productBox.length}');

    // First, collect all products and their keys
    final allProducts = <dynamic, HiveProductModel>{};
    for (final key in productBox.keys) {
      final hiveProduct = productBox.get(key);
      if (hiveProduct != null) {
        allProducts[key] = hiveProduct;
      }
    }

    print('📦 Found ${allProducts.length} products to check for duplicates');

    // Deduplicate by cache key first (id + normalized productType)
    for (final entry in allProducts.entries) {
      final key = entry.key;
      final hiveProduct = entry.value;
      final cacheKey = hiveProduct.cacheKey;

      if (!cacheKeyToKeep.containsKey(cacheKey)) {
        // First occurrence of this cache key - keep it
        cacheKeyToKeep[cacheKey] = key;
        keysToKeep.add(key);
      } else {
        // Duplicate by cache key - compare to see which one to keep
        final existingKey = cacheKeyToKeep[cacheKey];
        final existingProduct = allProducts[existingKey];

        if (existingProduct != null) {
          // Keep the one with more complete data (non-empty barcode, or newer)
          // For now, just keep the first one we encountered
          keysToDelete.add(key);
          print(
              '⚠️ Found duplicate by cache key: Key=$key, CacheKey=$cacheKey, ID=${hiveProduct.id}, Type=${hiveProduct.productType}, TradeName=${hiveProduct.tradeName}');
        }
      }
    }

    // Then deduplicate by barcode (only for products with barcodes)
    final barcodeProducts = <String, List<dynamic>>{};
    for (final entry in allProducts.entries) {
      final key = entry.key;
      final hiveProduct = entry.value;
      final barcodeKey = hiveProduct.barcodeKey;

      if (barcodeKey.isNotEmpty) {
        if (!barcodeProducts.containsKey(barcodeKey)) {
          barcodeProducts[barcodeKey] = [];
        }
        barcodeProducts[barcodeKey]!.add(key);
      }
    }

    // For each barcode group, keep only one
    for (final entry in barcodeProducts.entries) {
      final keysWithBarcode = entry.value;

      if (keysWithBarcode.length > 1) {
        // Find which key is already being kept
        dynamic keepKey;
        for (final key in keysWithBarcode) {
          if (keysToKeep.contains(key)) {
            keepKey = key;
            break;
          }
        }

        // If none is being kept, keep the first one
        if (keepKey == null) {
          keepKey = keysWithBarcode.first;
          if (!keysToKeep.contains(keepKey)) {
            keysToKeep.add(keepKey);
          }
        }

        // Mark others for deletion
        for (final key in keysWithBarcode) {
          if (key != keepKey && !keysToDelete.contains(key)) {
            keysToDelete.add(key);
            final product = allProducts[key];
            print(
                '⚠️ Found duplicate by barcode: Key=$key, Barcode=${product?.barcode}, ID=${product?.id}, TradeName=${product?.tradeName}');
          }
        }
      }
    }

    // Delete duplicates
    for (final key in keysToDelete) {
      await productBox.delete(key);
    }

    if (keysToDelete.isNotEmpty) {
      print(
          '🧹 Cleaned up ${keysToDelete.length} duplicate product(s) from cache');
      print(
          '📊 Cache now contains ${keysToKeep.length} unique products (was ${productBox.length})');
    } else {
      print(
          '✅ No duplicates found. Cache contains ${productBox.length} products');
    }
  }

  @override
  List<ProductEntity> getCachedProducts() {
    // Deduplicate products by id and productType
    final seenKeys = <String>{};
    final products = <ProductEntity>[];

    print('🔍 Getting cached products. Total in box: ${productBox.length}');

    for (final hiveProduct in productBox.values) {
      final key = hiveProduct.cacheKey;
      if (!seenKeys.contains(key)) {
        products.add(hiveProduct.toEntity());
        seenKeys.add(key);
      } else {
        print(
            '⚠️ Skipping duplicate in getCachedProducts: Key=$key, ID=${hiveProduct.id}, Type=${hiveProduct.productType}');
      }
    }

    print(
        '✅ Returning ${products.length} unique cached products (deduplicated from ${productBox.length} in box)');
    return products;
  }

  @override
  List<ProductEntity> searchCachedProducts(String keyword) {
    final query = keyword.trim().toLowerCase();

    if (query.isEmpty) {
      return getCachedProducts();
    }

    // Use deduplicated products for search
    final allProducts = getCachedProducts();
    print(
        '🔍 Searching in ${allProducts.length} cached products for: "$keyword"');

    final results = allProducts.where((product) {
      final tradeNameMatch = product.tradeName.toLowerCase().contains(query);
      final scientificNameMatch =
          product.scientificName.toLowerCase().contains(query);
      final barcodeMatch = product.barcode.toLowerCase().contains(query);
      final manufacturerMatch =
          product.manufacturer?.toLowerCase().contains(query) ?? false;

      return tradeNameMatch ||
          scientificNameMatch ||
          barcodeMatch ||
          manufacturerMatch;
    }).toList();

    return results;
  }

  @override
  PaginatedProductsEntity getCachedProductsPaginated({
    required int page,
    required int size,
  }) {
    final allProducts = getCachedProducts();
    final totalElements = allProducts.length;
    final totalPages = totalElements > 0 ? (totalElements / size).ceil() : 0;
    final startIndex = page * size;
    final endIndex = (startIndex + size).clamp(0, totalElements);

    print(
        '📦 Cache pagination: Total=${totalElements}, Page=${page}, Size=${size}, Start=${startIndex}, End=${endIndex}');

    // Handle empty cache
    if (totalElements == 0) {
      return PaginatedProductsEntity(
        content: [],
        page: page,
        size: size,
        totalElements: 0,
        totalPages: 0,
        hasNext: false,
        hasPrevious: false,
      );
    }

    // Handle out of bounds
    if (startIndex >= totalElements) {
      return PaginatedProductsEntity(
        content: [],
        page: page,
        size: size,
        totalElements: totalElements,
        totalPages: totalPages,
        hasNext: false,
        hasPrevious: page > 0,
      );
    }

    final paginatedProducts = allProducts.sublist(
      startIndex.clamp(0, totalElements),
      endIndex,
    );

    print(
        '📦 Returning ${paginatedProducts.length} cached products for page ${page} (out of ${totalElements} total)');

    return PaginatedProductsEntity(
      content: paginatedProducts,
      page: page,
      size: size,
      totalElements: totalElements,
      totalPages: totalPages,
      hasNext: page < totalPages - 1,
      hasPrevious: page > 0,
    );
  }

  @override
  PaginatedProductsEntity getCachedSearchResultsPaginated({
    required String keyword,
    required int page,
    required int size,
  }) {
    final searchResults = searchCachedProducts(keyword);
    final totalElements = searchResults.length;
    final totalPages = (totalElements / size).ceil();
    final startIndex = page * size;
    final endIndex = (startIndex + size).clamp(0, totalElements);

    final paginatedResults = searchResults.sublist(
      startIndex.clamp(0, totalElements),
      endIndex,
    );

    return PaginatedProductsEntity(
      content: paginatedResults,
      page: page,
      size: size,
      totalElements: totalElements,
      totalPages: totalPages,
      hasNext: page < totalPages - 1,
      hasPrevious: page > 0,
    );
  }

  @override
  ProductEntity? getCachedProductById(int id, String productType) {
    final key = '${id}_$productType';
    final cachedProduct = productBox.get(key);
    return cachedProduct?.toEntity();
  }
}
