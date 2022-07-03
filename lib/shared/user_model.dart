class UserModel extends Object {
  final String id;
  final DateTime? createdAt;
  final String name;
  final String phoneNumber;
  final String? avatar;

  UserModel(
      {required this.id,
      this.createdAt,
      required this.name,
      required this.phoneNumber,
      this.avatar});

  bool isEqual(UserModel model) {
    return this.id == model.id;
  }

  String userAsString() {
    return '${this.name} (${this.phoneNumber})';
  }

  @override
  String toString() => name;
}
