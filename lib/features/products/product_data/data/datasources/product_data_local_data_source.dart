import 'package:hive/hive.dart';
import 'package:teriak/features/products/product_data/data/models/hive_product_data_model.dart';
import 'package:teriak/features/products/product_data/data/models/hive_product_names_model.dart';
import 'package:teriak/features/products/product_data/data/models/product_data_model.dart';
import 'package:teriak/features/products/product_data/data/models/product_names_model.dart';

abstract class ProductDataLocalDataSource {
  Future<void> cacheProductData(
    String type,
    String languageCode,
    List<ProductDataModel> data,
  );
  List<ProductDataModel> getCachedProductData(
    String type,
    String languageCode,
  );

  Future<void> cacheProductNames(
    String type,
    int productId,
    ProductNamesModel names,
  );
  ProductNamesModel? getCachedProductNames(String type, int productId);
}

class ProductDataLocalDataSourceImpl implements ProductDataLocalDataSource {
  final Box<HiveProductDataModel> productDataBox;
  final Box<HiveProductNamesModel> productNamesBox;

  ProductDataLocalDataSourceImpl({
    required this.productDataBox,
    required this.productNamesBox,
  });

  // Generate integer cache key for product data (type + languageCode)
  int _getProductDataKey(String type, String languageCode) {
    // Generate a hash from type and language code to create a unique integer key
    final keyString = '${type}_$languageCode';
    return keyString.hashCode & 0x7FFFFFFF; // Ensure positive integer
  }

  // Generate integer cache key for product names (type + productId)
  int _getProductNamesKey(String type, int productId) {
    // Generate a hash from type and productId to create a unique integer key
    final keyString = '${type}_$productId';
    return keyString.hashCode & 0x7FFFFFFF; // Ensure positive integer
  }

  @override
  Future<void> cacheProductData(
    String type,
    String languageCode,
    List<ProductDataModel> data,
  ) async {
    final baseKey = _getProductDataKey(type, languageCode);

    // Clear existing entries for this type/language
    // We'll use a range of keys starting from baseKey
    for (int i = 0; i < 1000; i++) {
      // Reasonable limit
      final key = baseKey + i;
      if (productDataBox.containsKey(key)) {
        await productDataBox.delete(key);
      } else {
        break; // Stop when we find no more entries
      }
    }

    // Store each item with a unique integer key
    for (int i = 0; i < data.length; i++) {
      final hiveData = HiveProductDataModel.fromProductDataModel(data[i]);
      final key = baseKey + i;
      await productDataBox.put(key, hiveData);
    }

    // Store count at a fixed offset (baseKey + 100000) to avoid conflicts
    final countKey = baseKey + 100000;
    await productDataBox.put(
        countKey, HiveProductDataModel(id: data.length, name: 'count'));

    print(
        '✅ Cached ${data.length} product data items (type: $type, lang: $languageCode)');
  }

  @override
  List<ProductDataModel> getCachedProductData(
    String type,
    String languageCode,
  ) {
    final baseKey = _getProductDataKey(type, languageCode);

    // Get count from the fixed offset
    final countKey = baseKey + 100000;
    final countEntry = productDataBox.get(countKey);

    if (countEntry == null || countEntry.name != 'count') {
      return [];
    }

    final count = countEntry.id;
    if (count == 0) {
      return [];
    }

    final cachedData = <ProductDataModel>[];

    // Retrieve items using integer keys
    for (int i = 0; i < count; i++) {
      final key = baseKey + i;
      final item = productDataBox.get(key);
      if (item != null && item.name != 'count') {
        // Convert HiveProductDataModel to ProductDataModel
        cachedData.add(ProductDataModel(
          id: item.id,
          name: item.name,
        ));
      }
    }

    return cachedData;
  }

  @override
  Future<void> cacheProductNames(
    String type,
    int productId,
    ProductNamesModel names,
  ) async {
    final key = _getProductNamesKey(type, productId);
    final hiveNames = HiveProductNamesModel.fromProductNamesModel(names);
    await productNamesBox.put(key, hiveNames);
    print('✅ Cached product names (type: $type, productId: $productId)');
  }

  @override
  ProductNamesModel? getCachedProductNames(String type, int productId) {
    final key = _getProductNamesKey(type, productId);
    final cached = productNamesBox.get(key);
    if (cached == null) return null;

    // Convert HiveProductNamesModel to ProductNamesModel
    return ProductNamesModel(
      id: cached.id,
      tradeNameAr: cached.tradeNameAr,
      tradeNameEn: cached.tradeNameEn,
      scientificNameAr: cached.scientificNameAr,
      scientificNameEn: cached.scientificNameEn,
    );
  }
}
