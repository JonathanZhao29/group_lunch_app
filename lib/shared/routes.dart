import 'package:flutter/material.dart';
import 'package:group_lunch_app/pages/create_event_page.dart';
import 'package:group_lunch_app/pages/edit_event_details/edit_event_page.dart';
import 'package:group_lunch_app/pages/home_page.dart';
import 'package:group_lunch_app/pages/authentication_page/authentication_page.dart';
import 'package:group_lunch_app/pages/loading_page.dart';
import 'package:group_lunch_app/shared/strings.dart';
import 'package:provider/provider.dart';

import '../pages/edit_event_details/event_details_notifier.dart';

/// Arguments: [INITIAL_AUTH_MODE_ARGUMENT_KEY]
const String AuthenticationPageRoute = "auth";
const String HomePageRoute = "home";
const String InvitePageRoute = "invite";
const String LoadingPageRoute = "loading";

/// Arguments: [EVENT_ID_ARGUMENT_KEY]
const String EditEventPageRoute = "edit_event_details";

Route<dynamic> routeFactory(RouteSettings settings) {
  PageRoute route;
  switch (settings.name) {
    case AuthenticationPageRoute:
      route = _getRoute(
          name: settings.name!,
          view: AuthenticationPage(
            initialMode: (settings.arguments as Map?)?[INITIAL_AUTH_MODE_ARGUMENT_KEY],
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
    case EditEventPageRoute:
      route = _getRoute(
          name: settings.name!,
          view: ChangeNotifierProvider(
            create: (_) => EventDetailsNotifier(
                eventId: (settings.arguments as Map?)?[EVENT_ID_ARGUMENT_KEY]),
            builder: (context, child) => EditEventPage(),
          ));
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
