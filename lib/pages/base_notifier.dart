import 'package:flutter/material.dart';

class BaseNotifier extends ChangeNotifier {

  bool _busy = false;
  bool get busy => _busy;
  void setBusy(bool value){
    _busy = value;
    notifyListeners();
  }
}