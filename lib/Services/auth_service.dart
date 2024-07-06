import 'package:fire_alarm/Modules/user_module.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  // 創建帳號
  static Future<String> createAccountWithEmail(
      String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return "Account Created";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  // 登入
  static Future<String> loginWithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return "Login Successful";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  // 登出
  static Future logout() async {
    await FirebaseAuth.instance.signOut();
    UserModule.currentUser = null;
  }

  //取得當前使用者
  static Future<User?> getCurrentUser() async{
    return FirebaseAuth.instance.currentUser;
  }

  // 確認是否登入
  static Future<bool> isLoggedIn() async {
    var user = FirebaseAuth.instance.currentUser;
    return user != null;
  }


}