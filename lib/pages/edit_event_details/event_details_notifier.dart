import 'package:group_lunch_app/pages/base_notifier.dart';
import 'package:group_lunch_app/services/firestore_service.dart';

import '../../models/event_model.dart';
import '../../services/locator.dart';

class EventDetailsNotifier extends BaseNotifier {
  final _fireStoreService = locator<FirestoreService>();
  EventDetailsNotifier({required this.eventId}) {
    eventModelStream = _fireStoreService.getEventModelStream(eventId);
    eventModelStream.listen(eventModelListener);
  }
  late final Stream<Future<EventModel>> eventModelStream;
  final String eventId;
  late final EventModel eventModel;

  void eventModelListener(Future<EventModel> eventModelFuture) async {
    eventModel = await eventModelFuture;
    notifyListeners();
  }

}