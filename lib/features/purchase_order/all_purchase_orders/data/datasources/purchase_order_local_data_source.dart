import 'package:hive/hive.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/data/models/hive_purchase_order_model.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/data/models/purchase_model .dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/domain/entities/paginated_purchase_entity.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/domain/entities/purchase_entity%20.dart';

abstract class PurchaseOrderLocalDataSource {
  Future<void> cachePurchaseOrders(List<PurchaseOrderModel> purchaseOrders);
  Future<void> cachePurchaseOrder(PurchaseOrderModel purchaseOrder);
  Future<void> deleteCachedPurchaseOrder(int id);
  Future<void> clearDuplicatePurchaseOrders();
  List<PurchaseOrderEntity> getCachedPurchaseOrders();
  PurchaseOrderEntity? getCachedPurchaseOrderById(int id);
  PaginatedPurchaseOrderEntity getCachedPurchaseOrdersPaginated({
    required int page,
    required int size,
  });
}

class PurchaseOrderLocalDataSourceImpl implements PurchaseOrderLocalDataSource {
  final Box<HivePurchaseOrderModel> purchaseOrderBox;

  PurchaseOrderLocalDataSourceImpl({required this.purchaseOrderBox});

  @override
  Future<void> cachePurchaseOrders(
      List<PurchaseOrderModel> purchaseOrders) async {
    final seenIds = <int>{};
    int cachedCount = 0;

    for (final purchaseOrder in purchaseOrders) {
      if (!seenIds.contains(purchaseOrder.id)) {
        final hivePurchaseOrder =
            HivePurchaseOrderModel.fromPurchaseOrderModel(purchaseOrder);
        final cacheKey = hivePurchaseOrder.cacheKey;

        await purchaseOrderBox.put(cacheKey, hivePurchaseOrder);
        seenIds.add(purchaseOrder.id);
        cachedCount++;
      } else {
        print('⚠️ Skipping duplicate purchase order (ID: ${purchaseOrder.id})');
      }
    }

    print('✅ Cached $cachedCount purchase orders');
  }

  @override
  Future<void> cachePurchaseOrder(PurchaseOrderModel purchaseOrder) async {
    final hivePurchaseOrder =
        HivePurchaseOrderModel.fromPurchaseOrderModel(purchaseOrder);
    final cacheKey = hivePurchaseOrder.cacheKey;

    // Check if purchase order already exists
    final existing = purchaseOrderBox.get(cacheKey);
    if (existing != null) {
      print(
          '🔄 Updating existing cached purchase order: ID ${purchaseOrder.id}');
    } else {
      print('✅ Caching new purchase order: ID ${purchaseOrder.id}');
    }

    await purchaseOrderBox.put(cacheKey, hivePurchaseOrder);
  }

  @override
  Future<void> deleteCachedPurchaseOrder(int id) async {
    final cacheKey = id.toString();
    await purchaseOrderBox.delete(cacheKey);
    print('🗑️ Deleted cached purchase order (ID: $id)');
  }

  @override
  Future<void> clearDuplicatePurchaseOrders() async {
    final seenIds = <int>{};
    final seenCacheKeys = <String>{};
    final keysToDelete = <String>[];

    // Find duplicates
    for (final key in purchaseOrderBox.keys) {
      final purchaseOrder = purchaseOrderBox.get(key);
      if (purchaseOrder != null) {
        final cacheKey = purchaseOrder.cacheKey;
        if (seenIds.contains(purchaseOrder.id) ||
            seenCacheKeys.contains(cacheKey)) {
          keysToDelete.add(key.toString());
          print(
              '⚠️ Found duplicate purchase order (ID: ${purchaseOrder.id}, Key: $key)');
        } else {
          seenIds.add(purchaseOrder.id);
          seenCacheKeys.add(cacheKey);
        }
      }
    }

    // Delete duplicates (keep the first occurrence)
    for (final key in keysToDelete) {
      await purchaseOrderBox.delete(key);
    }

    if (keysToDelete.isNotEmpty) {
      print('🧹 Removed ${keysToDelete.length} duplicate purchase order(s)');
    }
  }

  @override
  List<PurchaseOrderEntity> getCachedPurchaseOrders() {
    final purchaseOrders = <PurchaseOrderEntity>[];
    final seenIds = <int>{};
    final seenCacheKeys = <String>{};

    for (final hivePurchaseOrder in purchaseOrderBox.values) {
      final cacheKey = hivePurchaseOrder.cacheKey;

      // Deduplicate by both ID and cache key to prevent duplicates
      if (!seenIds.contains(hivePurchaseOrder.id) &&
          !seenCacheKeys.contains(cacheKey)) {
        purchaseOrders.add(hivePurchaseOrder.toEntity());
        seenIds.add(hivePurchaseOrder.id);
        seenCacheKeys.add(cacheKey);
      } else {
        print(
            '⚠️ Skipping duplicate purchase order (ID: ${hivePurchaseOrder.id}, Key: $cacheKey)');
      }
    }

    // Sort by creation date (newest first)
    purchaseOrders.sort((a, b) {
      if (a.createdAt.length >= 6 && b.createdAt.length >= 6) {
        final dateA = DateTime(a.createdAt[0], a.createdAt[1], a.createdAt[2],
            a.createdAt[3], a.createdAt[4], a.createdAt[5]);
        final dateB = DateTime(b.createdAt[0], b.createdAt[1], b.createdAt[2],
            b.createdAt[3], b.createdAt[4], b.createdAt[5]);
        return dateB.compareTo(dateA);
      }
      return 0;
    });

    print(
        '📦 Returning ${purchaseOrders.length} unique cached purchase orders (deduplicated)');
    return purchaseOrders;
  }

  @override
  PurchaseOrderEntity? getCachedPurchaseOrderById(int id) {
    final cacheKey = id.toString();
    final cachedPurchaseOrder = purchaseOrderBox.get(cacheKey);
    return cachedPurchaseOrder?.toEntity();
  }

  @override
  PaginatedPurchaseOrderEntity getCachedPurchaseOrdersPaginated({
    required int page,
    required int size,
  }) {
    final allPurchaseOrders = getCachedPurchaseOrders();
    final total = allPurchaseOrders.length;

    // Handle 0-based and 1-based page numbers
    // If page is 0, treat it as page 1 (first page)
    final normalizedPage = page <= 0 ? 1 : page;
    final startIndex = (normalizedPage - 1) * size;
    final endIndex = startIndex + size;

    if (startIndex >= total || total == 0) {
      return PaginatedPurchaseOrderEntity(
        content: [],
        page: normalizedPage,
        size: size,
        totalElements: total,
        totalPages: total > 0 ? (total / size).ceil() : 0,
        hasNext: false,
        hasPrevious: normalizedPage > 1,
      );
    }

    final paginatedPurchaseOrders = allPurchaseOrders.sublist(
      startIndex,
      endIndex > total ? total : endIndex,
    );

    return PaginatedPurchaseOrderEntity(
      content: paginatedPurchaseOrders,
      page: normalizedPage,
      size: size,
      totalElements: total,
      totalPages: (total / size).ceil(),
      hasNext: endIndex < total,
      hasPrevious: normalizedPage > 1,
    );
  }
}
