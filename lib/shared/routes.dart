import 'package:flutter/material.dart';
import 'package:group_lunch_app/home_page.dart';
import 'package:group_lunch_app/pages/ui/authentication_page.dart';

const String AuthenticationPageRoute = "auth";
const String HomePageRoute = "home";

Route<dynamic> routeFactory(RouteSettings settings){
  PageRoute route;
  switch(settings.name){
    case AuthenticationPageRoute:
      route = _getRoute(name: settings.name!, view: AuthenticationPage(initialMode: (settings.arguments as Map?)?['initialMode'],));
      break;
    case HomePageRoute:
      route = _getRoute(name: settings.name!, view: HomePage());
      break;
    default:
      route = MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text('No route defined for ${settings.name}'),
          )
        )
      );
  }
  return route;
}

PageRoute _getRoute({required String name, required Widget view}){
  return MaterialPageRoute(
      settings: RouteSettings(
          name: name
      ),
      builder: (_) => view
  );
}
