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
    required this.message,
    required this.timestamp,
    required this.isRead,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: isRead ? Colors.grey[100] : Colors.blue[50],
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: TextStyle(
                  fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                NotificationService().formatTimestamp(timestamp),
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
