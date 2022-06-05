import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  void pop(){
    return _navigationKey.currentState?.pop();
  }

  Future<dynamic>? navigateTo(String routeName, {dynamic arguments}){
    return _navigationKey.currentState?.pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic>? navigateReplaceTo(String routeName, {dynamic arguments}){
    return _navigationKey.currentState?.pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic>? navigateToAndReplaceAll(String routeName, {dynamic arguments}){
    return _navigationKey.currentState?.pushNamedAndRemoveUntil(routeName, (Route route) => false);
  }
}