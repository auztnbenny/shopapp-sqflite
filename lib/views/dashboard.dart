import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopapp/controllers/dashboardcontroller.dart';
import 'package:shopapp/controllers/logincontroller.dart';
import 'package:shopapp/controllers/partycontroller.dart';
import 'package:shopapp/controllers/stockcontroller.dart';
import 'package:shopapp/utils/dbhandler.dart';
import 'package:shopapp/views/itemmaster/itemmaster.dart';
import 'package:shopapp/views/order/orderMaster.dart';
import 'package:shopapp/views/order/selectitems.dart';
import 'package:shopapp/views/partymaster/partymaster.dart';
import 'package:shopapp/views/profile/profile.dart';
import 'package:shopapp/views/settings/settings.dart';

import 'order/createorder.dart';
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}
class _DashboardState extends State<Dashboard> {
  final Dashboardcontroller dashboardcontroller = Get.put(Dashboardcontroller());
  final StockController stockController = Get.put(StockController());
  final PartyController partyController = Get.put(PartyController());

  final LoginController loginController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DBHandler().checkAllTables();
  }
  void _showMenu(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero); // Get position of the icon button

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx+ renderBox.size.width, // X position (same X as the button)
        offset.dy +100 , // Y position (just below the button)
        offset.dx , // X position (right of the button)
        offset.dy , // Y position (bottom of the button)
      ),
      items: [
        PopupMenuItem(
          value: 1,
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Get.back(); // Close the menu
              Get.to(()=>ProfileScreen()); // Navigate to Profile Screen
            },
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async{
              Get.back(); // Close the menu
              await loginController.logout(); // Call logout function
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(
          title: Center(child: Text("SHOP APP",style: TextStyle(fontWeight: FontWeight.bold),)),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // Show the menu with Profile and Logout options
              _showMenu(context);
            },
          ),
        ],

      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() => GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: dashboardcontroller.items.length,
          itemBuilder: (context, index) {
            final item = dashboardcontroller.items[index];
            return GestureDetector(
              onTap: () {


                switch (item['name']) {
                  case 'Order List':
                    Get.to(() => OrderMaster());

                    // Get.to(() => OrderList());
                    break;
                  case 'Create Order':
                    Get.to(() => CreateOrder());
                    break;
                  case 'Item Master':
                    Get.to(() => Itemmaster());
                    break;
                  case 'Party Master':
                    Get.to(() => Partymaster());
                    break;
                  case 'Sync Master':
                    Get.to(() => Settings());
                    break;
                  default:
                    Get.snackbar('Info', 'Page not implemented yet!');
                }

              },
              child: Card(
                elevation: 5,color: Colors.orange.shade300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      item['image']!,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 10),
                    Text(
                      item['name']!,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          },
        )),
      ),
    );
  }
}
