// ignore_for_file: must_be_immutable

import 'package:smartmeter/utilities/spacer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../service/fault_status_provider.dart';

import '../../pages/dashboard.dart';

bool meterState = true;

class EnergyConsumptionContainer extends StatefulWidget {
  const EnergyConsumptionContainer({Key? key, required this.energy})
    : super(key: key);
  // final RealTimeDataManager dataManager;
  final String energy;
  @override
  _EnergyConsumptionContainerState createState() =>
      _EnergyConsumptionContainerState();
}

class _EnergyConsumptionContainerState
    extends State<EnergyConsumptionContainer> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(24, 160, 251, 0.08),
        borderRadius: BorderRadius.all(Radius.circular(size.width / 40)),
      ),
      width: size.width / 2.42,
      //height: size.height / 4,
      child: InkWell(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width / 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Spacer0(),
              CircleAvatar(
                radius: size.width / 20,
                backgroundColor: const Color.fromRGBO(24, 160, 251, 0.12),
                child: Icon(
                  CupertinoIcons.bolt,
                  color: const Color.fromRGBO(24, 160, 251, 1),
                  size: size.width / 12,
                ),
              ),
              const Spacer2(),
              SizedBox(
                width: size.width,
                child: Text(
                  "Energy Consumption",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(24, 160, 251, 1),
                  ),
                ),
              ),
              const Spacer1(),
              RichText(
                text: TextSpan(
                  text: widget.energy,
                  style: GoogleFonts.poppins(
                    fontSize: size.width / 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),

                  children: <TextSpan>[
                    TextSpan(
                      text: " W/h  ",
                      style: GoogleFonts.poppins(
                        fontSize: size.width / 25,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer1(),
            ],
          ),
        ),
      ),
    );
  }
}

//------------------------------*********************-----------------------------

class MetersDetailsContainer extends StatefulWidget {
  const MetersDetailsContainer({Key? key}) : super(key: key);

  @override
  _MetersDetailsContainerState createState() => _MetersDetailsContainerState();
}

class _MetersDetailsContainerState extends State<MetersDetailsContainer> {
  @override
  Widget build(BuildContext context) {
    final faultStatus = Provider.of<FaultStatusProvider>(context);
    final bool faultDetected = faultStatus.faultDetected;

    Size size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(0, 167, 167, 0.08),
        borderRadius: BorderRadius.all(Radius.circular(size.width / 40)),
      ),
      width: size.width / 2.42,
      //height: size.height / 4,
      child: InkWell(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width / 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Spacer0(),
              CircleAvatar(
                radius: size.width / 20,
                backgroundColor: const Color.fromRGBO(0, 167, 167, 0.12),
                child: Icon(
                  CupertinoIcons.antenna_radiowaves_left_right,
                  color: const Color.fromRGBO(0, 167, 167, 1),
                  size: size.width / 12,
                ),
              ),
              const Spacer2(),
              SizedBox(
                width: size.width,
                child: Text(
                  "Meter Connection State",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(0, 167, 167, 1),
                  ),
                ),
              ),
              const Spacer2(),
              Row(
                children: [
                  Icon(
                    meterState
                        ? CupertinoIcons.dot_radiowaves_right
                        : CupertinoIcons.wifi_slash,
                    color: meterState
                        ? const Color.fromRGBO(0, 167, 167, 0.5)
                        : Colors.redAccent.withOpacity(0.5),
                  ),
                  Text(
                    meterState ? " Active" : " Inactive",
                    style: TextStyle(
                      color: Colors.black87,
                      fontFamily: 'Poppins',
                      fontSize: size.width / 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const Spacer1(),
            ],
          ),
        ),
      ),
    );
  }
}
