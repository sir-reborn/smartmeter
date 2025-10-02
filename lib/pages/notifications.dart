import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartmeter/service/notification_service.dart';
import 'package:smartmeter/pages/notification_detail_screen.dart';

import '../models/notification_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NotificationAppBar(
        // onClearAll: () {
        //   setState(() {
        //     _notificationService.clearAll();
        //   });
        // },
      ),
      body: _notificationService.notifications.isEmpty
          ? const Center(child: Text('No notifications'))
          : ListView.builder(
              itemCount: _notificationService.notifications.length,
              itemBuilder: (context, index) {
                final notification = _notificationService.notifications[index];
                return NotificationCard(
                  message: notification['message'],
                  timestamp: notification['timestamp'],
                  isRead: notification['read'],
                  onTap: () {
                    setState(() {
                      notification['read'] = true;
                    });
                  },
                );
              },
            ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final notificationService = Provider.of<NotificationService>(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: notification.isRead ? Colors.grey[100] : Colors.blue[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.warning_rounded, color: Colors.red, size: 28),
              const SizedBox(width: 14),

              // Notification text section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ⚠️ Fault message
                    Text(
                      notificationService.getBriefMessage(
                        notification.faultDescription,
                      ),
                      style: TextStyle(
                        fontWeight: notification.isRead
                            ? FontWeight.w500
                            : FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),

                    // 📍 Location address
                    const SizedBox(height: 6),

                    // ⏱ Time ago
                    Text(
                      notificationService.formatTimestamp(
                        notification.timestamp,
                      ),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              // Unread indicator
              if (!notification.isRead)
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
