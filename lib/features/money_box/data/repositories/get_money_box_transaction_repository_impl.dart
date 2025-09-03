import 'package:dartz/dartz.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/money_box/data/models/money_box_transaction_model.dart';

import '../../../../../core/connection/network_info.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failure.dart';
import '../../domain/repositories/get_money_box_transaction_repository.dart';
import '../datasources/get_money_box_transaction_remote_data_source.dart';

class MoneyBoxTransactionRepositoryImpl extends MoneyBoxTransactionRepository {
  final NetworkInfo networkInfo;
  final MoneyBoxTransactionRemoteDataSource remoteDataSource;
  MoneyBoxTransactionRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, MoneyBoxTransactionPaginatedModel>> getMoneyBoxTransactions({required GetMoneyBoxTransactionParams params}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteMoneyBox = await remoteDataSource.getMoneyBoxTransaction(params);
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
