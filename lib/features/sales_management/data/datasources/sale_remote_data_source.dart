import 'package:teriak/core/databases/api/api_consumer.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/sales_management/data/models/invoice_model.dart';
import 'package:teriak/features/sales_management/data/models/refund_model.dart';

class SaleRemoteDataSource {
  final ApiConsumer api;

  SaleRemoteDataSource({required this.api});

  Future<InvoiceModel> createSale(SaleProcessParams parms) async {
    final sale = {
      "customerId": parms.customerId,
      "paymentType": parms.paymentType,
      "paymentMethod": parms.paymentMethod,
      "currency": parms.currency,
      "invoiceDiscountType": parms.discountType,
      "invoiceDiscountValue": parms.discountValue,
      "paidAmount": parms.paidAmount,
      'debtDueDate': parms.debtDueDate,
      "items": parms.items.map((e) => e.toJson()).toList(),
    };

    final respons = await api.post(EndPoints.sales, data: sale);

    final process = InvoiceModel.fromJson(respons);
    print('✅ sale created with ID: ${process.id}');

    return process;
  }

  Future<List<InvoiceModel>> getAllInvoices() async {
    try {
      final response = await api.get(EndPoints.sales);
      print('📥 Raw response from invoices: $response');
      final List data = response;
      return data.map((e) => InvoiceModel.fromJson(e)).toList();
    } catch (e) {
      print('❌ Error fetching invoices: $e');
      rethrow;
    }
  }

  Future<List<InvoiceModel>> searchInvoiceByDateRange(
      SearchInvoiceByDateRangeParams params) async {
    print("--------------------");
    try {
      final response = await api.get(
        EndPoints.searchInvoicesByRange,
        queryParameters: params.toMap(),
      );

      print('Raw response: $response');

      return (response as List).map((item) {
        print('Invoice item: $item');
        return InvoiceModel.fromJson(item);
      }).toList();
    } catch (e) {
      print('❌ Error fetching invoices: $e');
      rethrow;
    }
  }

  Future<SaleRefundModel> createRefund({
    required int saleInvoiceId,
    required SaleRefundParams params,
  }) async {
    try {
      final response = await api.post(
        '${EndPoints.sales}/$saleInvoiceId/refund',
        data: params.toJson(),
      );
      return SaleRefundModel.fromJson(response);
    } catch (e) {
      print('❌ Error create refund: $e');
      rethrow;
    }
  }

  Future<List<SaleRefundModel>> getRefunds() async {
    try {
      final response = await api.get(EndPoints.salesRefunds);
      final List data = response;
      return data.map((e) => SaleRefundModel.fromJson(e)).toList();
    } catch (e) {
      print('❌ Error fetching refunds: $e');
      rethrow;
    }
  }
}
