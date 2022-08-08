import 'package:group_lunch_app/shared/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_model.dart';

class EventModel {
  final String id;
  final String eventName;
  final String? eventDescription;
  final DateTime? eventTimeStart;
  final DateTime? eventTimeEnd;
  final Duration? eventTimeDuration;
  final DateTime eventCreationTime;
  final UserModel eventHost;
  final List<UserModel> eventInvites;
  final List<UserModel> eventAccepts;
  final List<UserModel> eventDeclines;
  final List<UserModel> eventUndecided;
  final bool isEventActive;
  final GeoPoint? eventLocation;

  EventModel(
      {required this.id,
      required this.eventName,
      this.eventDescription,
      this.eventTimeStart,
      this.eventTimeEnd,
      this.eventTimeDuration,
      this.eventLocation,
      required this.eventCreationTime,
      required this.eventHost,
      required this.eventInvites,
      required this.eventAccepts,
      required this.eventDeclines,
      required this.eventUndecided,
      required this.isEventActive});

  @override
  String toString() => eventName;

  static EventModel fromMap(Map<String, dynamic> data) {
    return EventModel(
      id: data[EVENT_ID_KEY],
      eventName: data[EVENT_NAME_KEY],
      eventCreationTime: data[EVENT_CREATED_AT_KEY],
      eventHost: data[EVENT_HOST_DATA_KEY],
      isEventActive: data[EVENT_ACTIVE_KEY],
      eventInvites: data[EVENT_INVITED_USERS_KEY],
      eventAccepts: data[EVENT_ACCEPTED_USERS_KEY],
      eventDeclines: data[EVENT_DECLINED_USERS_KEY],
      eventUndecided: data[EVENT_TENTATIVE_USERS_KEY],
      eventDescription: data[EVENT_DESCRIPTION_KEY],
      eventTimeStart: data[EVENT_START_TIME_KEY],
      eventTimeEnd: data[EVENT_END_TIME_KEY],
      eventTimeDuration: data[EVENT_DURATION_TIME_KEY],
        eventLocation: data[EVENT_LOCATION_KEY],
    );
  }

  /// Generates map holding all values of event
  /// Excludes participant data
  Map<String, dynamic> toMap() {
    return {
      EVENT_NAME_KEY: eventName,
      EVENT_CREATED_AT_KEY: eventCreationTime,
      EVENT_DESCRIPTION_KEY: eventDescription,
      EVENT_END_TIME_KEY: eventTimeEnd,
      EVENT_HOST_ID_KEY: eventHost.id,
      EVENT_START_TIME_KEY: eventTimeStart,
      EVENT_ACTIVE_KEY: isEventActive,
      EVENT_LOCATION_KEY: eventLocation,
    };
  }
}

enum EventResponseStatus {
  ACCEPTED,
  DECLINED,
  TENTATIVE,
}

extension Stringify on EventResponseStatus {
  String toKey() {
    String val;
    switch (this) {
      case EventResponseStatus.DECLINED:
        val = 'declined';
        break;
      case EventResponseStatus.ACCEPTED:
        val = 'accepted';
        break;
      case EventResponseStatus.TENTATIVE:
        val = 'tentative';
        break;
    }
    return val;
  }
}
