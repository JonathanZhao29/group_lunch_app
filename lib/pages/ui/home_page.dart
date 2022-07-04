import 'package:flutter/material.dart';
import 'package:group_lunch_app/services/authentication_service.dart';
import 'package:group_lunch_app/services/locator.dart';
import 'package:group_lunch_app/services/navigation_service.dart';
import 'package:group_lunch_app/shared/routes.dart';

import '../../models/user_model.dart';
import '../../services/firestore_service.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NavigationService _navService = locator<NavigationService>();
  final AuthenticationService _authService = locator<AuthenticationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();

  UserModel user = UserModel.defaultUser;

  @override
  void initState() {
    super.initState();
    _firestoreService.getLoggedInUser().then(
      (userModel) {
        if (!mounted) return;
        setState(() {
          if (userModel != null) user = userModel;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    TextButton.styleFrom(primary: Theme.of(context).colorScheme.onPrimary);
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${user.displayName}'),
        actions: [
          IconButton(
            icon: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 30,
              child: Icon(Icons.add),
            ),
            onPressed: () {
              //Creates new group invite
              _navigateToCreateInvitePage(context);
              print('New Invite Button Pressed');
            },
          ),
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                _authService.logOut();
              })
        ],
      ),
      body: Column(
        //List of Current Invites/group chats
        children: [
          invitePageButton("0001", "John Huang"),
          invitePageButton("0002", "Jonny"),
          invitePageButton("0003", "John C")
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
      ),
    );
  }

  void _navigateToCreateInvitePage(BuildContext context) {
    _navService.navigateTo(InvitePageRoute);
  }
}

Widget invitePageButton(String uuid, String inviteName) {
  //uuid and inviteName are stand in vars for future database info
  return Container(
    child: Column(
      children: [
        Padding(padding: EdgeInsets.fromLTRB(30, 30, 30, 0)),
        TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.hovered))
                    return Colors.blue.withOpacity(0.06);
                  if (states.contains(MaterialState.focused) ||
                      states.contains(MaterialState.pressed))
                    return Colors.blue.withOpacity(0.15);
                  return null; // Defer to the widget's default.
                },
              ),
            ),
            onPressed: () {
              //Enter invite
            },
            child: Align(
                //Pull data from database later on and present it here
                alignment: Alignment.centerLeft,
                child: Text(
                  inviteName,
                  textAlign: TextAlign.left,
                ))),
        Padding(padding: EdgeInsets.fromLTRB(30, 30, 30, 0)),
      ],
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
    ),
    decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
  );
}
