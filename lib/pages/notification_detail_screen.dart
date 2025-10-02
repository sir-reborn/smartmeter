// lib/screens/notification_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartmeter/components/dashboard_component/location_card.dart';
import '../models/notification_model.dart';

class NotificationDetailScreen extends StatelessWidget {
  final AppNotification notification;

  const NotificationDetailScreen({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fault Details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fault Information Card
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _getFaultIcon(notification.faultType),
                          color: _getFaultColor(notification.faultType),
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            notification.faultType,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      notification.faultDescription,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Detected: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(notification.timestamp)}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Sensor Data Card
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sensor Data at Time of Fault',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDataRow(
                      'Voltage',
                      '${notification.sensorData['voltage']?.toStringAsFixed(1) ?? 'N/A'} V',
                    ),
                    _buildDataRow(
                      'Current',
                      '${notification.sensorData['current']?.toStringAsFixed(1) ?? 'N/A'} A',
                    ),
                    _buildDataRow(
                      'Power',
                      '${notification.sensorData['power']?.toStringAsFixed(1) ?? 'N/A'} W',
                    ),
                    _buildDataRow(
                      'Frequency',
                      '${notification.sensorData['frequency']?.toStringAsFixed(1) ?? 'N/A'} Hz',
                    ),
                    _buildDataRow(
                      'Energy',
                      '${notification.sensorData['energy']?.toString() ?? 'N/A'} Wh',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Location Card
            LocationCard(
              longitude: notification.longitude,
              latitude: notification.latitude,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }

  IconData _getFaultIcon(String faultType) {
    switch (faultType) {
      case 'Short Circuit':
        return Icons.electrical_services;
      case 'Open Circuit':
        return Icons.power;
      case 'Power Outage':
        return Icons.warning;
      default:
        return Icons.error_outline;
    }
  }

  Color _getFaultColor(String faultType) {
    switch (faultType) {
      case 'Short Circuit':
        return Colors.orange;
      case 'Open Circuit':
        return Colors.red;
      case 'Power Outage':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  void _showMapDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location'),
        content: Text(
          'Latitude: ${notification.latitude}\nLongitude: ${notification.longitude}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
