part of 'widgets.dart';

class EventList extends StatelessWidget {
  const EventList({Key? key, required this.eventIdList, this.onEventPressed}) : super(key: key);
  final List<String> eventIdList;
  final Function(EventModel)? onEventPressed;

  @override
  Widget build(BuildContext context) {
    print('EventList eventIdList = $eventIdList');
    return FutureBuilder(
      future: Future.wait(eventIdList.map(
              (eventId) => locator<FirestoreService>().fetchCompleteEventDataById(eventId))),
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Could not fetch event data. Try again later');
        }
        if (snapshot.hasData) {
          final eventData = (snapshot.data as List<EventModel?>);
          return ListView.builder(
            itemCount: eventData.length,
            itemBuilder: (_, index) {
              if(eventData[index] == null) {
                return Container();
              }
              return EventListTile(
                event: eventData[index]!,
                onEventSelected: onEventPressed,
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
  const EventListTile({Key? key, required this.event, this.onEventSelected}) : super(key: key);
  final EventModel event;
  final Function(EventModel)? onEventSelected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(event.eventName),
      onTap: (){
        onEventSelected?.call(event);
      },
    );
  }
}
