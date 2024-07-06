import 'package:auto_size_text/auto_size_text.dart';
import 'package:fire_alarm/Modules/user_module.dart';
import 'package:flutter/material.dart';
import 'package:fire_alarm/Services/auth_service.dart';

import '../Services//notification_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffFF5809),
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
        body: Column(
          children: [
            AutoSizeText("使用者:${UserModule.currentUser?.email}",minFontSize: 18),
            AutoSizeText("公司:${UserModule.currentUser?.company}",minFontSize: 18)
          ],
        ));
  }
}
