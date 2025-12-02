import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:teriak/features/stock_management/data/models/Stock_model.dart';
import 'package:teriak/features/stock_management/data/models/hive_stock_model.dart';
import 'package:teriak/features/stock_management/data/models/stock_item_model.dart';
import 'package:teriak/features/stock_management/domain/entities/stock_entity.dart';
import 'package:teriak/features/stock_management/domain/entities/stock_item_entity.dart';

abstract class StockLocalDataSource {
  Future<void> cacheStocks(List<StockModel> stocks);
  Future<void> updateArabicNames(Map<int, String> productIdToArabicName);
  Future<void> mergeSearchResults(List<StockModel> searchResults,
      {bool isArabicSearch = false});
  Future<void> reduceStockQuantities(Map<int, int> stockIdToQuantity);
  List<StockEntity> getStocks();
  List<StockEntity> searchStocks(String keyword);

  // Stock details caching
  Future<void> cacheStockDetails(
      StockDetailsModel details, int productId, String productType);
  StockDetailsEntity? getCachedStockDetails(int productId, String productType);
}

class StockLocalDataSourceImpl implements StockLocalDataSource {
  final Box<HiveStockModel> stockBox;
  final Box<String> stockDetailsBox;

  StockLocalDataSourceImpl({
    required this.stockBox,
    Box<String>? stockDetailsBox,
  }) : stockDetailsBox =
            stockDetailsBox ?? Hive.box<String>('stockDetailsCache');

  @override
  Future<void> cacheStocks(List<StockModel> stocks) async {
    await stockBox.clear();

    // Use put with stock ID as key (not addAll which uses auto-generated keys)
    for (final stock in stocks) {
      final hiveStock = HiveStockModel.fromStockModel(stock);
      await stockBox.put(stock.id, hiveStock);
    }

    print('✅ Cached ${stocks.length} stock items with IDs as keys');
  }

  @override
  Future<void> updateArabicNames(Map<int, String> productIdToArabicName) async {
    for (final entry in productIdToArabicName.entries) {
      final matchingStocks = stockBox.values
          .where(
            (s) => s.productId == entry.key,
          )
          .toList();

      for (final stock in matchingStocks) {
        // Create new HiveStockModel with Arabic name
        final updated = HiveStockModel(
          id: stock.id,
          productId: stock.productId,
          productName: stock.productName,
          productNameAr: entry.value,
          productType: stock.productType,
          barcodes: stock.barcodes,
          totalQuantity: stock.totalQuantity,
          totalBonusQuantity: stock.totalBonusQuantity,
          actualPurchasePrice: stock.actualPurchasePrice,
          totalValue: stock.totalValue,
          categories: stock.categories,
          sellingPrice: stock.sellingPrice,
          minStockLevel: stock.minStockLevel,
          hasExpiredItems: stock.hasExpiredItems,
          hasExpiringSoonItems: stock.hasExpiringSoonItems,
          earliestExpiryDate: stock.earliestExpiryDate,
          latestExpiryDate: stock.latestExpiryDate,
          numberOfBatches: stock.numberOfBatches,
          pharmacyId: stock.pharmacyId,
          dualCurrencyDisplay: stock.dualCurrencyDisplay,
          actualPurchasePriceUSD: stock.actualPurchasePriceUSD,
          totalValueUSD: stock.totalValueUSD,
          sellingPriceUSD: stock.sellingPriceUSD,
          exchangeRateSYPToUSD: stock.exchangeRateSYPToUSD,
          conversionTimestampSYPToUSD: stock.conversionTimestampSYPToUSD,
          rateSource: stock.rateSource,
        );
        await stockBox.put(stock.id, updated);
      }
    }
    print('✅ Updated ${productIdToArabicName.length} items with Arabic names');
  }

  @override
  Future<void> mergeSearchResults(List<StockModel> searchResults,
      {bool isArabicSearch = false}) async {
    for (final stockModel in searchResults) {
      // Find existing item in cache by productId or id
      HiveStockModel? existingStock;
      try {
        existingStock = stockBox.values.firstWhere(
          (s) => s.productId == stockModel.productId,
        );
      } catch (e) {
        // Not found by productId, try by id
        try {
          existingStock = stockBox.get(stockModel.id);
        } catch (e2) {
          // Item doesn't exist in cache
          existingStock = null;
        }
      }

      if (isArabicSearch) {
        // When searching with Arabic, productName contains Arabic
        // Update productNameAr with Arabic name, keep English name in productName
        if (existingStock == null) {
          // Item doesn't exist, add it with Arabic name
          final hiveStock = HiveStockModel(
            id: stockModel.id,
            productId: stockModel.productId,
            productName:
                stockModel.productName, // This is Arabic when lang='ar'
            productNameAr: stockModel.productName, // Store Arabic name
            productType: stockModel.productType,
            barcodes: stockModel.barcodes,
            totalQuantity: stockModel.totalQuantity,
            totalBonusQuantity: stockModel.totalBonusQuantity,
            actualPurchasePrice: stockModel.actualPurchasePrice,
            totalValue: stockModel.totalValue,
            categories: stockModel.categories,
            sellingPrice: stockModel.sellingPrice,
            minStockLevel: stockModel.minStockLevel,
            hasExpiredItems: stockModel.hasExpiredItems,
            hasExpiringSoonItems: stockModel.hasExpiringSoonItems,
            earliestExpiryDate: stockModel.earliestExpiryDate,
            latestExpiryDate: stockModel.latestExpiryDate,
            numberOfBatches: stockModel.numberOfBatches,
            pharmacyId: stockModel.pharmacyId,
            dualCurrencyDisplay: stockModel.dualCurrencyDisplay,
            actualPurchasePriceUSD: stockModel.actualPurchasePriceUSD,
            totalValueUSD: stockModel.totalValueUSD,
            sellingPriceUSD: stockModel.sellingPriceUSD,
            exchangeRateSYPToUSD: stockModel.exchangeRateSYPToUSD,
            conversionTimestampSYPToUSD: stockModel.conversionTimestampSYPToUSD,
            rateSource: stockModel.rateSource,
          );
          await stockBox.put(stockModel.id, hiveStock);
        } else {
          // Item exists, update only productNameAr
          final updated = HiveStockModel(
            id: existingStock.id,
            productId: existingStock.productId,
            productName: existingStock.productName, // Keep English name
            productNameAr: stockModel.productName, // Update with Arabic name
            productType: existingStock.productType,
            barcodes: existingStock.barcodes,
            totalQuantity: existingStock.totalQuantity,
            totalBonusQuantity: existingStock.totalBonusQuantity,
            actualPurchasePrice: existingStock.actualPurchasePrice,
            totalValue: existingStock.totalValue,
            categories: existingStock.categories,
            sellingPrice: existingStock.sellingPrice,
            minStockLevel: existingStock.minStockLevel,
            hasExpiredItems: existingStock.hasExpiredItems,
            hasExpiringSoonItems: existingStock.hasExpiringSoonItems,
            earliestExpiryDate: existingStock.earliestExpiryDate,
            latestExpiryDate: existingStock.latestExpiryDate,
            numberOfBatches: existingStock.numberOfBatches,
            pharmacyId: existingStock.pharmacyId,
            dualCurrencyDisplay: existingStock.dualCurrencyDisplay,
            actualPurchasePriceUSD: existingStock.actualPurchasePriceUSD,
            totalValueUSD: existingStock.totalValueUSD,
            sellingPriceUSD: existingStock.sellingPriceUSD,
            exchangeRateSYPToUSD: existingStock.exchangeRateSYPToUSD,
            conversionTimestampSYPToUSD:
                existingStock.conversionTimestampSYPToUSD,
            rateSource: existingStock.rateSource,
          );
          await stockBox.put(existingStock.id, updated);
        }
      } else {
        // When searching with English, productName contains English
        // Just add/update the item normally
        final hiveStock = HiveStockModel.fromStockModel(stockModel);
        await stockBox.put(stockModel.id, hiveStock);
      }
    }
    print('✅ Merged ${searchResults.length} search results into cache');
  }

  @override
  List<StockEntity> getStocks() {
    return stockBox.values.map((stock) => stock.toEntity()).toList();
  }

  @override
  List<StockEntity> searchStocks(String keyword) {
    final query = keyword.trim();

    if (query.isEmpty) {
      return getStocks();
    }

    // Check if query contains Arabic characters
    final hasArabic = _containsArabic(query);

    final allStocks = stockBox.values.toList();
    print('🔍 Searching in ${allStocks.length} cached items for: "$query"');
    print('🌐 Query contains Arabic: $hasArabic');

    if (allStocks.isNotEmpty) {
      print(
          '📝 Sample cached item names: ${allStocks.take(3).map((s) => s.productName).join(", ")}');
    }

    final results = allStocks
        .where((stock) {
          bool nameMatch;
          bool barcodeMatch;
          bool categoryMatch;

          if (hasArabic) {
            // For Arabic: check both English and Arabic names
            nameMatch = stock.productName.contains(query) ||
                (stock.productNameAr != null &&
                    stock.productNameAr!.contains(query));
            barcodeMatch =
                stock.barcodes.any((barcode) => barcode.contains(query));
            categoryMatch =
                stock.categories.any((category) => category.contains(query));
          } else {
            // For English: case-insensitive search in both names
            final lowerQuery = query.toLowerCase();
            nameMatch = stock.productName.toLowerCase().contains(lowerQuery) ||
                (stock.productNameAr != null &&
                    stock.productNameAr!.toLowerCase().contains(lowerQuery));
            barcodeMatch = stock.barcodes
                .any((barcode) => barcode.toLowerCase().contains(lowerQuery));
            categoryMatch = stock.categories
                .any((category) => category.toLowerCase().contains(lowerQuery));
          }

          if (nameMatch || barcodeMatch || categoryMatch) {
            print('✅ Match found: ${stock.productName}');
          }

          return nameMatch || barcodeMatch || categoryMatch;
        })
        .map((stock) => stock.toEntity())
        .toList();

    print('📊 Search results: ${results.length} items');
    return results;
  }

  @override
  Future<void> reduceStockQuantities(Map<int, int> stockIdToQuantity) async {
    // Reduce stock quantities after a sale
    // stockIdToQuantity: Map of stock ID to quantity to reduce
    for (final entry in stockIdToQuantity.entries) {
      final stockId = entry.key;
      final quantityToReduce = entry.value;

      final stock = stockBox.get(stockId);
      if (stock != null) {
        final newQuantity = (stock.totalQuantity - quantityToReduce)
            .clamp(0, double.infinity)
            .toInt();
        final updatedStock = HiveStockModel(
          id: stock.id,
          productId: stock.productId,
          productName: stock.productName,
          productNameAr: stock.productNameAr,
          productType: stock.productType,
          barcodes: stock.barcodes,
          totalQuantity: newQuantity,
          totalBonusQuantity: stock.totalBonusQuantity,
          actualPurchasePrice: stock.actualPurchasePrice,
          totalValue: stock.actualPurchasePrice * newQuantity,
          categories: stock.categories,
          sellingPrice: stock.sellingPrice,
          minStockLevel: stock.minStockLevel,
          hasExpiredItems: stock.hasExpiredItems,
          hasExpiringSoonItems: stock.hasExpiringSoonItems,
          earliestExpiryDate: stock.earliestExpiryDate,
          latestExpiryDate: stock.latestExpiryDate,
          numberOfBatches: stock.numberOfBatches,
          pharmacyId: stock.pharmacyId,
          dualCurrencyDisplay: stock.dualCurrencyDisplay,
          actualPurchasePriceUSD: stock.actualPurchasePriceUSD,
          totalValueUSD: stock.actualPurchasePriceUSD * newQuantity,
          sellingPriceUSD: stock.sellingPriceUSD,
          exchangeRateSYPToUSD: stock.exchangeRateSYPToUSD,
          conversionTimestampSYPToUSD: stock.conversionTimestampSYPToUSD,
          rateSource: stock.rateSource,
        );
        await stockBox.put(stockId, updatedStock);
        print(
            '📉 Reduced stock ${stock.productName} (ID: $stockId) by $quantityToReduce. New quantity: $newQuantity');
      } else {
        print('⚠️ Stock item with ID $stockId not found in cache');
      }
    }
    print('✅ Updated ${stockIdToQuantity.length} stock items after sale');
  }

  /// Check if text contains Arabic characters
  bool _containsArabic(String text) {
    return text.runes.any((rune) => rune >= 0x0600 && rune <= 0x06FF);
  }

  /// Generate cache key for stock details
  String _getStockDetailsKey(int productId, String productType) {
    return '${productId}_$productType';
  }

  @override
  Future<void> cacheStockDetails(
      StockDetailsModel details, int productId, String productType) async {
    try {
      // Always use productId and productType from the details model (source of truth)
      // The parameters are just for validation/logging
      final actualProductId = details.productId;
      final actualProductType = details.productType;
      final key = _getStockDetailsKey(actualProductId, actualProductType);

      // Warn if parameters don't match (but still cache with correct key)
      if (actualProductId != productId || actualProductType != productType) {
        print('⚠️ Warning: Parameter mismatch!');
        print('⚠️ Parameters: productId=$productId, productType=$productType');
        print(
            '⚠️ Details model: productId=$actualProductId, productType=$actualProductType');
        print('⚠️ Caching with details model values (source of truth)');
      }

      // Convert to JSON string for storage
      final jsonData = {
        'productId': actualProductId,
        'totalQuantity': details.totalQuantity,
        'minStockLevel': details.minStockLevel,
        'productType': actualProductType,
        'stockItems': details.stockItems.map((item) => item.toJson()).toList(),
      };

      // Double-check: Ensure the key matches the data we're storing
      final expectedKey =
          _getStockDetailsKey(actualProductId, actualProductType);
      if (key != expectedKey) {
        print(
            '❌ CRITICAL: Key mismatch! Using key: "$key" but data has productId=$actualProductId');
        print('❌ Correct key should be: "$expectedKey"');
        // Use the correct key
        final jsonString = jsonEncode(jsonData);
        await stockDetailsBox.put(expectedKey, jsonString);
        print('✅ Cached with corrected key: "$expectedKey"');
        return;
      }

      // Convert to JSON string
      final jsonString = jsonEncode(jsonData);
      print(
          '🔑 Caching details with key: "$key" (productId: $actualProductId, productType: $actualProductType, ${details.stockItems.length} items)');

      await stockDetailsBox.put(key, jsonString);
      print(
          '✅ Cached stock details for productId: $actualProductId, productType: $actualProductType');
    } catch (e) {
      print('❌ Error caching stock details: $e');
    }
  }

  @override
  StockDetailsEntity? getCachedStockDetails(int productId, String productType) {
    try {
      final key = _getStockDetailsKey(productId, productType);
      print(
          '🔍 Looking for cached details with key: "$key" (productId: $productId, productType: $productType)');

      final jsonString = stockDetailsBox.get(key);

      if (jsonString == null) {
        print(
            'ℹ️ No cached stock details found for key: "$key" (productId: $productId, productType: $productType)');
        return null;
      }

      // Parse JSON string
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      print('📄 Parsed cached JSON data');

      // Validate that cached data matches requested productId and productType
      final cachedProductId = jsonData['productId'] as int;
      final cachedProductType = jsonData['productType'] as String;

      print(
          '🔍 Validation: Requested productId=$productId, productType=$productType');
      print(
          '🔍 Validation: Cached productId=$cachedProductId, productType=$cachedProductType');

      if (cachedProductId != productId || cachedProductType != productType) {
        print('❌ CACHE MISMATCH DETECTED!');
        print('❌ Requested: productId=$productId, productType=$productType');
        print(
            '❌ Cached: productId=$cachedProductId, productType=$cachedProductType');
        print('🗑️ Removing invalid cache entry with key: "$key"');
        // Remove invalid cache entry
        stockDetailsBox.delete(key);
        print('✅ Invalid cache entry removed');
        return null;
      }

      print('✅ Cache validation passed - data matches requested product');

      // Convert to StockDetailsModel
      final detailsModel = StockDetailsModel(
        productId: cachedProductId,
        totalQuantity: jsonData['totalQuantity'] as int,
        minStockLevel: jsonData['minStockLevel'] as int?,
        productType: cachedProductType,
        stockItems: (jsonData['stockItems'] as List)
            .map(
                (item) => StockItemModel.fromJson(item as Map<String, dynamic>))
            .toList(),
      );

      print(
          '✅ Retrieved cached stock details for productId: $productId, productType: $productType (${detailsModel.stockItems.length} items)');

      // Debug info (wrapped in try-catch to avoid breaking the flow)
      try {
        final keys = getAllCachedStockDetailsKeys();
        final productIds = getAllCachedProductIds();
        final count = getCachedProductsCount();
        print(
            '📊 Cache stats: $count products cached, keys: $keys, productIds: $productIds');
      } catch (e) {
        print('⚠️ Error getting cache stats: $e');
      }

      return detailsModel.toEntity();
    } catch (e) {
      print('❌ Error retrieving cached stock details: $e');
      return null;
    }
  }

  /// Get all cached stock details keys (for debugging)
  List<String> getAllCachedStockDetailsKeys() {
    final keys = stockDetailsBox.keys.map((key) => key.toString()).toList();
    print(
        '📋 All cached stock details keys: $keys (${keys.length} products cached)');
    return keys;
  }

  /// Get count of cached products
  int getCachedProductsCount() {
    return stockDetailsBox.length;
  }

  /// Get all cached product IDs (for debugging)
  List<int> getAllCachedProductIds() {
    final productIds = <int>[];
    for (final key in stockDetailsBox.keys) {
      try {
        final jsonString = stockDetailsBox.get(key);
        if (jsonString != null) {
          final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
          final productId = jsonData['productId'] as int;
          productIds.add(productId);
        }
      } catch (e) {
        print('⚠️ Error parsing cached data for key $key: $e');
      }
    }
    print(
        '📊 Cached product IDs: $productIds (${productIds.length} unique products)');
    return productIds;
  }

  /// Clear all stock details cache (for debugging/testing)
  Future<void> clearStockDetailsCache() async {
    final count = stockDetailsBox.length;
    await stockDetailsBox.clear();
    print('🗑️ Cleared all stock details cache ($count entries removed)');
  }
}
