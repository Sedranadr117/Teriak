import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/core/services/notification_service.dart';
import 'package:teriak/features/notification/data/datasources/notification_remote_data_source.dart';
import 'package:teriak/features/notification/data/repositories/notification_repository_impl.dart';
import 'package:teriak/features/notification/domain/entities/notification_entity.dart';
import 'package:teriak/features/notification/domain/usecases/get_notification.dart';
import 'package:teriak/features/notification/domain/usecases/post_fcm_token.dart';
import 'package:teriak/features/notification/domain/usecases/delete_fcm_token.dart';

class NotificationController extends GetxController {
  static NotificationController get to => Get.find();

  final RxList<NotificationEntity> notifications = <NotificationEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  late final NetworkInfoImpl networkInfo;
  late final GetNotification _getNotification;
  late final PostFcmToken _postFcmToken;
  late final DeleteFcmToken _deleteFcmToken;

  @override
  void onInit() {
    super.onInit();
    _initializeDependencies();
    _initializeNotifications();
  }

  void _initializeDependencies() {
    final cacheHelper = CacheHelper();
    final httpConsumer =
        HttpConsumer(baseUrl: EndPoints.baserUrl, cacheHelper: cacheHelper);
    networkInfo = NetworkInfoImpl();

    final remoteDataSource = NotificationRemoteDataSource(api: httpConsumer);

    final repository = NotificationRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );

    _getNotification = GetNotification(repository: repository);
    _postFcmToken = PostFcmToken(repository: repository);
    _deleteFcmToken = DeleteFcmToken(repository: repository);
  }

  void _initializeNotifications() {
    // Register callbacks with NotificationService
    NotificationService.instance.onNotificationReceived =
        _handleNotificationReceived;
    NotificationService.instance.onNotificationClicked =
        _handleNotificationClicked;
  }

  void _handleNotificationClicked(RemoteMessage message) {
    debugPrint("📬 Notification clicked: ${message.messageId}");
    _handleNotificationReceived(message);
    // Optionally navigate to notification page
    // Get.toNamed(AppPages.notifications);
  }

  void _handleNotificationReceived(RemoteMessage message) {
    // Convert RemoteMessage to NotificationEntity and add to list
    final notification = NotificationEntity(
      title: message.notification?.title ?? '',
      body: message.notification?.body ?? '',
      notificationType: message.data['type'] ?? 'general',
      sentAt: message.sentTime?.toIso8601String(),
      readAt: null,
      status: 'unread',
    );

    // Add to the beginning of the list
    notifications.insert(0, notification);
  }

  Future<void> fetchNotifications({int page = 0, int size = 20}) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        errorMessage.value =
            'No internet connection. Please check your network.'.tr;
        return;
      }

      final params = NotificationParams(page: page, size: size);
      final result = await _getNotification(params: params);

      result.fold(
        (failure) {
          errorMessage.value = failure.errMessage;
          debugPrint('❌ Failed to fetch notifications: ${failure.errMessage}');
        },
        (paginatedEntity) {
          notifications.assignAll(paginatedEntity.content);
          debugPrint(
              '✅ Successfully fetched ${paginatedEntity.content.length} notifications');
        },
      );
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred. Please try again.'.tr;
      debugPrint('💥 Exception occurred while fetching notifications: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendFcmToken() async {
    try {
      final token = NotificationService.instance.getSavedToken();
      if (token == null || token.isEmpty) {
        debugPrint('⚠️ FCM token not available');
        return;
      }

      final deviceType = Platform.isAndroid ? 'ANDROID' : 'IOS';
      final params = FcmTokenParams(
        deviceToken: token,
        deviceType: deviceType,
      );

      final result = await _postFcmToken(params: params);

      result.fold(
        (failure) {
          debugPrint('❌ Failed to send FCM token: ${failure.errMessage}');
        },
        (_) {
          debugPrint('✅ FCM token sent successfully');
        },
      );
    } catch (e) {
      debugPrint('💥 Exception occurred while sending FCM token: $e');
    }
  }

  Future<void> removeFcmToken() async {
    try {
      final token = NotificationService.instance.getSavedToken();
      if (token == null || token.isEmpty) {
        debugPrint('⚠️ FCM token not available for removal');
        return;
      }

      final params = DeleteFcmTokenParams(deviceToken: token);
      final result = await _deleteFcmToken(params: params);

      result.fold(
        (failure) {
          debugPrint('❌ Failed to remove FCM token: ${failure.errMessage}');
        },
        (_) {
          debugPrint('✅ FCM token removed successfully');
        },
      );
    } catch (e) {
      debugPrint('💥 Exception occurred while removing FCM token: $e');
    }
  }

  @override
  void onClose() {
    // Clear callbacks when controller is disposed
    NotificationService.instance.onNotificationReceived = null;
    NotificationService.instance.onNotificationClicked = null;
    super.onClose();
  }
}
