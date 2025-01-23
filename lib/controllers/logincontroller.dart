import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopapp/utils/dbhandler.dart';
import 'package:shopapp/views/auth/login.dart';
import 'package:shopapp/views/dashboard.dart';

class LoginController extends GetxController {
  final DBHandler dbHandler = DBHandler();
  var username = ''.obs;
  var password = ''.obs;
  var selectedRole = 'Admin'.obs;

  @override
  void onInit() {
    super.onInit();
    initializeDatabase();
    loadUserData(); // Load user data on controller initialization
    dbHandler.userdata();
  }

  Future<void> initializeDatabase() async {
    await dbHandler.database; // Method to initialize the database
    print("Database initialized successfully");
  }
  // Load user data from SharedPreferences
  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    username.value = prefs.getString('username') ?? ''; // Default to empty string if not found
    password.value = prefs.getString('password') ?? ''; // Default to empty string if not found
    selectedRole.value = prefs.getString('role') ?? 'Admin'; // Default to 'Admin' if not found
  }

  // Login function
  Future<void> login() async {
    await initializeDatabase(); // Ensure the database is opened
    if (username.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Username and Password cannot be empty",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      final user = await dbHandler.validateUser(username.value, password.value, selectedRole.value);
      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('username', user['USERNAME']);
        await prefs.setString('password', user['PASSWORD']);
        await prefs.setString('role', user['ROLE']);

        Get.snackbar("Success", "Welcome ${user['USERNAME']}",
            snackPosition: SnackPosition.BOTTOM);
        Get.offAll(() => Dashboard());
      } else {
        username.value = '';
        password.value = '';
        selectedRole.value = 'Admin';
        Get.snackbar("Error", "Invalid credentials or role",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "Database error: $e", snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Check if user is already logged in
  Future<void> checkLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      // Navigate to Dashboard
      Get.offAll(() => Dashboard());
    } else {
      // Navigate to Login
      Get.offAll(() => FuturisticLoginPage());
    }
  }

  // Logout function
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Close the database
    await dbHandler.closeDatabase();

    // Clear reactive values
    username.value = '';
    password.value = '';
    selectedRole.value = 'Admin';

    // Navigate to login page
    Get.offAll(() => FuturisticLoginPage());
  }

  // Update user details in the database
  Future<void> updateUser(String newUsername, String newPassword, String newRole) async {
    final db = await DBHandler().database;

    // Debug: Ensure we have a valid database connection
    if (db == null) {
      Get.snackbar('Error', 'Database connection error');
      return;
    }

    try {
      // Debug: Log current user values
      print('Updating user: $username, $password, $selectedRole');

      // Perform the update query
      int updatedRows = await db.update(
        'Shop_Stock_Users',
        {
          'USERNAME': newUsername,
          'PASSWORD': newPassword,
          'ROLE': newRole,
        },
        where: 'USERNAME = ? AND PASSWORD = ? AND ROLE = ?',
        whereArgs: [username.value, password.value, selectedRole.value],
      );

      // Debug: Check how many rows were updated
      print('Rows updated: $updatedRows');

      // If rows were updated, update the reactive variables
      if (updatedRows > 0) {
        username.value = newUsername;
        password.value = newPassword;
        selectedRole.value = newRole;
        await logout();
        Get.snackbar('Success', 'Profile updated successfully');
      } else {
        // No rows were updated, maybe incorrect data or no match
        Get.snackbar('Error', 'Failed to update profile. Please check your credentials.');
      }
    } catch (e) {
      // Handle any exceptions
      print('Error during update: $e');
      Get.snackbar('Error', 'Failed to update profile: $e');
    }
  }

}
