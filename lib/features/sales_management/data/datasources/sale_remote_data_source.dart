import 'package:teriak/core/databases/api/api_consumer.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/sales_management/data/models/invoice_model.dart';

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
      "items": parms.items.map((e) => e.toJson()).toList(),
    };

    final respons = await api.post(EndPoints.createSale, data: sale);

    final process = InvoiceModel.fromJson(respons);
    print('✅ sale created with ID: ${process.id}');

    return process;
  }

  Future<List<InvoiceModel>> getAllInvoices() async {
    try {
      final response = await api.get(EndPoints.getSales);
      print('📥 Raw response from invoices: $response');
      final List data = response;
      return data.map((e) => InvoiceModel.fromJson(e)).toList();
    } catch (e) {
      print('❌ Error fetching invoices: $e');
      rethrow;
    }
  }
}
