import 'package:flutter/foundation.dart';

class FaultStatusProvider extends ChangeNotifier {
  bool _faultDetected = false;
  String _faultMessage = "No fault";

  bool get faultDetected => _faultDetected;
  String get faultMessage => _faultMessage;

  void updateStatus(bool detected, String message) {
    _faultDetected = detected;
    _faultMessage = message;
    notifyListeners();
  }
}
