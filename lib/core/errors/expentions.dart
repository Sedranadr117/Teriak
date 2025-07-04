import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:teriak/core/errors/error_model.dart';

//!ServerException
class ServerException implements Exception {
  final ErrorModel errorModel;
  ServerException(this.errorModel);
}

//!CacheExeption
class CacheExeption implements Exception {
  final String errorMessage;
  CacheExeption({required this.errorMessage});
}

class BadCertificateException extends ServerException {
  BadCertificateException(super.errorModel);
}

class ConnectionTimeoutException extends ServerException {
  ConnectionTimeoutException(super.errorModel);
}

class BadResponseException extends ServerException {
  BadResponseException(super.errorModel);
}

class ReceiveTimeoutException extends ServerException {
  ReceiveTimeoutException(super.errorModel);
}

class ConnectionErrorException extends ServerException {
  ConnectionErrorException(super.errorModel);
}

class SendTimeoutException extends ServerException {
  SendTimeoutException(super.errorModel);
}

class UnauthorizedException extends ServerException {
  UnauthorizedException(super.errorModel);
}

class ForbiddenException extends ServerException {
  ForbiddenException(super.errorModel);
}

class NotFoundException extends ServerException {
  NotFoundException(super.errorModel);
}

class CofficientException extends ServerException {
  CofficientException(super.errorModel);
}

class CancelException extends ServerException {
  CancelException(super.errorModel);
}

class UnknownException extends ServerException {
  UnknownException(super.errorModel);
}

void handleHttpException(Object e) {
  if (e is HttpException) {
    throw ConnectionErrorException(
        ErrorModel(errorMessage: e.message, status: 500));
  } else {
    throw UnknownException(ErrorModel(errorMessage: e.toString(), status: 500));
  }
}

void handleHttpResponse(http.Response response) {
  final status = response.statusCode;
  final errorModel = ErrorModel(
    errorMessage: response.body,
    status: status,
  );
  if (status >= 200 && status < 300) {
    return;
  } else if (status == 401) {
    throw UnauthorizedException(errorModel);
  } else if (status == 403) {
    throw ForbiddenException(errorModel);
  } else if (status == 404) {
    throw NotFoundException(errorModel);
  } else if (status == 500) {
    throw ServerException(errorModel);
  } else {
    throw UnknownException(errorModel);
  }
}
