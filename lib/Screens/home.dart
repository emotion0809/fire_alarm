import 'package:auto_size_text/auto_size_text.dart';
import 'package:fire_alarm/Modules/user_module.dart';
import 'package:fire_alarm/Services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:fire_alarm/Services/auth_service.dart';

import '../Services//notification_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  static bool isFire = false;
  static late bool allowNotification = true;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFFF6829),
          title: const AutoSizeText("火災警報系統",
              minFontSize: 24, style: TextStyle(color: Colors.white)),
          actions: [
            IconButton(
              onPressed: () async {
                await AuthService.logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
              icon: const Icon(Icons.logout),
              color: Colors.white,
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    height: 100,
                    child: Row(children: [
                      CircleAvatar(
                          backgroundColor: Color(0xFFFF6829),
                          minRadius: 35,
                          child: Icon(
                            Icons.perm_identity,
                            color: Colors.white,
                          )),
                      SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText("${UserModule.currentUser?.email}",
                              minFontSize: 28,
                              style: TextStyle(color: Color(0xFF4D0000))),
                          AutoSizeText("公司:${UserModule.currentUser?.company}",
                              minFontSize: 16,
                              style: TextStyle(color: Color(0xFF4D0000)))
                        ],
                      )
                    ])),
                Center(
                    child: Home.isFire
                        ? AutoSizeText("失火",
                            minFontSize: 68,
                            style: TextStyle(color: Color(0xFFFF0000)))
                        : AutoSizeText("監測中",
                            minFontSize: 68,
                            style: TextStyle(color: Color(0xFF5CADAD)))),
                Container(
                    padding: EdgeInsets.only(bottom: 0.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                              padding: EdgeInsets.only(left: 0.0),
                              child: AutoSizeText("接收通知",
                                  minFontSize: 24,
                                  style: TextStyle(color: Color(0xFF4D0000)))),
                          Padding(
                            padding: EdgeInsets.only(right: 0.0),
                            child: Switch(
                              value: Home.allowNotification,
                              onChanged: (value) {
                                setState(() {
                                  Home.allowNotification = value;
                                  if (!Home.allowNotification) {
                                    PushNotifications.deleteMessageToken();
                                  } else {
                                    PushNotifications.getMessageToken();
                                    DatabaseService.updateMessageToken();
                                  }
                                });
                              },
                              activeTrackColor: Colors.orange,
                              activeColor: Colors.orangeAccent,
                            ),
                          )
                        ]))
              ]),
        ));
  }
}
