import 'package:smartmeter/components/dashboard_component/data_charts.dart';
import 'package:smartmeter/components/dashboard_component/location_card.dart';
import 'package:smartmeter/pages/dashboard.dart';
import 'package:smartmeter/utilities/spacer.dart';
import 'package:flutter/material.dart';
import 'package:smartmeter/components/dashboard_component/current_data_container.dart';
import 'package:smartmeter/components/dashboard_component/energy_and_power_status_containers.dart';
import 'package:google_fonts/google_fonts.dart';

String dashboardTopText =
    'Here is the data of your personal power consumption.';

class MySliverList extends StatefulWidget {
  const MySliverList({Key? key, required this.dataManager}) : super(key: key);
  final RealTimeDataManager dataManager;
  @override
  _MySliverListState createState() => _MySliverListState();
}

class _MySliverListState extends State<MySliverList> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //-------------------------------******--------------------------------------

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                size.width / 14,
                size.width / 40,
                size.width / 14,
                size.width / 20,
              ),
              child: Column(
                children: [
                  //---------------------------------------------------------------------
                  Column(
                    children: [
                      SizedBox(
                        width: size.width,
                        child: Text(
                          dashboardTopText,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(57, 57, 57, 1),
                          ),
                        ),
                      ),
                      const Spacer2(),
                      LocationCard(
                        latitude: widget.dataManager.data['latitude']
                            ?.toDouble(),
                        longitude: widget.dataManager.data['longitude']
                            ?.toDouble(),
                      ),
                      const Spacer1(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          EnergyConsumptionContainer(
                            energy: widget.dataManager.data['energy'] != null
                                ? '${(widget.dataManager.data['energy']).toStringAsFixed(2)}'
                                : 'N/A',
                            //dataManager: widget.dataManager,
                          ),
                          MetersDetailsContainer(),
                        ],
                      ),
                    ],
                  ),
                  const Spacer2(),

                  //---------------------------------------------------------------------
                  Row(
                    children: [
                      Text(
                        "Current Data",
                        style: GoogleFonts.poppins(
                          fontSize: size.width / 20,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(57, 57, 57, 1),
                        ),
                      ),
                    ],
                  ),
                  const Spacer2(),
                  CurrentPowerSupplyContainer(
                    power: widget.dataManager.data['power'] != null
                        ? '${(widget.dataManager.data['power']).toStringAsFixed(2)}'
                        : 'N/A',
                    frequency: widget.dataManager.data['frequency'] != null
                        ? '${(widget.dataManager.data['frequency']).toStringAsFixed(2)}'
                        : 'N/A',
                    voltage: widget.dataManager.data['voltage'] != null
                        ? '${(widget.dataManager.data['voltage']).toStringAsFixed(2)}'
                        : 'N/A',
                    current: widget.dataManager.data['current'] != null
                        ? '${(widget.dataManager.data['current']).toStringAsFixed(2)}'
                        : 'N/A',
                  ),
                  const Spacer2(),

                  //---------------------------------------------------------------------
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(252, 252, 252, 1),
                      borderRadius: BorderRadius.all(
                        Radius.circular(size.width / 40),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Energy Data Visualization",
                              style: GoogleFonts.poppins(
                                fontSize: size.height / 43,
                                fontWeight: FontWeight.w600,
                                color: const Color.fromRGBO(31, 31, 31, 1),
                              ),
                            ),
                          ],
                        ),
                        const Spacer2(),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(size.width / 40),
                            ),
                          ),
                          width: size.width,
                          child: Column(
                            children: [
                              Text(
                                "Voltage Chart (V)",
                                style: GoogleFonts.poppins(
                                  fontSize: size.height / 43,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(31, 31, 31, 1),
                                ),
                              ),
                              const SpacerSmall(),
                              Container(
                                color: Colors.white70,
                                height: size.height / 2,
                                width: size.width,
                                //the builder below rebuilds it child when the a ValueNotifier<T> changes, a simple and efficient way to react to a single piece of state
                                // valueListenable is the notifier we are listening to. when it changes, the builder is called
                                // and the BuildChart widget rebuilds.
                                child: ValueListenableBuilder<List<DataPoint>>(
                                  valueListenable: ValueNotifier(
                                    widget.dataManager.voltageData,
                                  ),
                                  builder: (context, data, _) {
                                    return BuildCharts(
                                      unit: 'V',
                                      data: data,
                                      color: Colors.blue,
                                    );
                                  },
                                ),
                              ),
                              const Spacer1(),

                              //-------------------------------------------------------------------
                              Text(
                                "Current Chart (A)",
                                style: GoogleFonts.poppins(
                                  fontSize: size.height / 43,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(31, 31, 31, 1),
                                ),
                              ),
                              const SpacerSmall(),
                              Container(
                                color: Colors.white70,
                                height: size.height / 2,
                                width: size.width,
                                child: ValueListenableBuilder<List<DataPoint>>(
                                  valueListenable: ValueNotifier(
                                    widget.dataManager.currentData,
                                  ),
                                  builder: (context, data, _) {
                                    return BuildCharts(
                                      unit: 'A',
                                      data: data,
                                      color: Colors.green,
                                    );
                                  },
                                ),
                              ),
                              const Spacer1(),

                              //-------------------------------------------------------------------
                              Text(
                                "Active Power Chart (kW)",
                                style: GoogleFonts.poppins(
                                  fontSize: size.height / 43,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(31, 31, 31, 1),
                                ),
                              ),
                              const SpacerSmall(),
                              Container(
                                color: Colors.white70,
                                height: size.height / 2,
                                width: size.width,
                                child: ValueListenableBuilder<List<DataPoint>>(
                                  valueListenable: ValueNotifier(
                                    widget.dataManager.powerData,
                                  ),
                                  builder: (context, data, _) {
                                    return BuildCharts(
                                      unit: 'W',
                                      data: data,
                                      color: Colors.red,
                                    );
                                  },
                                ),
                              ),
                              const Spacer1(),

                              //-------------------------------------------------------------------
                              Text(
                                "Frequency Chart (Hz)",
                                style: GoogleFonts.poppins(
                                  fontSize: size.height / 43,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(31, 31, 31, 1),
                                ),
                              ),
                              const SpacerSmall(),
                              Container(
                                color: Colors.white70,
                                height: size.height / 2,
                                width: size.width,
                                child: ValueListenableBuilder<List<DataPoint>>(
                                  valueListenable: ValueNotifier(
                                    widget.dataManager.frequencyData,
                                  ),
                                  builder: (context, data, _) {
                                    return BuildCharts(
                                      unit: 'Hz',
                                      data: data,
                                      color: Colors.purple,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer1(),
                  //---------------------------------------------------------------------
                ],
              ),
            ),
          ],
        ),
        childCount: 1,
      ),
    );
  }
}
