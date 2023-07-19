import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rwu_cafeteria_system/screens/food/add_food_item.dart';
import 'package:rwu_cafeteria_system/screens/food/food_items_view.dart';
import 'package:rwu_cafeteria_system/screens/orders/orders.dart';

class CustomDrawer extends StatefulWidget {
  final AnimationController animationController;

  const CustomDrawer({Key? key, required this.animationController})
      : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (BuildContext context, Widget? child) {
        double slide = 200 * widget.animationController.value;
        double scale = 1 - (0.3 * widget.animationController.value);
        return Transform(
          transform: Matrix4.identity()
            ..translate(slide)
            ..scale(scale),
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 200,
            child: Neumorphic(
              style: NeumorphicStyle(
                depth: -10,
                intensity: 1,
                // color: Theme.of(context).backgroundColor,
                boxShape: NeumorphicBoxShape.roundRect(
                  BorderRadius.circular(16),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 32),
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Admin User',
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.dashboard),
                    title: Text(
                      'Dashboard',
                      style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    onTap: () {
                      Get.back();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.add),
                    title: Text(
                      'Add Food',
                      style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    onTap: () {Get.to(AddFoodScreen());},
                  ),
                  
                  ListTile(
                    leading: Icon(Icons.shopping_cart),
                    title: Text(
                      'Orders',
                      style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    onTap: () {
                      //  Get.to(OrderPage());
                       Get.to(OrdersScreen());
                    },
                  ),
                 
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.food_bank_sharp),
                    title: Text(
                      'Food Items',
                      style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    onTap: () {
                      Get.to(FoodsScreen());
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

