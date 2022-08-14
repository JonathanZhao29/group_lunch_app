part of 'widgets.dart';

class EventList extends StatelessWidget {
  const EventList({Key? key, required this.eventIdList, this.onEventPressed})
      : super(key: key);
  final Map<String, EventResponseStatus> eventIdList;
  final Function(EventModel, EventResponseStatus)? onEventPressed;

  @override
  Widget build(BuildContext context) {
    print('EventList eventIdList = $eventIdList');
    return FutureBuilder(
      future: Future.wait(eventIdList.keys.map((eventId) =>
          eventIdList[eventId] != EventResponseStatus.DECLINED
              ? locator<FirestoreService>().fetchCompleteEventDataById(eventId)
              : Future.value(null))),
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          print('EvenList future builder error: ${snapshot.error}');
          return Text('Could not fetch event data. Try again later');
        }
        if (snapshot.hasData) {
          final eventData = (snapshot.data as List<EventModel?>);
          return ListView.builder(
            itemCount: eventData.length,
            itemBuilder: (_, index) {
              if (eventData[index] == null) {
                return Container();
              }
              return EventListTile(
                event: eventData[index]!,
                onEventSelected: onEventPressed,
                eventResponseStatus: eventIdList[eventData[index]!.id]!,
              );
            },
          );
        }
        return Text('Error reached');
      },
    );
  }
}

class EventListTile extends StatelessWidget {
  const EventListTile({Key? key, required this.event, required this.eventResponseStatus, this.onEventSelected})
      : super(key: key);
  final EventModel event;
  final EventResponseStatus eventResponseStatus;
  final Function(EventModel, EventResponseStatus)? onEventSelected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${event.eventName} - ${eventResponseStatus.toKey()}'),
      onTap: () {
        onEventSelected?.call(event, eventResponseStatus);
      },
    );
  }
}
