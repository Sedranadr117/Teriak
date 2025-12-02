import 'package:hive/hive.dart';
import 'package:teriak/features/customer_managment/data/models/customer_model.dart';
import 'package:teriak/features/customer_managment/data/models/hive_customer_model.dart';
import 'package:teriak/features/customer_managment/domain/entities/customer_entity.dart';

abstract class CustomerLocalDataSource {
  Future<void> cacheCustomers(List<CustomerModel> customers);
  List<CustomerEntity> getCachedCustomers();
  List<CustomerEntity> searchCachedCustomers(String keyword);
}

class CustomerLocalDataSourceImpl implements CustomerLocalDataSource {
  final Box<HiveCustomerModel> customerBox;

  CustomerLocalDataSourceImpl({required this.customerBox});

  @override
  Future<void> cacheCustomers(List<CustomerModel> customers) async {
    await customerBox.clear();

    // Use put with customer ID as key
    for (final customer in customers) {
      final hiveCustomer = HiveCustomerModel.fromCustomerModel(customer);
      await customerBox.put(customer.id, hiveCustomer);
    }

    print('✅ Cached ${customers.length} customers with IDs as keys');
  }

  @override
  List<CustomerEntity> getCachedCustomers() {
    return customerBox.values.map((customer) => customer.toEntity()).toList();
  }

  @override
  List<CustomerEntity> searchCachedCustomers(String keyword) {
    final query = keyword.trim().toLowerCase();

    if (query.isEmpty) {
      return getCachedCustomers();
    }

    final allCustomers = customerBox.values.toList();
    print(
        '🔍 Searching in ${allCustomers.length} cached customers for: "$keyword"');

    final results = allCustomers
        .where((customer) {
          final nameMatch = customer.name.toLowerCase().contains(query);
          final phoneMatch = customer.phoneNumber.toLowerCase().contains(query);
          final addressMatch = customer.address.toLowerCase().contains(query);

          return nameMatch || phoneMatch || addressMatch;
        })
        .map((customer) => customer.toEntity())
        .toList();

    print('📊 Search results: ${results.length} customers');
    return results;
  }
}
