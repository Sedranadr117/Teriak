import 'dart:convert';
import 'package:teriak/features/auth/data/models/auth_model.dart';

import '../../../../../core/databases/cache/cache_helper.dart';
import '../../../../../core/errors/expentions.dart';

class AuthLocalDataSource {
  final CacheHelper cache;
  final String key = "CachedAuth";
  AuthLocalDataSource({required this.cache});

  cacheAuth(AuthModel? authToCache) {
    if (authToCache != null) {
      cache.saveData(
        key: key,
        value: json.encode(
          authToCache.toJson(),
        ),
      );
    } else {
      throw CacheExeption(errorMessage: "No Internet Connection");
    }
  }

  Future<AuthModel> getLastAuth() {
    final jsonString = cache.getDataString(key: key);

    if (jsonString != null) {
      return Future.value(AuthModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheExeption(errorMessage: "No Internet Connection");
    }
  }
}
