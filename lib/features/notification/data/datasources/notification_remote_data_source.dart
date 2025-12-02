import 'package:teriak/features/notification/data/models/notification_model.dart';

import '../../../../../core/databases/api/api_consumer.dart';
import '../../../../../core/databases/api/end_points.dart';
import '../../../../../core/params/params.dart';

class NotificationRemoteDataSource {
  final ApiConsumer api;

  NotificationRemoteDataSource({required this.api});
  Future<NotificationPaginatedModel> getNotification(
      NotificationParams params) async {
    final response = await api.get(EndPoints.notifications,
        queryParameters: params.toJson());
    return NotificationPaginatedModel.fromJson(response);
  }

  Future<void> postFcmToken(FcmTokenParams params) async {
    await api.post(EndPoints.registerToken, data: params.toJson());
  }

  Future<void> deleteFcmToken(DeleteFcmTokenParams params) async {
    await api.delete("${EndPoints.unRegisterToken}/${params.deviceToken}");
  }
}
