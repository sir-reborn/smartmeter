import 'package:flutter/material.dart';
import 'package:smartmeter/components/dashboard_component/sliver_appbar.dart';
import 'package:smartmeter/components/dashboard_component/sliver_body.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../service/fault_status_provider.dart';
import '../service/notification_service.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  late Stream<DatabaseEvent> _dataStream;
  bool _showBackToTopButton = false;
  late ScrollController _scrollController;

  // Move these to a separate class to manage data
  final _dataManager = RealTimeDataManager();

  // Track previous values for change detection
  String _previousStatus = "false";
  String _previousFaults = "No fault";

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _showBackToTopButton = _scrollController.offset >= 200;
        });
      });

    _dataStream = _databaseRef.child('sensor_data').onValue;
    _dataStream.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          final data = Map<String, dynamic>.from(
            event.snapshot.value as Map<dynamic, dynamic>,
          );
          _dataManager.updateData(data);
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          MySliverAppBar(),
          MySliverList(dataManager: _dataManager),
        ],
      ),
      floatingActionButton: _showBackToTopButton
          ? FloatingActionButton(
              backgroundColor: Colors.grey.shade300,
              onPressed: _scrollToTop,
              child: const Icon(Icons.arrow_upward),
            )
          : null,
    );
  }
}

class RealTimeDataManager {
  final int maxDataPoints = 50;
  final DateFormat timeFormat = DateFormat('HH:mm:ss');

  final List<DataPoint> _voltageData = [];
  final List<DataPoint> _currentData = [];
  final List<DataPoint> _powerData = [];
  final List<DataPoint> _frequencyData = [];
  late Map<String, dynamic> _mydata = {};

  List<DataPoint> get voltageData => _voltageData;
  List<DataPoint> get currentData => _currentData;
  List<DataPoint> get powerData => _powerData;
  List<DataPoint> get frequencyData => _frequencyData;
  Map<String, dynamic> get data => _mydata;

  void updateData(Map<String, dynamic> data) {
    final timestamp = DateTime.now();
    final timeString = timeFormat.format(timestamp);
    _mydata = data;

    if (data['voltage'] != null) {
      _voltageData.add(DataPoint(timeString, data['voltage'].toDouble()));
      if (_voltageData.length > maxDataPoints) {
        _voltageData.removeAt(0);
      }
    }

    if (data['current'] != null) {
      _currentData.add(DataPoint(timeString, data['current'].toDouble()));
      if (_currentData.length > maxDataPoints) {
        _currentData.removeAt(0);
      }
    }

    if (data['power'] != null) {
      _powerData.add(DataPoint(timeString, data['power'].toDouble()));
      if (_powerData.length > maxDataPoints) {
        _powerData.removeAt(0);
      }
    }

    if (data['frequency'] != null) {
      _frequencyData.add(DataPoint(timeString, data['frequency'].toDouble()));
      if (_frequencyData.length > maxDataPoints) {
        _frequencyData.removeAt(0);
      }
    }
  }
}

class DataPoint {
  final String time;
  final double value;

  DataPoint(this.time, this.value);
}
