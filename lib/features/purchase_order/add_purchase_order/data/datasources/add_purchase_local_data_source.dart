import 'package:hive/hive.dart';
import 'package:teriak/features/purchase_order/add_purchase_order/data/models/hive_pending_purchase_order_model.dart';

abstract class AddPurchaseOrderLocalDataSource {
  Future<void> savePendingPurchaseOrder(
      HivePendingPurchaseOrderModel pendingPurchaseOrder);
  List<HivePendingPurchaseOrderModel> getPendingPurchaseOrders();
  int getPendingPurchaseOrdersCount();
  Future<void> deletePendingPurchaseOrder(int id);
  Future<void> clearPendingPurchaseOrders();
}

class AddPurchaseOrderLocalDataSourceImpl
    implements AddPurchaseOrderLocalDataSource {
  final Box<HivePendingPurchaseOrderModel> pendingPurchaseOrderBox;

  AddPurchaseOrderLocalDataSourceImpl({required this.pendingPurchaseOrderBox});

  @override
  Future<void> savePendingPurchaseOrder(
      HivePendingPurchaseOrderModel pendingPurchaseOrder) async {
    await pendingPurchaseOrderBox.put(
        pendingPurchaseOrder.id, pendingPurchaseOrder);
    print(
        '✅ Saved pending purchase order offline (ID: ${pendingPurchaseOrder.id})');
  }

  @override
  List<HivePendingPurchaseOrderModel> getPendingPurchaseOrders() {
    return pendingPurchaseOrderBox.values.toList();
  }

  @override
  int getPendingPurchaseOrdersCount() {
    return pendingPurchaseOrderBox.length;
  }

  @override
  Future<void> deletePendingPurchaseOrder(int id) async {
    await pendingPurchaseOrderBox.delete(id);
    print('✅ Deleted pending purchase order (ID: $id)');
  }

  @override
  Future<void> clearPendingPurchaseOrders() async {
    await pendingPurchaseOrderBox.clear();
    print('✅ Cleared all pending purchase orders');
  }
}

