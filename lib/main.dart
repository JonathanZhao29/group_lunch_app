import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_lunch_app/pages/ui/loading_page.dart';
import 'package:group_lunch_app/services/locator.dart';
import 'package:group_lunch_app/services/navigation_service.dart';
import 'package:group_lunch_app/services/authentication_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/ui/home_page.dart';
import './shared/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<FirebaseApp> initialize() async {
    var result = await Firebase.initializeApp();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initialize(),
        builder: (context, snapshot) {
          Widget content;
          switch (snapshot.connectionState) {
            // case ConnectionState.none:
            //   break;
            // case ConnectionState.waiting:
            //   break;
            // case ConnectionState.active:
            //   break;
            case ConnectionState.done:
              content = AuthStreamListener(
                stream: locator<AuthenticationService>().authSubscription,
                child: MaterialApp(
                  title: 'Group Lunch App',
                  theme: ThemeData(
                    primarySwatch: Colors.green,
                  ),
                  navigatorKey: locator<NavigationService>().navigationKey,
                  onGenerateRoute: routeFactory,
                  initialRoute: HomePageRoute,
                ),
              );
              break;
            default:
              content = MaterialApp(
                home: LoadingPage(),
              );
          }
          return content;
        });
  }
}

class AuthStreamListener extends StatefulWidget {
  const AuthStreamListener(
      {required this.stream, required this.child, Key? key})
      : super(key: key);
  final Stream<User?> stream;
  final Widget child;

  @override
  State<AuthStreamListener> createState() => _AuthStreamListenerState();
}

class _AuthStreamListenerState extends State<AuthStreamListener> {
  late StreamSubscription _subscription;
  final NavigationService _navService = locator<NavigationService>();
  final AuthenticationService _authService = locator<AuthenticationService>();

  @override
  initState() {
    super.initState();
    _listen();
  }

  _listen() {
    _subscription = widget.stream.listen(
      (User? user) {
        if (user == null) {
          print("User signed out!");
          _navService.navigateToAndReplaceAll(AuthenticationPageRoute);
        } else {
          print("User signed in!");
          if (_authService.isPhoneVerified()) {
            _navService.navigateToAndReplaceAll(HomePageRoute);
          }
        }
        _authService.updateUser();
      },
    );
  }

  @override
  void didUpdateWidget(AuthStreamListener oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stream != widget.stream) {
      _subscription.cancel();
      _listen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    print("StreamListener Disposed!");
    _subscription.cancel();
    super.dispose();
  }
}
