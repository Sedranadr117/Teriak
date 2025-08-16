import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';
import '../repositories/edit_product_repository.dart';

class PutEditProduct {
  final EditProductRepository repository;

  PutEditProduct({required this.repository});

  Future<Either<Failure, void>> call(
      {required EditProductParams params,required Map<String, dynamic> body}) {
    return repository.putEditProduct(params: params,body: body);
  }
}
