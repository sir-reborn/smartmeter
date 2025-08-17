import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:smartmeter/pages/dashboard.dart';

class BuildCharts extends StatefulWidget {
  const BuildCharts({
    super.key,
    required this.unit,
    required this.data,
    required this.color,
  });
  final String unit;
  final List<DataPoint> data;
  final Color color;
  @override
  State<BuildCharts> createState() => _BuildChartsState();
}

class _BuildChartsState extends State<BuildCharts> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(
          title: AxisTitle(text: 'Time'),
          labelRotation: 45, // Rotates X labels to prevent overlap.
          labelIntersectAction: AxisLabelIntersectAction
              .rotate45, // Ensures labels don’t overwrite each other.
        ),
        //primaryYAxis: CategoryAxis(title: AxisTitle(text: widget.unit)),
        series: <SplineSeries<DataPoint, String>>[
          SplineSeries<DataPoint, String>(
            dataSource: widget.data, //your List<DataPoint>
            xValueMapper: (DataPoint point, _) =>
                point.time, // maps DataPoint.time to the x-axis
            yValueMapper: (DataPoint point, _) => point.value,
            color: widget.color,
            markerSettings: MarkerSettings(
              isVisible: true,
            ), //shows dots at each data point for visibility
          ),
        ],
        tooltipBehavior: TooltipBehavior(enable: true),
      ),
    );
  }
}
