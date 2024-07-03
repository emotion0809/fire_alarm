import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fire_alarm/Modules/auth_service.dart';

import '../Modules/notification_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    PushNotifications.getDeviceToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffFF5809),
        title:const AutoSizeText("火災警報系統", minFontSize: 30,style: TextStyle(color: Colors.white)),
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
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[AutoSizeText("失火", minFontSize: 30)],
        ),
      ),
    );
  }
}
