import 'package:teriak/core/databases/api/api_consumer.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/customer_managment/data/models/customer_debts_model.dart';
import 'package:teriak/features/customer_managment/data/models/customer_model.dart';
import 'package:teriak/features/customer_managment/data/models/payment_model.dart';

class CustomerRemoteDataSource {
  final ApiConsumer api;

  CustomerRemoteDataSource({required this.api});

  Future<List<CustomerModel>> getAllCustomers() async {
    final response = await api.get(EndPoints.getCustomers);
    return (response as List)
        .map((json) => CustomerModel.fromJson(json))
        .toList();
  }

  Future<CustomerModel> createCustomer(CustomerParams params) async {
    final customerData = {
      'name': params.name,
      'phoneNumber': params.phoneNumber,
      'address': params.address,
      'notes': params.notes
    };
    final response =
        await api.post(EndPoints.createCustomer, data: customerData);
    final customer = CustomerModel.fromJson(response);

    return customer;
  }

  Future<List<CustomerModel>> searchCustomer(SearchParams params) async {
    final response = await api.get(
      EndPoints.searchCustomers,
      queryParameters: params.toMap(),
    );
    print('Query params: ${params.toMap()}');

    print(response);
    return (response as List)
        .map((item) => CustomerModel.fromJson(item))
        .toList();
  }

  Future<void> deleteCustomer(int id) async {
    try {
      final response = await api.delete('customers/$id');
      print(response);
    } catch (e) {
      print('❌ Error in deleting : $e');
      rethrow;
    }
  }

  Future<CustomerModel> editCustomerInfo(
      int employeeId, CustomerParams params) async {
    try {
      final employeeData = {
        'name': params.name,
        'phoneNumber': params.phoneNumber,
        'address': params.address,
        'notes': params.notes,
      };

      print('📤 Sending customer data: $employeeData');

      final response = await api.put(
        'customers/$employeeId',
        data: employeeData,
      );
      return CustomerModel.fromJson(response);
    } catch (e) {
      print('❌ Error in customer employee : $e');
      rethrow;
    }
  }

  Future<PaymentModel> addPayment(int customerId, PaymentParams params) async {
    final paymentData = {
      "totalPaymentAmount": params.totalPaymentAmount,
      "paymentMethod": params.paymentMethod,
      "notes": params.notes,
    };
    final response = await api
        .post('${EndPoints.addPayment}$customerId/autoPay', data: paymentData);
    final payment = PaymentModel.fromJson(response);

    return payment;
  }

  Future<List<CustomerDebtsModel>> getCustomersDebts(int customerId) async {
    final response = await api.get('${EndPoints.getCustomerDebts}/$customerId');
    print('${EndPoints.getCustomerDebts}/$customerId');
    return (response as List)
        .map((json) => CustomerDebtsModel.fromJson(json))
        .toList();
  }
}
