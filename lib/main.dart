import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:smartmeter/pages/dashboard.dart';
import 'package:provider/provider.dart';
import 'package:smartmeter/service/fault_status_provider.dart';
import 'package:smartmeter/service/notification_service.dart';
import 'package:smartmeter/pages/notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(RealTimeEnergyMonitorApp());
}

class RealTimeEnergyMonitorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotificationService()),
        ChangeNotifierProvider(create: (_) => FaultStatusProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart Meter',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Dashboard(),
        routes: {'/notifications': (context) => const NotificationsScreen()},
      ),
    );
  }
}

  Widget _buildLatestValues() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Latest Values',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildValueRow(
              'Voltage:',
              voltageData.isNotEmpty
                  ? '${voltageData.last.value.toStringAsFixed(2)} V'
                  : 'N/A',
            ),
            _buildValueRow(
              'Current:',
              currentData.isNotEmpty
                  ? '${currentData.last.value.toStringAsFixed(2)} A'
                  : 'N/A',
            ),
            _buildValueRow(
              'Power:',
              powerData.isNotEmpty
                  ? '${powerData.last.value.toStringAsFixed(2)} W'
                  : 'N/A',
            ),
            _buildValueRow(
              'Frequency:',
              frequencyData.isNotEmpty
                  ? '${frequencyData.last.value.toStringAsFixed(2)} Hz'
                  : 'N/A',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16)),
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class DataPoint {
  final String time;
  final double value;

  DataPoint(this.time, this.value);
  //DataPoint("14:32:50", 230.0)- at 14:32:50, the voltage was 230.0 volts.
}
