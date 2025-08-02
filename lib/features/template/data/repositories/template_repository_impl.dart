import 'package:dartz/dartz.dart';

import '../../../../../core/connection/network_info.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';
import '../../domain/entities/template_entity.dart';
import '../../domain/repositories/template_repository.dart';
import '../datasources/template_remote_data_source.dart';

class TemplateRepositoryImpl extends TemplateRepository {
  final NetworkInfo networkInfo;
  final TemplateRemoteDataSource remoteDataSource;
  TemplateRepositoryImpl(
      {required this.remoteDataSource,
      required this.networkInfo});
  @override
  Future<Either<Failure, TemplateEntity>> getTemplate(
      {required TemplateParams params}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTemplate = await remoteDataSource.getTemplate(params);
        return Right(remoteTemplate);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
   return Left(Failure(errMessage: 'No internet connection'));
      }
  }
}
