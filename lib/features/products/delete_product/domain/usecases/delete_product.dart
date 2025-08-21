import 'package:dartz/dartz.dart';
import 'package:teriak/features/Products/delete_Product/domain/repositories/delete_Product_repository.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';

class DeleteProduct {
  final DeleteProductRepository repository;

  DeleteProduct({required this.repository});

  Future<Either<Failure, void>> call({required DeleteProductParams params}) {
    return repository.deleteProduct(params: params);
  }
}
