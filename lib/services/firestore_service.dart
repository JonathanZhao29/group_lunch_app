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
    final docRef = _db.collection(USER_COLLECTION_PATH).doc(userId);
    return docRef.get().then(
          (doc) {
        if (!doc.exists || doc.data() == null) return null;
        final data = doc.data() as Map<String, dynamic>;
        data.addAll({USER_ID_KEY: userId});
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

  /** Event related functions **/

  /// Fetch event data and populate invitee list with user data
  Future<EventModel?> fetchEventDataById(String eventId) async {
    final eventDocRef = _db.collection(EVENT_COLLECTION_PATH).doc(eventId);
    return eventDocRef.get().then(
          (eventDoc) async {
        if (!eventDoc.exists || eventDoc.data() == null) return null;
        final eventData = eventDoc.data() as Map<String, dynamic>;
        eventData.addAll({EVENT_ID_KEY: eventId});
        eventData[EVENT_DURATION_TIME_KEY] =
            (eventData[EVENT_END_TIME_KEY] as Timestamp).toDate().difference(
                (eventData[EVENT_END_TIME_KEY] as Timestamp).toDate());
        final participantMap = eventData[EVENT_PARTICIPANTS_KEY] as Map<
            String,
            String>;
        await Future.wait([
          fetchUserData(eventData[EVENT_HOST_ID_KEY])
        ]
          ..addAll(
              participantMap.keys.map((inviteeId) =>
                  fetchUserData(inviteeId))))
            .then(
              (userList) {
            eventData[EVENT_HOST_DATA_KEY] = userList.removeAt(0);
            eventData[EVENT_INVITED_USERS_KEY] = List.from(userList);
            eventData[EVENT_ACCEPTED_USERS_KEY] =
                userList.where((user) =>
                user != null && participantMap[user.id] == EventResponseStatus.ACCEPTED.toLowercaseString());
            eventData[EVENT_DECLINED_USERS_KEY] =
                userList.where((user) =>
                user != null && participantMap[user.id] == EventResponseStatus.DECLINED.toLowercaseString());
            eventData[EVENT_TENTATIVE_USERS_KEY] =
                userList.where((user) =>
                user != null && participantMap[user.id] == EventResponseStatus.TENTATIVE.toLowercaseString());
          },
        );
        return EventModel.fromMap(eventData);
      },
      onError: (e, s) {
        print('$ERROR_HEADER fetchEventDataById failed: $e - $s');
        return null;
      },
    );
  }

  /// Update Event Data
  Future<bool?> addOrUpdateUserEventResponse(String eventId, String userId, EventResponseStatus status) async {
    final eventDocRef = _db.collection(EVENT_COLLECTION_PATH).doc(eventId);
    return eventDocRef.update({
      '$EVENT_PARTICIPANTS_KEY.$userId' : status.toLowercaseString(),
    }).then((_){
      return true;
    }, onError: (e, s) {
      print('$ERROR_HEADER addOrUpdateUserEventResponse failed: $e - $s');
      return false;
    });
  }
}
