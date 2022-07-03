import 'package:group_lunch_app/shared/strings.dart';

class UserModel extends Object {
  final String id;
  final DateTime? createdAt;
  final String? name;
  final String phoneNumber;
  final String? avatar;

  UserModel(
      {required this.id,
      this.createdAt,
      this.name,
      required this.phoneNumber,
      this.avatar});

  static UserModel fromMap(Map<String, dynamic> data){
    return UserModel(
      id: data[Strings.USER_ID_KEY],
      createdAt: data[Strings.USER_CREATED_AT_KEY],
      name: data[Strings.USER_NAME_KEY],
      phoneNumber: data[Strings.USER_PHONE_NUMBER_KEY],
      avatar: data[Strings.USER_AVATAR_KEY],
    );
  }

  Map<String, dynamic> toMap(){
    return {
      Strings.USER_ID_KEY : id,
      Strings.USER_CREATED_AT_KEY : createdAt,
      Strings.USER_NAME_KEY : name,
      Strings.USER_PHONE_NUMBER_KEY : phoneNumber,
      Strings.USER_AVATAR_KEY : avatar,
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
