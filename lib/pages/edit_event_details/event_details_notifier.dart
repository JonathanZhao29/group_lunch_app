import 'package:group_lunch_app/pages/base_notifier.dart';
import 'package:group_lunch_app/services/firestore_service.dart';

import '../../models/event_model.dart';
import '../../services/locator.dart';

class EventDetailsNotifier extends BaseNotifier {
  final _fireStoreService = locator<FirestoreService>();

  final String eventId;

  late final Stream<Future<EventModel>> eventModelStream;
  late final EventModel eventModel;
  bool initialized = false;
  EventModel? updatedEventModel;

  bool editing = false;

  EventDetailsNotifier({required this.eventId}) {
    eventModelStream = _fireStoreService.getEventModelStream(eventId);
    eventModelStream.listen(eventModelListener);
    eventModelStream.first.then(
        (result) async {
          eventModel = await result;
          initialized = true;
          notifyListeners();
        }
    );
  }

  void eventModelListener(Future<EventModel> eventModelFuture) async {
    updatedEventModel = await eventModelFuture;
    notifyListeners();
  }

}