import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showInfoDialog(BuildContext context, String title, String message) {
  showDialog(
      context: context,
      builder: (context) {
        Widget titleWidget = Text(title,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ));
        Widget contentWidget = Text(message,
            style: TextStyle(
              fontSize: 16,
            ));
        List<Widget> actionsList = [
          TextButton(
            child: Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ];

        if (Platform.isIOS) {
          return CupertinoAlertDialog(
            title: titleWidget,
            content: contentWidget,
            actions: actionsList,
          );
        }
        return AlertDialog(
          title: titleWidget,
          content: contentWidget,
          actions: actionsList,
        );
      });
}
