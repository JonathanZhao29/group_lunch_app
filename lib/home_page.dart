import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  //const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        TextButton.styleFrom(primary: Theme.of(context).colorScheme.onPrimary);
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Main Page'),
        actions: <Widget>[
          TextButton(
            style: style,
            onPressed: () {},
            child: const Text('New Invite!'),
          ),
        ],
      ),
    );
  }
}
