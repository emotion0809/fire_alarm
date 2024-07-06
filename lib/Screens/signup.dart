import 'package:fire_alarm/Services/database_service.dart';
import 'package:fire_alarm/Services/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fire_alarm/Services/auth_service.dart';

import '../Modules/company_module.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _LoginState();
}

class _LoginState extends State<SignUp> {
  late TextEditingController emailController = TextEditingController();
  late TextEditingController passwordController = TextEditingController();
  late TextEditingController passwordVerifyController = TextEditingController();
  String dropdownCompanyValue = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "創建帳號",
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 30),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Email"),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "密碼"),
              obscureText: true,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: passwordVerifyController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "驗證密碼"),
              obscureText: true,
            ),
            const SizedBox(
              height: 10,
            ),
            DropdownMenu<String>(
              hintText: "選擇公司",
              expandedInsets: EdgeInsets.symmetric(vertical: 8.0),
              onSelected: (String? value) {
                setState(() {
                  dropdownCompanyValue = value!;
                });
              },
              dropdownMenuEntries: CompanyModule.companylist
                  .map<DropdownMenuEntry<String>>((String value) {
                return DropdownMenuEntry<String>(value: value, label: value);
              }).toList(),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                  onPressed: () async {
                    if(passwordController.text != passwordVerifyController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "兩次輸入的密碼不相同",
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red.shade400,
                      ));
                    }
                    else if(dropdownCompanyValue.isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "未輸選擇公司",
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red.shade400,
                      ));
                    }else{
                      await AuthService.createAccountWithEmail(
                          emailController.text, passwordController.text)
                          .then((value) async {
                        if (value == "Account Created") {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("帳號已成功創建")));
                          //儲存使用者資料到FireStore
                          User? user = await AuthService.getCurrentUser();
                          var token = await PushNotifications.getDeviceToken();
                          await DatabaseService.saveUser(
                              user!, token, dropdownCompanyValue);
                          //切換頁面
                          Navigator.pushNamedAndRemoveUntil(
                              context, "/home", (route) => false);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              value,
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red.shade400,
                          ));
                        }
                      });
                    }
                  },
                  child: const Text("創建帳號")),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("login")),
              ],
            )
          ],
        ),
      ),
    ));
  }
}
