import 'package:flutter/material.dart';
import 'package:group_lunch_app/pages/edit_event_details/event_details_notifier.dart';
import 'package:provider/provider.dart';


/// Requires [EventDetailsNotifier] to be above in the tree
class EditEventPage extends StatefulWidget {
  const EditEventPage({Key? key}) : super(key: key);

  @override
  State<EditEventPage> createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {

  late final EventDetailsNotifier notifier;

  @override
  void initState() {
    super.initState();
    notifier = Provider.of<EventDetailsNotifier>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
