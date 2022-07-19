import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:group_lunch_app/shared/user_model.dart';
import 'package:group_lunch_app/shared/event_model.dart';

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
  final numControllers = 2;
  //For Event Info
  List<TextEditingController> inputControllerList = [];
  // Create text editing controllers
  void createTextEditingControllerList(
      int numControllers, List<TextEditingController> controllers) {
    for (int i = 0; i < numControllers; i++) {
      TextEditingController controller = TextEditingController();
      controllers.add(controller);
    }
  }

  //For Participant Info
  List<UserModel> invitees = [];

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    for (TextEditingController controller in inputControllerList) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Create the text editing controllers
    createTextEditingControllerList(numControllers, inputControllerList);
    //User Inputs Information
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  titleTextField('Add Title', inputControllerList[0]),
                  //Add Text Inbetween these
                  Text('Date'),
                  titleTextField('Add Date', inputControllerList[1]),
                  //Add Text Inbetween these
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Add People or Phone Numbers:'),
                  ),
                  dropdownSearchField('Add People or Phone Numbers', invitees),
                  ElevatedButton(
                    onPressed: () {
                      // Enters if statement = form is valid
                      if (_formKey.currentState!.validate()) {
                        //Create event with inputted information

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

//try .map??? to get text, creates a function for each element in list that returns an iterable
Widget titleTextField(String baseText, TextEditingController inputController) {
  return TextFormField(
    controller: inputController,
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

Widget dropdownSearchField(String baseText, List<UserModel> invitees) {
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
    selectedItems: invitees,
  );
}
