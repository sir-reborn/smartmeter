import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
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
