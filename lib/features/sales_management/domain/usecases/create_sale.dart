import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/failure.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/Sales_management/domain/repositories/sale_repository.dart';
import 'package:teriak/features/sales_management/domain/entities/invoice_entity.dart';

class CreateSale {
  final SaleRepository repository;

  CreateSale({required this.repository});
  Future<Either<Failure, InvoiceEntity>> call(SaleProcessParams parms) {
    return repository.createSalelProcess(parms);
  }
}
