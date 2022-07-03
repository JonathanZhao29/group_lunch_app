import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:group_lunch_app/shared/user_model.dart';

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
                  titleTextField('Add Title'),
                  //Add Text Inbetween these
                  Text('Date'),
                  titleTextField('Add Date'),
                  //Add Text Inbetween these
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Add People or Phone Numbers:'),
                  ),
                  dropdownSearchField('Add People or Phone Numbers'),
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
    decoration: InputDecoration(
      hintText: baseText,
      contentPadding: EdgeInsets.all(20.0),
    ),
  );
}

Widget dropdownSearchField(String baseText) {
  // return DropdownSearch<String>.multiSelection(
  //   items: [
  //     "Jonathan",
  //     "John Huang",
  //     "John Coulter",
  //     "919 919 9191",
  //     "Johns group"
  //   ],
  //   popupProps: PopupPropsMultiSelection.menu(
  //     showSelectedItems: true,
  //     //disabledItemFn: (String s) => s.startsWith('I'),
  //   ),
  //   onChanged: print,
  //   selectedItems: [],
  // );

  List<UserModel> listOfUsers = [
    UserModel(id: "001", name: "John", phoneNumber: "9199199191"),
    UserModel(id: "002", name: "Jonathan", phoneNumber: "1234567890")
  ];

  return DropdownSearch<UserModel>.multiSelection(
    //popupProps: PopupPropsMultiSelection.modalBottomSheet(
    //   showSelectedItems: true,
    //   showSearchBox: true,
    // ),
    dropdownDecoratorProps: DropDownDecoratorProps(
      dropdownSearchDecoration: InputDecoration(
        labelText: 'Names or Phone Numbers',
      ),
    ),
    //asyncItems: (String filter) => getData(filter),
    items: listOfUsers,
    itemAsString: (UserModel u) => u.userAsString(),
    onChanged: (List<UserModel?> data) => print(data),
    selectedItems: [],
  );
}
