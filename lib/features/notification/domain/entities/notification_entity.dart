// ignore_for_file: public_member_api_docs, sort_constructors_first

class NotificationPaginatedEntity {
  final int size;
  final int page;
  final List<NotificationEntity> content;
  final int totalElements;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  NotificationPaginatedEntity({
    required this.size,
    required this.page,
    required this.content,
    required this.totalElements,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });
}

class NotificationEntity {
  final String title;
  final String body;
  final String notificationType;
  final String? sentAt;
  final String? readAt;
  final String status;


  NotificationEntity({
    required this.title,
    required this.body,
    required this.notificationType,
    required this.sentAt,
    required this.readAt,
    required this.status,
  });

}


