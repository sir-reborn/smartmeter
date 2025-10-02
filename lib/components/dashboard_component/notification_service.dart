import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class NotificationService {
  final DatabaseReference _faultsRef = FirebaseDatabase.instance.ref('faults');
  final List<Map<String, dynamic>> _notifications = [];

  List<Map<String, dynamic>> get notifications => _notifications;
  int get unreadCount => _notifications.where((n) => !n['read']).length;

  void initialize() {
    _faultsRef.onChildAdded.listen((event) {
      final newNotification = {
        'message': event.snapshot.value as String,
        'timestamp': DateTime.now(),
        'read': false,
      };
      _notifications.insert(0, newNotification);
    });
  }

  void markAllAsRead() {
    for (var notification in _notifications) {
      notification['read'] = true;
    }
  }

  void clearAll() {
    _notifications.clear();
  }

  String formatTimestamp(DateTime timestamp) {
    return DateFormat('MMM dd, yyyy - hh:mm a').format(timestamp);
  }
}
