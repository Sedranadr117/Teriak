import 'package:hive/hive.dart';

part 'hive_pending_product_model.g.dart';

@HiveType(typeId: 5)
class HivePendingProductModel extends HiveObject {
  @HiveField(0)
  final int id; // Timestamp-based ID for offline products

  @HiveField(1)
  final String languageCode;

  @HiveField(2)
  final Map<String, dynamic> body; // The product data to be sent to server

  @HiveField(3)
  final String createdAt; // ISO 8601 timestamp

  @HiveField(4)
  final String status; // 'PENDING' for offline products

  HivePendingProductModel({
    required this.id,
    required this.languageCode,
    required this.body,
    required this.createdAt,
    this.status = 'PENDING',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'languageCode': languageCode,
      'body': body,
      'createdAt': createdAt,
      'status': status,
    };
  }

  factory HivePendingProductModel.fromJson(Map<String, dynamic> json) {
    return HivePendingProductModel(
      id: json['id'] as int,
      languageCode: json['languageCode'] as String,
      body: json['body'] as Map<String, dynamic>,
      createdAt: json['createdAt'] as String,
      status: json['status'] as String? ?? 'PENDING',
    );
  }

  /// Creates a HivePendingProductModel from product data for offline storage
  factory HivePendingProductModel.fromProductData({
    required String languageCode,
    required Map<String, dynamic> body,
  }) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    // Generate a unique ID within Hive's valid range (0 to 0x7FFFFFFF)
    // Use hash of timestamp + body to ensure uniqueness while staying in range
    final uniqueString = '${timestamp}_${body.hashCode}';
    final id = uniqueString.hashCode &
        0x7FFFFFFF; // Ensure positive integer within range

    return HivePendingProductModel(
      id: id,
      languageCode: languageCode,
      body: body,
      createdAt: DateTime.now().toIso8601String(),
      status: 'PENDING',
    );
  }
}
