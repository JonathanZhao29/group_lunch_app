import 'package:flutter/material.dart';
import 'package:group_lunch_app/pages/ui/create_invite_page.dart';
import 'package:group_lunch_app/pages/ui/home_page.dart';
import 'package:group_lunch_app/pages/ui/authentication_page.dart';

import '../pages/ui/loading_page.dart';

const String AuthenticationPageRoute = "auth";
const String HomePageRoute = "home";
const String InvitePageRoute = "invite";
const String LoadingPageRoute = "loading";

Route<dynamic> routeFactory(RouteSettings settings) {
  PageRoute route;
  switch (settings.name) {
    case AuthenticationPageRoute:
      route = _getRoute(
          name: settings.name!,
          view: AuthenticationPage(
            initialMode: (settings.arguments as Map?)?['initialMode'],
          ));
      break;
    case HomePageRoute:
      route = _getRoute(name: settings.name!, view: HomePage());
      break;
    case InvitePageRoute:
      route = _getRoute(name: settings.name!, view: CreateInvitePage());
      break;
    case LoadingPageRoute:
      route = _getRoute(name: settings.name!, view: LoadingPage());
      break;
    default:
      route = MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        ),
      );
  }
  return route;
}

PageRoute _getRoute({required String name, required Widget view}) {
  return MaterialPageRoute(
      settings: RouteSettings(name: name), builder: (_) => view);
}
