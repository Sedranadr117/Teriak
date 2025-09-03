import 'package:dartz/dartz.dart';
import 'package:teriak/features/money_box/data/datasources/get_money_box_remote_data_source.dart';
import 'package:teriak/features/money_box/domain/entities/money_box_entity.dart';
import 'package:teriak/features/money_box/domain/repositories/get_money_box_repository.dart';

import '../../../../../core/connection/network_info.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failure.dart';

class MoneyBoxRepositoryImpl extends MoneyBoxRepository {
  final NetworkInfo networkInfo;
  final MoneyBoxRemoteDataSource remoteDataSource;
  MoneyBoxRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, MoneyBoxEntity>> getMoneyBox() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteMoneyBox = await remoteDataSource.getMoneyBox();
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
