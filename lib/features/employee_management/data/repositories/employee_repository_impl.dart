import 'package:dartz/dartz.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/errors/exceptions.dart';
import 'package:teriak/core/errors/failure.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/employee_management/data/datasources/employee_remote_data_source.dart';
import 'package:teriak/features/employee_management/domain/entities/employee_entity.dart';
import 'package:teriak/features/employee_management/domain/entities/role_id_entity.dart';
import 'package:teriak/features/employee_management/domain/repositories/employee_repository.dart';

class EmployeeRepositoryImpl extends EmployeeRepository {
  final NetworkInfo networkInfo;
  final EmployeeRemoteDataSource remoteDataSource;
  EmployeeRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, EmployeeEntity>> createEmployee({
    required EmployeeParams params,
  }) async {
    try {
      final remoteEmployee = await remoteDataSource.createEmployee(params);
      return Right(remoteEmployee);
    } on ServerException catch (e) {
      return Left(
          Failure(errMessage: e.toString(), statusCode: e.errorModel.status));
    }
  }

  @override
  Future<Either<Failure, void>> addWorkingHoursToEmployee(
    int employeeId,
    List<WorkingHoursRequestParams> workingHoursRequests,
  ) async {
    try {
      await remoteDataSource.addWorkingHoursToEmployee(
        employeeId: employeeId,
        workingHoursRequests: workingHoursRequests,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(
          Failure(errMessage: e.toString(), statusCode: e.errorModel.status));
    }
  }

  @override
  Future<Either<Failure, List<RoleEntity>>> getAllRoles() async {
    try {
      final remoteRoles = await remoteDataSource.getAllRoles();
      return Right(remoteRoles);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<EmployeeEntity>>> getAllEmployees() async {
    try {
      final remoteEmployees = await remoteDataSource.getAllEmployees();
      return Right(remoteEmployees);
    } on ServerException catch (e) {
      return Left(
          Failure(errMessage: e.toString(), statusCode: e.errorModel.status));
    }
  }

  @override
  Future<Either<Failure, EmployeeEntity>> editEmployee({
    required int employeeId,
    required EmployeeParams params,
  }) async {
    try {
      final updatedEmployee =
          await remoteDataSource.editEmployeeInfo(employeeId, params);
      return Right(updatedEmployee);
    } on ServerException catch (e) {
      return Left(
          Failure(errMessage: e.toString(), statusCode: e.errorModel.status));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEmployee(int id) async {
    try {
      await remoteDataSource.deleteEmployee(id);

      return const Right(null);
    } on ServerException catch (e) {
      return Left(
          Failure(errMessage: e.toString(), statusCode: e.errorModel.status));
    }
  }

  @override
  Future<Either<Failure, EmployeeEntity>> getEmployeesById({
    required int employeeId,
  }) async {
    try {
      final remoteEmployee =
          await remoteDataSource.getEmloyeeById(employeeId: employeeId);
      return Right(remoteEmployee);
    } on ServerException catch (e) {
      return Left(
          Failure(errMessage: e.toString(), statusCode: e.errorModel.status));
    }
  }
}
