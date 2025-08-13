import 'package:teriak/features/stock_management/domain/entities/Stock_entity.dart';

class StockModel extends StockEntity {
  StockModel();

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel();
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}
