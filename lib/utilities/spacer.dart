import 'package:flutter/material.dart';

class SpacerUltraSmall extends StatelessWidget {
  const SpacerUltraSmall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(height: size.height / 50000);
  }
}

class SpacerSmall extends StatelessWidget {
  const SpacerSmall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(height: size.height / 200);
  }
}

class Spacer0 extends StatelessWidget {
  const Spacer0({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(height: size.height / 90);
  }
}

class Spacer1 extends StatelessWidget {
  const Spacer1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(height: size.height / 55);
  }
}

class Spacer2 extends StatelessWidget {
  const Spacer2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(height: size.height / 35);
  }
}

class Spacer3 extends StatelessWidget {
  const Spacer3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(height: size.height / 20);
  }
}

class Spacer4 extends StatelessWidget {
  const Spacer4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(height: size.height / 15);
  }
}

class Spacer5 extends StatelessWidget {
  const Spacer5({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(height: size.height / 10);
  }
}

class SpacerLarge extends StatelessWidget {
  const SpacerLarge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(height: size.height / 4);
  }
}
