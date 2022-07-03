import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      Strings.USER_CREATED_AT_KEY: DateTime.now(),
      Strings.USER_PHONE_NUMBER_KEY: newUser.phoneNumber,
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
    if(_authService.currentUser == null) return null;
    final user = await fetchUserData(_authService.currentUser!.uid);
    _currentUser = user;
    return user;
  }

  /// get UserModel corresponding to [userId]
  Future<UserModel?> fetchUserData(String userId) async {
    final docRef = _db.collection(USER_COLLECTION_PATH).doc(userId);
    docRef.get().then(
      (doc) {
        final data = doc.data as Map<String, dynamic>;
        data.addAll({Strings.USER_ID_KEY: userId});
        return UserModel.fromMap(data);
      },
      onError: (e, s) => print('$ERROR_HEADER fetchUserData failed: $e - $s'),
    );
    return null;
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

}
