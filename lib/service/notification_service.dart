// lib/services/notification_service.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../models/notification_model.dart';

class NotificationService with ChangeNotifier {
  static const String _notificationsKey = 'notifications';
  final List<AppNotification> _notifications = [];
  String? _lastFaultType;

  List<AppNotification> get notifications => _notifications;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  NotificationService() {
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? notificationsJson = prefs.getString(_notificationsKey);

      if (notificationsJson != null) {
        final List<dynamic> notificationsList =
            (json.decode(notificationsJson) as List)
                .cast<Map<String, dynamic>>();

        _notifications.clear();
        _notifications.addAll(
          notificationsList.map((map) => AppNotification.fromMap(map)).toList(),
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading notifications: $e');
    }
  }

  Future<void> _saveNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> notificationsMap = _notifications
          .map((notification) => notification.toMap())
          .toList();

      await prefs.setString(_notificationsKey, json.encode(notificationsMap));
    } catch (e) {
      debugPrint('Error saving notifications: $e');
    }
  }

  void addNotification({
    required String faultType,
    required String faultDescription,
    required Map<String, dynamic> sensorData,
    required double latitude,
    required double longitude,
  }) {
    // ✅ If this is the same fault type as last time and the most recent notification is unread, skip
    if (_lastFaultType == faultType &&
        _notifications.isNotEmpty &&
        _notifications.first.faultType == faultType) {
      return;
    }

    final notification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      faultType: faultType,
      faultDescription: faultDescription,
      sensorData: sensorData,
      latitude: latitude,
      longitude: longitude,
      timestamp: DateTime.now(),
    );

    _notifications.insert(0, notification);
    _lastFaultType = faultType; // ✅ Remember this fault type
    _saveNotifications();
    notifyListeners();
  }

  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index].isRead = true;
      _saveNotifications();
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (final notification in _notifications) {
      notification.isRead = true;
    }
    _saveNotifications();
    notifyListeners();
  }

  void clearAllNotifications() {
    _notifications.clear();
    _saveNotifications();
    notifyListeners();
  }

  String formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return DateFormat('yyyy-MM-dd HH:mm').format(timestamp);
    }
  }

  String getBriefMessage(String faultDescription) {
    if (faultDescription.toLowerCase().contains('short circuit')) {
      return 'Short circuit detected';
    } else if (faultDescription.toLowerCase().contains('open circuit')) {
      return 'Open circuit detected';
    } else if (faultDescription.toLowerCase().contains('power outage')) {
      return '⚠️ Power outage detected';
    } else {
      return '⚠️ $faultDescription';
    }
  }

  void resetLastFaultType() {
    _lastFaultType = null;
  }
}
