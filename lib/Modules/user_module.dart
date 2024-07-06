import 'package:cloud_firestore/cloud_firestore.dart';

class UserModule {
  static UserModule? currentUser;
  final String id;
  final String email;
  final String messageToken;
  final String company;

  const UserModule(
      {required this.id,
      required this.email,
      required this.messageToken,
      required this.company});

  toJson() {
    return {
      "email": email,
      "messageToken": messageToken,
      "company": company,
    };
  }

  factory UserModule.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModule(
        id: document.id,
        email: data["email"],
        messageToken: data["messageToken"],
        company: data["company"]
    );
  }
}
