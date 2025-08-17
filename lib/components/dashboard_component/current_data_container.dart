import 'package:smartmeter/utilities/spacer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartmeter/pages/dashboard.dart';

class CurrentPowerSupplyContainer extends StatefulWidget {
  const CurrentPowerSupplyContainer({
    Key? key,
    required this.power,
    required this.frequency,
    required this.voltage,
    required this.current,
  }) : super(key: key);
  final String power;
  final String frequency;
  final String voltage;
  final String current;
  @override
  _CurrentPowerSupplyContainerState createState() =>
      _CurrentPowerSupplyContainerState();
}

class _CurrentPowerSupplyContainerState
    extends State<CurrentPowerSupplyContainer> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(252, 252, 252, 1),
        borderRadius: BorderRadius.all(Radius.circular(size.width / 40)),
      ),
      width: size.width - (size.width / 7),
      // height: size.height / 8,
      child: InkWell(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //---------------------------------------------------------------------
            const Spacer0(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                EachPowerParameter(
                  R: 249,
                  G: 87,
                  B: 0,
                  O: 1,
                  parameter: "  Voltage",
                  parameterValue: widget.voltage,
                  parameterUnit: " V",
                ),
                EachPowerParameter(
                  R: 0,
                  G: 32,
                  B: 63,
                  O: 1,
                  parameter: "  Active Power",
                  parameterValue: widget.power,
                  parameterUnit: " W",
                ),
              ],
            ),
            const Spacer2(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                EachPowerParameter(
                  R: 24,
                  G: 160,
                  B: 251,
                  O: 1,
                  parameter: "  Current",
                  parameterValue: widget.current,
                  parameterUnit: " A",
                ),
                EachPowerParameter(
                  R: 0,
                  G: 167,
                  B: 167,
                  O: 1,
                  parameter: "  Frequency",
                  parameterValue: widget.frequency,
                  parameterUnit: " Hz",
                ),
              ],
            ),

            const Spacer1(),
          ],
        ),
      ),
    );
  }
}
//----------------------------------------------------------------------

class EachPowerParameter extends StatelessWidget {
  const EachPowerParameter({
    Key? key,
    required this.R,
    required this.G,
    required this.B,
    required this.O,
    required this.parameter,
    required this.parameterValue,
    required this.parameterUnit,
  }) : super(key: key);

  final int R;
  final int G;
  final int B;
  final double O;
  final String parameter;
  final String parameterValue;
  final String parameterUnit;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
            text: parameterValue.toString(),
            style: GoogleFonts.poppins(
              fontSize: size.width / 15,
              fontWeight: FontWeight.w500,
              color: const Color.fromRGBO(31, 31, 31, 1),
            ),
            children: <TextSpan>[
              TextSpan(
                text: parameterUnit.toString(),
                style: GoogleFonts.poppins(
                  fontSize: size.width / 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
        const SpacerSmall(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 4,
              backgroundColor: Color.fromRGBO(R, G, B, O),
            ),
            Text(
              parameter,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(57, 57, 57, 1),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
