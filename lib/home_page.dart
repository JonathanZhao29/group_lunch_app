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
    );
  }

  void _navigateToCreateInvitePage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CreateInvitePage()));
  }
}
