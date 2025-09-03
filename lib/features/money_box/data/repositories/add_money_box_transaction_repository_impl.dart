import 'package:dartz/dartz.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/money_box/data/datasources/post_money_box_transaction_remote_data_source.dart';
import 'package:teriak/features/money_box/domain/entities/money_box_entity.dart';
import '../../../../../core/connection/network_info.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failure.dart';
import '../../domain/repositories/add_money_box_transaction_repository.dart';

class AddMoneyBoxTransactionRepositoryImpl extends AddMoneyBoxTransactionRepository {
  final NetworkInfo networkInfo;
  final AddMoneyBoxTransactionRemoteDataSource remoteDataSource;
  AddMoneyBoxTransactionRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, MoneyBoxEntity>> postMoneyBoxTransaction({required MoneyBoxTransactionParams params}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteMoneyBox = await remoteDataSource.postMoneyBoxTransaction(params);
        return Right(remoteMoneyBox);
      } on ServerException catch (e) {
        return Left(Failure(
          errMessage: e.errorModel.errorMessage,
          statusCode: e.errorModel.status,
        ));
      }
    } else {
      return Left(Failure(errMessage: 'No internet connection'));
    }
  }
}
