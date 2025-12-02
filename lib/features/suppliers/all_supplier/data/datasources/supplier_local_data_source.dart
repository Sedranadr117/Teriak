import 'package:hive/hive.dart';
import 'package:teriak/features/suppliers/all_supplier/data/models/hive_supplier_model.dart';
import 'package:teriak/features/suppliers/all_supplier/data/models/supplier_model.dart';
import 'package:teriak/features/suppliers/all_supplier/domain/entities/supplier_entity.dart';

abstract class SupplierLocalDataSource {
  Future<void> cacheSuppliers(List<SupplierModel> suppliers);
  Future<void> cacheSupplier(SupplierModel supplier);
  Future<void> deleteCachedSupplier(int id);
  List<SupplierEntity> getCachedSuppliers();
  List<SupplierEntity> searchCachedSuppliers(String keyword);
  SupplierEntity? getCachedSupplierById(int id);
}

class SupplierLocalDataSourceImpl implements SupplierLocalDataSource {
  final Box<HiveSupplierModel> supplierBox;

  SupplierLocalDataSourceImpl({required this.supplierBox});

  @override
  Future<void> cacheSuppliers(List<SupplierModel> suppliers) async {
    final seenIds = <int>{};
    int cachedCount = 0;

    for (final supplier in suppliers) {
      if (!seenIds.contains(supplier.id)) {
        final hiveSupplier = HiveSupplierModel.fromSupplierModel(supplier);
        final cacheKey = hiveSupplier.cacheKey;
        
        await supplierBox.put(cacheKey, hiveSupplier);
        seenIds.add(supplier.id);
        cachedCount++;
      } else {
        print('⚠️ Skipping duplicate supplier (ID: ${supplier.id}, Name: ${supplier.name})');
      }
    }

    print('✅ Cached $cachedCount suppliers');
  }

  @override
  Future<void> cacheSupplier(SupplierModel supplier) async {
    final hiveSupplier = HiveSupplierModel.fromSupplierModel(supplier);
    final cacheKey = hiveSupplier.cacheKey;

    // Check if supplier already exists
    final existing = supplierBox.get(cacheKey);
    if (existing != null) {
      print('🔄 Updating existing cached supplier: ${supplier.name} (ID: ${supplier.id})');
    } else {
      print('✅ Caching new supplier: ${supplier.name} (ID: ${supplier.id})');
    }

    await supplierBox.put(cacheKey, hiveSupplier);
  }

  @override
  Future<void> deleteCachedSupplier(int id) async {
    final cacheKey = id.toString();
    await supplierBox.delete(cacheKey);
    print('🗑️ Deleted cached supplier (ID: $id)');
  }

  @override
  List<SupplierEntity> getCachedSuppliers() {
    final suppliers = <SupplierEntity>[];
    final seenIds = <int>{};

    for (final hiveSupplier in supplierBox.values) {
      if (!seenIds.contains(hiveSupplier.id)) {
        suppliers.add(hiveSupplier.toEntity());
        seenIds.add(hiveSupplier.id);
      }
    }

    print('📦 Returning ${suppliers.length} cached suppliers');
    return suppliers;
  }

  @override
  List<SupplierEntity> searchCachedSuppliers(String keyword) {
    final query = keyword.trim().toLowerCase();
    if (query.isEmpty) {
      return getCachedSuppliers();
    }

    final allSuppliers = getCachedSuppliers();
    final results = allSuppliers.where((supplier) {
      final nameMatch = supplier.name.toLowerCase().contains(query);
      final phoneMatch = supplier.phone.toLowerCase().contains(query);
      final addressMatch = supplier.address.toLowerCase().contains(query);
      return nameMatch || phoneMatch || addressMatch;
    }).toList();

    print('🔍 Found ${results.length} suppliers matching "$keyword"');
    return results;
  }

  @override
  SupplierEntity? getCachedSupplierById(int id) {
    final cacheKey = id.toString();
    final cachedSupplier = supplierBox.get(cacheKey);
    return cachedSupplier?.toEntity();
  }
}

