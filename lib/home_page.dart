import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'create_invite_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextButton.styleFrom(primary: Theme.of(context).colorScheme.onPrimary);
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Main Page'),
        actions: <Widget>[
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
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CreateInvitePage()));
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
