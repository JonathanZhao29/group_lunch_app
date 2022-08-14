import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_lunch_app/models/event_model.dart';
import 'package:group_lunch_app/shared/strings.dart';

class UserModel extends Object {
  final String id;
  final DateTime? createdAt;
  final String? name;
  final String phoneNumber;
  final String? avatar;
  late final Map<String, EventResponseStatus> eventIdList;

  String get displayName => name ?? phoneNumber;

  UserModel(
      {required this.id,
      this.createdAt,
      this.name,
      required this.phoneNumber,
        Map<String, EventResponseStatus>? eventIdList,
      this.avatar}) : eventIdList = eventIdList ?? {};

  static UserModel get defaultUser => UserModel(id: '', phoneNumber: '');

  static UserModel fromMap(Map<String, dynamic> data){
    return UserModel(
      id: data[USER_ID_KEY],
      createdAt: DateTime.fromMillisecondsSinceEpoch((data[USER_CREATED_AT_KEY] as Timestamp).millisecondsSinceEpoch),
      name: data[USER_NAME_KEY],
      phoneNumber: data[USER_PHONE_NUMBER_KEY],
      avatar: data[USER_AVATAR_KEY],
      eventIdList: (data[USER_EVENT_ID_LIST_KEY] as Map<String, dynamic>?)?.map((key, val) => MapEntry(key, StringifyEventResponseStatus.fromString(val as String))),
    );
  }

  Map<String, dynamic> toMap(){
    return {
      USER_ID_KEY : id,
      USER_CREATED_AT_KEY : createdAt,
      USER_NAME_KEY : name,
      USER_PHONE_NUMBER_KEY : phoneNumber,
      USER_AVATAR_KEY : avatar,
    };
  }

  bool isEqual(UserModel model) {
    return this.id == model.id;
  }

  String userAsString() {
    return '${this.name} (${this.phoneNumber})';
  }

  @override
  String toString() => name ?? phoneNumber;
}
