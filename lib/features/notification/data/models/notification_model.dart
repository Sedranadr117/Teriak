import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/features/notification/domain/entities/notification_entity.dart';

class NotificationPaginatedModel extends NotificationPaginatedEntity {
  NotificationPaginatedModel({
    required super.size,
    required super.page,
    required super.content,
    required super.totalElements,
    required super.totalPages,
    required super.hasNext,
    required super.hasPrevious,
  });

  factory NotificationPaginatedModel.fromJson(Map<String, dynamic> json) {
    return NotificationPaginatedModel(
      content: (json[ApiKeys.content] as List<dynamic>? ?? [])
          .map((item) => NotificationModel.fromJson(item))
          .toList(),
      page: json[ApiKeys.page] ?? 0,
      size: json[ApiKeys.size] ?? 10,
      totalElements: json[ApiKeys.totalElements] ?? 0,
      totalPages: json[ApiKeys.totalPages] ?? 0,
      hasNext: json[ApiKeys.hasNext] ?? false,
      hasPrevious: json[ApiKeys.hasPrevious] ?? false,
    );
  }
}


class NotificationModel extends NotificationEntity {
  NotificationModel({
    required super.title,
    required super.body,
    required super.notificationType,
    required super.sentAt,
    required super.readAt,
    required super.status,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json[ApiKeys.title],
      body: json[ApiKeys.body],
      notificationType: json[ApiKeys.notificationType],
      sentAt: json[ApiKeys.sentAt],
      readAt: json[ApiKeys.readAt],
      status: json[ApiKeys.status],
    );
  }
}





