import 'package:flutter/material.dart';

class CreateInvitePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EnterEventInfo();
  }
}

class EnterEventInfo extends StatefulWidget {
  const EnterEventInfo({Key? key}) : super(key: key);
  @override
  State<EnterEventInfo> createState() => _EnterEventInfoState();
}

class _EnterEventInfoState extends State<EnterEventInfo> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //User Inputs Information
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text('Title:'),
                  titleTextField('Title'),
                  //Add Text Inbetween these
                  Text('Date'),
                  titleTextField('Date'),
                  //Add Text Inbetween these
                  Text('Add People or Phone Numbers:'),
                  titleTextField('Add People or Phone Numbers'),
                  ElevatedButton(
                    onPressed: () {
                      // Enters if statement = form is valid
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Sending Invite...')),
                        );
                      }
                    },
                    child: const Text('Send Invite!'), //Or Send Icon
                  ),
                ],
              ))
        ],
      ),
    );
  }
}

Widget titleTextField(String baseText) {
  return TextFormField(
    // The validator receives the text that the user has entered.
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter ' + baseText + ' here';
      }
      return null;
    },
    decoration: InputDecoration(hintText: baseText),
  );
}


//Text Button For Submit
// TextButton(
//   onPressed: () {
//     Navigator.pop(context);
//   },
//   child: const Text('Send!'), //Or Send Icon Here
// ),
