import 'package:dartz/dartz.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/money_box/data/datasources/post_money_box_reconcile_remote_data_source%20.dart';
import 'package:teriak/features/money_box/domain/entities/money_box_entity.dart';

import '../../../../../core/connection/network_info.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failure.dart';
import '../../domain/repositories/add_money_box_reconcile_repository.dart';

class AddMoneyBoxReconcileRepositoryImpl
    extends AddMoneyBoxReConcileRepository {
  final NetworkInfo networkInfo;
  final AddMoneyBoxReConcileRemoteDataSource remoteDataSource;
  AddMoneyBoxReconcileRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, MoneyBoxEntity>> postMoneyBoxReConcile(
      {required ReconcileMoneyBoxParams params}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteMoneyBox =
            await remoteDataSource.postMoneyBoxReConcile(params);
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
