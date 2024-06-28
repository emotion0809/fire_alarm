import 'dart:convert';
import 'package:fire_alarm/screens/login.dart';
import 'package:fire_alarm/screens/signup.dart';
import 'package:fire_alarm/screens/home.dart';
import 'package:fire_alarm/Modules/auth_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Modules/notification_service.dart';
import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future _firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    print("Some notification Received in background...");
  }
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //firebase messaging初始化
  await PushNotifications.init();

  //local notifications初始化
  await PushNotifications.localNotiInit();

  //在畫面開啟時接收訊系
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    String payloadData = jsonEncode(message.data);
    print("Got a message in foreground");
    if (message.notification != null) {
        PushNotifications.showSimpleNotification(
            title: message.notification!.title!,
            body: message.notification!.body!,
            payload: payloadData);
    }
  });
  //在背景執行時接收訊息
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);
  //關閉程式時接收訊息
  final RemoteMessage? message =
  await FirebaseMessaging.instance.getInitialMessage();

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      routes: {
        "/": (context) => const CheckUser(),
        "/signup": (context) => const SignUp(),
        "/home": (context) => const Home(),
        "/login": (context) => const Login(),
      },
    );
  }
}

//確認是否已經登入
//登入=>開啟home頁面
//登出=>開啟Login頁面
class CheckUser extends StatefulWidget {
  const CheckUser({super.key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  @override
  void initState() {
    AuthService.isLoggedIn().then((value) {
      if (value) {
        Navigator.pushReplacementNamed(context, "/home");
      } else {
        Navigator.pushReplacementNamed(context, "/login");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

