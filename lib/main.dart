import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:smartmeter/pages/dashboard.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(RealTimeEnergyMonitorApp());
}

class RealTimeEnergyMonitorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Real-Time Energy Monitor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Dashboard(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RealTimeDataDashboard extends StatefulWidget {
  @override
  _RealTimeDataDashboardState createState() => _RealTimeDataDashboardState();
}

class _RealTimeDataDashboardState extends State<RealTimeDataDashboard> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  late Stream<DatabaseEvent> _dataStream;
  //Stream is a sequence of asynchronous data events over time.
  //Here it provides real-time updates from Firebase as they happen —
  // meaning you don’t have to repeatedly ask Firebase for new data.
  // It just notifies you when the data changes.
  //DatabaseEvent Object contain the actual data snapshot (event.snapshot) — i.e., the Firebase data at the time of that event. It also contain metadata
  //
  List<DataPoint> voltageData = [];
  List<DataPoint> currentData = [];
  List<DataPoint> powerData = [];
  List<DataPoint> frequencyData = [];
  //These lists act as time series histories for each type of data:
  // voltageData holds past voltage values.
  //[
  //   DataPoint("14:32:50", 230.0),
  //   DataPoint("14:32:55", 231.1),
  //   ...
  // ] how each list will look like

  final int maxDataPoints = 50; // Limit points to keep graph readable
  final DateFormat timeFormat = DateFormat('HH:mm:ss');

  @override
  void initState() {
    super.initState();
    _dataStream = _databaseRef.child('sensor_data').onValue;

    //.onValue returns a Dart Stream<DatabaseEvent>. Every time the data under
    // 'sensor_data' changes, this stream emits a new DatabaseEvent.
    //snapshot contains the actual data from the firebase at the moment.
    //you access it with snapshot.data!.snapshot.value
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Real-Time Energy Data'), centerTitle: true),
      body: StreamBuilder<DatabaseEvent>(
        //reactively rebuild the UI when the database changes.
        stream: _dataStream, // used to make the UI update when there's new data
        builder: (context, snapshot) {
          //snapshot.hasData tells us if any data exists yet.
          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            final data = Map<String, dynamic>.from(
              snapshot.data!.snapshot.value as Map<dynamic, dynamic>,
            );
            //Firebase returns raw Map<dynamic, dynamic>, so we convert it into Map<String, dynamic>
            final timestamp = DateTime.now();
            final timeString = timeFormat.format(timestamp);

            // Update voltage data
            if (data['voltage'] != null) {
              voltageData.add(
                DataPoint(timeString, data['voltage'].toDouble()),
              );
              if (voltageData.length > maxDataPoints) {
                voltageData.removeAt(
                  0,
                ); // remove the oldest item to keep the chart clean.
              }
            }

            // Update current data
            if (data['current'] != null) {
              currentData.add(
                DataPoint(timeString, data['current'].toDouble()),
              );
              if (currentData.length > maxDataPoints) {
                currentData.removeAt(0);
              }
            }

            // Update power data
            if (data['power'] != null) {
              powerData.add(DataPoint(timeString, data['power'].toDouble()));
              if (powerData.length > maxDataPoints) {
                powerData.removeAt(0);
              }
            }

            // Update frequency data
            if (data['frequency'] != null) {
              frequencyData.add(
                DataPoint(timeString, data['frequency'].toDouble()),
              );
              if (frequencyData.length > maxDataPoints) {
                frequencyData.removeAt(0);
              }
            }
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildChart('Voltage (V)', voltageData, Colors.blue),
                  SizedBox(height: 20),
                  _buildChart('Current (A)', currentData, Colors.green),
                  SizedBox(height: 20),
                  _buildChart('Power (W)', powerData, Colors.red),
                  SizedBox(height: 20),
                  _buildChart('Frequency (Hz)', frequencyData, Colors.purple),
                  SizedBox(height: 20),
                  _buildLatestValues(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChart(String title, List<DataPoint> data, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              height: 200,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(
                  labelRotation: 45, // Rotates X labels to prevent overlap.
                  labelIntersectAction: AxisLabelIntersectAction
                      .rotate45, // Ensures labels don’t overwrite each other.
                ),
                series: <SplineSeries<DataPoint, String>>[
                  SplineSeries<DataPoint, String>(
                    dataSource: data, //your List<DataPoint>
                    xValueMapper: (DataPoint point, _) =>
                        point.time, // maps DataPoint.time to the x-axis
                    yValueMapper: (DataPoint point, _) => point.value,
                    color: color,
                    markerSettings: MarkerSettings(
                      isVisible: true,
                    ), //shows dots at each data point for visibility
                  ),
                ],
                tooltipBehavior: TooltipBehavior(enable: true),
              ),
            ),
          ],
        ),
      ),
    );
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
