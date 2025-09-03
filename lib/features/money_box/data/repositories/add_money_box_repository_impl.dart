import 'package:dartz/dartz.dart';
import 'package:teriak/features/money_box/data/datasources/post_money_box_remote_data_source.dart';
import 'package:teriak/features/money_box/domain/entities/money_box_entity.dart';
import 'package:teriak/features/money_box/domain/repositories/add_money_box_repository.dart';

import '../../../../../core/connection/network_info.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failure.dart';

class AddMoneyBoxRepositoryImpl extends AddMoneyBoxRepository {
  final NetworkInfo networkInfo;
  final AddMoneyBoxRemoteDataSource remoteDataSource;
  AddMoneyBoxRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, MoneyBoxEntity>> postMoneyBox({required Map<String, dynamic> body}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteMoneyBox = await remoteDataSource.postMoneyBox(body);
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
