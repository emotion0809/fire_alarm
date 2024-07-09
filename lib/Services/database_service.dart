import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_alarm/Modules/company_module.dart';
import 'package:fire_alarm/Modules/user_module.dart';
import 'package:fire_alarm/Services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'notification_service.dart';

class DatabaseService {
  static final _db = FirebaseFirestore.instance;

  static Future saveUser(User user, String token, String company) async {
    try {
      var id = user.uid;
      var email = user.email;
      UserModule.currentUser = new UserModule(
          id: id,
          email: email.toString(),
          messageToken: token,
          company: company);
      await _db
          .collection("users")
          .doc(id)
          .set(UserModule.currentUser?.toJson());
      print("Document Added to $id");
    } catch (e) {
      print("error in saving to firestore");
      print(e.toString());
    }
  }

  static Future<List<String>> getCompanys() async {
    var companysName = <String>[];
    try {
      final snapShot = await _db.collection("companys").get();
      final companyData =
      snapShot.docs.map((e) => CompanyModule.fromSnapShot(e)).toList();
      for (var item in companyData) {
        companysName.add(item.name);
      }
    }
    catch (e) {
      print("error in fetch to firestore");
      print(e.toString());
    }
    return companysName;
  }

  static Future getCurrentUser() async {
    if (await AuthService.isLoggedIn()) {
      User? user = await AuthService.getCurrentUser();
      if (UserModule.currentUser == null) {
        try {
          final snapShot = await _db
              .collection("users")
              .where("email", isEqualTo: user?.email)
              .get();
          final userData =
              snapShot.docs
                  .map((e) => UserModule.fromSnapShot(e))
                  .single;
          UserModule.currentUser = userData;
          await updateMessageToken();
        } catch (e) {
          print("error in fetch to firestore");
          print(e.toString());
        }
      }
    }
  }

  static Future updateMessageToken() async {
    var messageToken = await PushNotifications.getMessageToken();
    if (messageToken != UserModule.currentUser?.messageToken) {
      UserModule.currentUser = new UserModule(
          id: UserModule.currentUser!.id,
          email: UserModule.currentUser!.email,
          messageToken: messageToken.toString(),
          company: UserModule.currentUser!.company);
      await _db
          .collection("users")
          .doc(UserModule.currentUser!.id)
          .set(UserModule.currentUser?.toJson());
    }
  }
}
