import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopapp/controllers/logincontroller.dart';
import 'package:shopapp/views/dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shop App',
      // home: Dashboard()

      home: FutureBuilder(
        future: loginController.checkLoginState(),
        builder: (context, snapshot) {
          // While checking login state
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
