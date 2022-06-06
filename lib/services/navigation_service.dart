import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  void pop(){
    return _navigationKey.currentState?.pop();
  }

  // Adds on top of current navigation stack
  Future<dynamic>? navigateTo(String routeName, {dynamic arguments}){
    return _navigationKey.currentState?.pushNamed(routeName, arguments: arguments);
  }

  // Replaces top nav page
  Future<dynamic>? navigateReplaceTo(String routeName, {dynamic arguments}){
    return _navigationKey.currentState?.pushReplacementNamed(routeName, arguments: arguments);
  }

  // Replaces entire nav stack
  Future<dynamic>? navigateToAndReplaceAll(String routeName, {dynamic arguments}){
    return _navigationKey.currentState?.pushNamedAndRemoveUntil(routeName, (Route route) => false);
  }
}