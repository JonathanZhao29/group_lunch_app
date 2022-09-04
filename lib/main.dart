import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_lunch_app/pages/authentication_page/auth_notifier.dart';
import 'package:group_lunch_app/pages/loading_page.dart';
import 'package:group_lunch_app/services/firestore_service.dart';
import 'package:group_lunch_app/services/locator.dart';
import 'package:group_lunch_app/services/navigation_service.dart';
import 'package:group_lunch_app/services/authentication_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:group_lunch_app/shared/strings.dart';
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
            case ConnectionState.done:
              print('connectionState.done');
              content = AuthStreamListener(
                stream: locator<AuthenticationService>().authSubscription,
                child: MaterialApp(
                  title: 'Group Lunch App',
                  theme: ThemeData(
                    primarySwatch: Colors.green,
                  ),
                  navigatorKey: locator<NavigationService>().navigationKey,
                  onGenerateRoute: routeFactory,
                  initialRoute: LoadingPageRoute,
                ),
              );
              break;
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
            default:
              print('ConnectionState = ${snapshot.connectionState}');
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
  final FirestoreService _firestoreService = locator<FirestoreService>();

  @override
  initState() {
    super.initState();
    _listen();
  }

  _listen() {
    _subscription = widget.stream.listen(
      (User? user) async {
        _authService.updateUser(user);
        if (user == null) {
          print("User signed out!");
          _navService.navigateToAndReplaceAll(AuthenticationPageRoute);
        } else {
          print("User signed in! AuthUser = $user");
          if (_authService.isPhoneVerified()) {
            final userModel = await _firestoreService.getLoggedInUser();
            print('login userModel = $userModel');
            if(userModel == null) await _firestoreService.createUserData(user);
            _navService.navigateToAndReplaceAll(HomePageRoute);
            return;
          }
          _navService.navigateToAndReplaceAll(AuthenticationPageRoute, arguments: {
            INITIAL_AUTH_MODE_ARGUMENT_KEY: AuthMode.verificationMode,
          });

        }
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
