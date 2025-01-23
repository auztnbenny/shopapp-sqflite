import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopapp/controllers/logincontroller.dart';
import 'package:shopapp/utils/dbhandler.dart';

class FuturisticLoginPage extends StatefulWidget {
  @override
  State<FuturisticLoginPage> createState() => _FuturisticLoginPageState();
}

class _FuturisticLoginPageState extends State<FuturisticLoginPage> {
  final LoginController loginController = Get.put(LoginController());

  DBHandler dbHandler = DBHandler();

  // Controllers to bind to the TextFields for updating UI
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHandler.database;
  }
  @override
  Widget build(BuildContext context) {
    // Update the controllers when values change
    ever(loginController.username, (_) {
      usernameController.text = loginController.username.value;
    });
    ever(loginController.password, (_) {
      passwordController.text = loginController.password.value;
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade900, Colors.indigo.shade400, Colors.teal],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Card(
              color: Colors.black.withOpacity(0.6),
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    // Username TextField
                    TextField(
                      controller: usernameController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.person, color: Colors.white70),
                      ),
                      onChanged: (value) => loginController.username.value = value,
                    ),
                    SizedBox(height: 15),
                    // Password TextField
                    TextField(
                      controller: passwordController,
                      style: TextStyle(color: Colors.white),
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.lock, color: Colors.white70),
                      ),
                      onChanged: (value) => loginController.password.value = value,
                    ),
                    SizedBox(height: 15),
                    // Role DropdownButton wrapped in Obx
                    Obx(() => DropdownButton<String>(
                      value: loginController.selectedRole.value,
                      dropdownColor: Colors.black87,
                      isExpanded: true,
                      underline: SizedBox(),
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      icon: Icon(Icons.arrow_drop_down, color: Colors.white70),
                      items: ['Admin', 'Manager', 'Client']
                          .map((role) => DropdownMenuItem<String>(
                        value: role,
                        child: Text(role),
                      ))
                          .toList(),
                      onChanged: (value) =>
                      loginController.selectedRole.value = value!,
                    )),
                    SizedBox(height: 20),
                    MaterialButton(
                      onPressed: () async {

                       await loginController.login(); // Perform login
                        // Clear input fields immediately before login
                        loginController.username.value = '';
                        loginController.password.value = '';
                      },
                      color: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
