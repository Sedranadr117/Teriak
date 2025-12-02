import 'package:hive/hive.dart';
import 'package:teriak/features/products/add_product/data/models/hive_pending_product_model.dart';

abstract class AddProductLocalDataSource {
  Future<void> savePendingProduct(HivePendingProductModel pendingProduct);
  List<HivePendingProductModel> getPendingProducts();
  int getPendingProductsCount();
  Future<void> deletePendingProduct(int id);
  Future<void> clearPendingProducts();
}

class AddProductLocalDataSourceImpl implements AddProductLocalDataSource {
  final Box<HivePendingProductModel> pendingProductBox;

  AddProductLocalDataSourceImpl({required this.pendingProductBox});

  @override
  Future<void> savePendingProduct(HivePendingProductModel pendingProduct) async {
    await pendingProductBox.put(pendingProduct.id, pendingProduct);
    print('✅ Saved pending product offline (ID: ${pendingProduct.id})');
  }

  @override
  List<HivePendingProductModel> getPendingProducts() {
    return pendingProductBox.values.toList();
  }

  @override
  int getPendingProductsCount() {
    return pendingProductBox.length;
  }

  @override
  Future<void> deletePendingProduct(int id) async {
    await pendingProductBox.delete(id);
    print('✅ Deleted pending product (ID: $id)');
  }

  @override
  Future<void> clearPendingProducts() async {
    await pendingProductBox.clear();
    print('✅ Cleared all pending products');
  }
}

