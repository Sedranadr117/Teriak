import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';

abstract class EditProductRepository {
  Future<Either<Failure, void>> putEditProduct(
      {required EditProductParams params,required Map<String, dynamic> body});
}
