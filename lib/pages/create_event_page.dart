import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:group_lunch_app/models/user_model.dart';
import 'package:group_lunch_app/models/event_model.dart';
import 'package:group_lunch_app/services/firestore_service.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import '../services/locator.dart';

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
  final _firestoreService = locator<FirestoreService>();
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
  void initState() {
    super.initState();
    //Create the text editing controllers
    createTextEditingControllerList(numControllers, inputControllerList);
  }

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
    //User Inputs Information
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
        actions: [],
      ),
      body: Stack(
        children: <Widget>[
          Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  //Event Title
                  Text('Event Title'),
                  titleTextField('Add Title', inputControllerList[0]),
                  //Event Date
                  Text('Event Date'),
                  dateTextField('Add Date', inputControllerList[1]),

                  //TBD: Event Location, store in GeoPoint
                  Text('Event Location'),

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

                        //Print to Console Inputted Information
                        print("Event Title: " + inputControllerList[0].text);
                        print("Event Date: " + inputControllerList[1].text);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Sending Invite...')),
                        );
                      } else {
                        print("Form not valid");
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

  Future<bool> _createEvent(EventModel event, Iterable<String> invitedUsersList, Iterable<String> invitedPhoneNumbers) async {
    // Create event document in Firestore
    final eventId = await _firestoreService.createEvent(event);
    if (eventId == null) {
      return false;
    }
    // Add Event data to respective users
    final inviteResults = await Future.wait(
      [
        _firestoreService.updateUserEventsData(
            event.eventHost.id, {eventId: EventResponseStatus.ACCEPTED}),
      ]..addAll(
          event.eventInvites.map(
            (user) => _firestoreService.updateUserEventsData(
                user.id, {eventId: EventResponseStatus.TENTATIVE}),
          ),
        ),
    );
    final successfulInvites = inviteResults.where((val) => val).length;
    print('createEvent successful invites = $successfulInvites | failedInvites = ${inviteResults.length - successfulInvites}');
    return successfulInvites > 0;
    //TODO: send push notification to invited users

    //TODO: Send invites to phone numbers that don't have an account
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

//In The Works
Widget dateTextField(String baseText, TextEditingController inputController) {
  //Current time used as a start time
  var currentDay = DateTime.now().subtract(const Duration(days: 1));
  //Current time increased by 1 year used as end time
  var lastDayAllowed = DateTime(2100);
  //Create DateTimeField
  return DateTimeField(
    format: DateFormat("EEEE MMM dd, ").add_jm(),
    onShowPicker: (context, currentValue) async {
      final date = await showDatePicker(
          context: context,
          firstDate: currentDay,
          initialDate: DateTime.now(),
          lastDate: lastDayAllowed);
      if (date != null) {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
        );
        //Return Date/Time string to inputController
        inputController.text = DateTimeField.combine(date, time).toString();
        return DateTimeField.combine(date, time);
      } else {
        //Return Date string to inputController
        inputController.text = currentValue.toString();
        return currentValue;
      }
    },
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
