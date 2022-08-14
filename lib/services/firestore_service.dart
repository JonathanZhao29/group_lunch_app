import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:group_lunch_app/models/event_model.dart';
import 'package:group_lunch_app/models/user_model.dart';
import 'package:group_lunch_app/services/authentication_service.dart';
import 'package:group_lunch_app/shared/strings.dart';

import 'locator.dart';

/// Handles all Firestore interaction
class FirestoreService {
  final _db = FirebaseFirestore.instance;
  final AuthenticationService _authService = locator<AuthenticationService>();
  static const ERROR_HEADER = 'FirestoreService - Error:';
  static const USER_COLLECTION_PATH = 'users';
  static const EVENT_COLLECTION_PATH = 'events';

  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  /// returns [True] if user is successfully created
  /// returns [False] if user already exists or creation fails
  Future<bool> createUserData(User newUser) async {
    final docRef = _db.collection(USER_COLLECTION_PATH).doc(newUser.uid);
    docRef.get().then((doc) {
      if (doc.exists) return false;
    });
    return docRef.set({
      USER_CREATED_AT_KEY: DateTime.now(),
      USER_PHONE_NUMBER_KEY: newUser.phoneNumber,
    }).then(
      (_) => true,
      onError: (e, s) {
        print('$ERROR_HEADER createUserData failed: $e - $s');
        return false;
      },
    );
  }

  /// get UserModel of logged in user
  /// and set currentUser to newly fetched user
  Future<UserModel?> getLoggedInUser() async {
    print('getLoggedInUser currentUser = ${_authService.currentUser}');
    if (_authService.currentUser == null) return null;
    final user = await fetchUserData(_authService.currentUser!.uid);
    _currentUser = user;
    return user;
  }

  /// get UserModel corresponding to [userId]
  Future<UserModel?> fetchUserData(String userId) async {
    print('fetchUserData userId = $userId');
    final docRef = _db.collection(USER_COLLECTION_PATH).doc(userId);
    return docRef.get().then(
      (doc) {
        if (!doc.exists || doc.data() == null) return null;
        final data = doc.data() as Map<String, dynamic>;
        data.addAll({USER_ID_KEY: userId});
        print('fetchUserData data = $data');
        return UserModel.fromMap(data);
      },
      onError: (e, s) {
        print('$ERROR_HEADER fetchUserData failed: $e - $s');
        return null;
      },
    );
  }

  /// return [True] if update is successful
  /// return [False] otherwise
  Future<bool> updateUserData(UserModel userData) async {
    final docRef = _db.collection(USER_COLLECTION_PATH).doc(userData.id);
    return docRef.update(userData.toMap()).then(
      (_) => true,
      onError: (e, s) {
        print('$ERROR_HEADER updateUserData failed: $e - $s');
        return false;
      },
    );
  }

  /// Updates events data for specified user
  Future<bool> updateUserEventsData(String userId, Map<String, EventResponseStatus> events) async {
    print('FirestoreService updateUserEventsData userId = $userId | events = $events');
    final docRef = _db.collection(USER_COLLECTION_PATH).doc(userId);
    final newData = events.map((key, val) => MapEntry('$USER_EVENT_ID_LIST_KEY.$key', val.toKey()));
    await docRef.update(newData).onError((e, s){
      print('$ERROR_HEADER updateUserEventsData failed: $e - $s');
      return false;
    });
    return true;
  }

  /** Event related functions **/

  /// Fetch event data and populate invitee list with user data
  Future<EventModel?> fetchCompleteEventDataById(String eventId) async {
    try {
      print('fetchCompleteEventDataById eventId = $eventId');
      final eventDoc = await _db.collection(EVENT_COLLECTION_PATH).doc(eventId).get();
      if (!eventDoc.exists || eventDoc.data() == null) {
        print('$ERROR_HEADER fetchEventDataById doc.exists = ${eventDoc.exists} eventDoc = ${eventDoc.data()}');
        return null;
      }
      final eventData = eventDoc.data() as Map<String, dynamic>;
      eventData.addAll({EVENT_ID_KEY: eventId});
      eventData[EVENT_DURATION_TIME_KEY] = (eventData[EVENT_END_TIME_KEY]
              as Timestamp)
          .toDate()
          .difference((eventData[EVENT_END_TIME_KEY] as Timestamp).toDate());
      final participantMap = eventData[EVENT_PARTICIPANTS_KEY];
      final userList = await Future.wait([
        fetchUserData(eventData[EVENT_HOST_ID_KEY])
      ]
        ..addAll((participantMap[EventResponseStatus.ACCEPTED.toKey()] as Map<String, dynamic>?)?.keys
                .map((userId) => fetchUserData(userId)) ??
            [])
        ..addAll((participantMap[EventResponseStatus.DECLINED.toKey()] as Map<String, dynamic>?)
                ?.keys
                .map((userId) => fetchUserData(userId)) ??
            [])
        ..addAll((participantMap[EventResponseStatus.TENTATIVE.toKey()] as Map<String, dynamic>?)
                ?.keys
                .map((userId) => fetchUserData(userId)) ??
            []));
      eventData[EVENT_HOST_DATA_KEY] = userList.removeAt(0);
      eventData[EVENT_INVITED_USERS_KEY] = List.from(userList);
      final int acceptedUsersLength =
          participantMap[EventResponseStatus.ACCEPTED.toKey()]?.length ?? 0;
      final int declinedUsersLength =
          participantMap[EventResponseStatus.DECLINED.toKey()]?.length ?? 0;
      eventData[EVENT_ACCEPTED_USERS_KEY] = userList
          .sublist(0, acceptedUsersLength);
      eventData[EVENT_DECLINED_USERS_KEY] = userList
          .sublist(
              acceptedUsersLength, acceptedUsersLength + declinedUsersLength);
      eventData[EVENT_TENTATIVE_USERS_KEY] = userList
          .sublist(acceptedUsersLength + declinedUsersLength);
      return EventModel.fromMap(eventData);
    } catch (e, s) {
      print('$ERROR_HEADER fetchEventDataById failed: $e - $s');
      return null;
    }
  }

  /// Add/update a list of users and their event response status
  Future<bool> addOrUpdateUserEventResponse(String eventId,
      Iterable<String> userIdList, EventResponseStatus status) async {
    final eventDocRef = _db.collection(EVENT_COLLECTION_PATH).doc(eventId);
    final otherStatuses = EventResponseStatus.values..remove(status);
    // Generate map of all new data
    final newData =
        userIdList.fold<Map<String, Object>>({}, (currentMap, userId) {
      // Add/update entry in map with corresponding [status]
      final Map<String, Object> currentUserData = {
        '$EVENT_PARTICIPANTS_KEY.$status.$userId': FieldValue.serverTimestamp(),
      };
      // Delete entries in other maps
      currentUserData.addEntries(otherStatuses.map((otherStatus) => MapEntry(
          '$EVENT_PARTICIPANTS_KEY.$otherStatus.$userId',
          FieldValue.delete())));
      currentMap.addAll(currentUserData);
      return currentMap;
    });
    // send updated data to firestore
    return eventDocRef.update(newData).then((_) {
      return true;
    }, onError: (e, s) {
      print('$ERROR_HEADER addOrUpdateUserEventResponse failed: $e - $s');
      return false;
    });
  }

  /// Creates new event document in firestore from EventModel object.
  /// Participant data initialized to empty for all response types.
  /// Use [FirestoreService.addOrUpdateUserEventResponse] to set participant data
  Future<String?> createEvent(EventModel event) async {
    final eventsCollection = _db.collection(EVENT_COLLECTION_PATH);
    final eventData = event.toMap();
    // Generate empty map of participant data
    eventData[EVENT_PARTICIPANTS_KEY] = EventResponseStatus.values
        .fold<Map<String, Map<String, Timestamp>>>({}, (currentMap, status) {
      currentMap.addAll({status.toKey(): {}});
      return currentMap;
    });
    return eventsCollection.add(eventData).then((docRef) {
      return docRef.id;
    }, onError: (e, s) {
      print('$ERROR_HEADER createEvent failed: $e - $s');
      return null;
    });
  }
}
