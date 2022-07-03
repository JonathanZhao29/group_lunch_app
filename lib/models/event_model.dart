import 'user_model.dart';

class EventModel {
  final String eventName;
  final String? eventDescription;
  final DateTime? eventTimeStart;
  final DateTime? eventTimeEnd;
  final DateTime? eventTimeDuration;
  final DateTime eventCreationTime;
  final UserModel eventHost;
  final List<UserModel> eventInvites;
  final List<UserModel> eventAccepts;
  final List<UserModel> eventDeclines;
  final List<UserModel> eventUndecided;
  final bool isEventActive;

  EventModel(
      {required this.eventName,
      this.eventDescription,
      this.eventTimeStart,
      this.eventTimeEnd,
      this.eventTimeDuration,
      required this.eventCreationTime,
      required this.eventHost,
      required this.eventInvites,
      required this.eventAccepts,
      required this.eventDeclines,
      required this.eventUndecided,
      required this.isEventActive});

  @override
  String toString() => eventName;
}
