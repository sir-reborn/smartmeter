// lib/models/notification_model.dart
class AppNotification {
  final String id;
  final String faultType;
  final String faultDescription;
  final Map<String, dynamic> sensorData;
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  bool isRead;

  AppNotification({
    required this.id,
    required this.faultType,
    required this.faultDescription,
    required this.sensorData,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    this.isRead = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'faultType': faultType,
      'faultDescription': faultDescription,
      'sensorData': sensorData,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'isRead': isRead,
    };
  }

  factory AppNotification.fromMap(Map<String, dynamic> map) {
    return AppNotification(
      id: map['id'],
      faultType: map['faultType'],
      faultDescription: map['faultDescription'],
      sensorData: Map<String, dynamic>.from(map['sensorData']),
      latitude: map['latitude'].toDouble(),
      longitude: map['longitude'].toDouble(),
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      isRead: map['isRead'],
    );
  }
}
