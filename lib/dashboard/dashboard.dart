
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:rwu_cafeteria_system/dashboard/drawer.dart';
import 'package:rwu_cafeteria_system/screens/contact_messages/contact_messages.dart';
import 'package:rwu_cafeteria_system/screens/feedbacks/feed_backs.dart';
import 'package:rwu_cafeteria_system/screens/food/add_food_item.dart';
import 'package:rwu_cafeteria_system/screens/food/food_items_view.dart';
import 'package:rwu_cafeteria_system/screens/orders/orders.dart';
import 'package:rwu_cafeteria_system/utils/color.dart';
class Dashboardd extends StatefulWidget {
  @override
  State<Dashboardd> createState() => _DashboarddState();
}

class _DashboarddState extends State<Dashboardd> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.amber,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: primaryColor,
          title: Text(
            'Dashboard',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0,
        ),
      ),
      drawer: CustomDrawer(
        animationController: _animationController,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
             decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [Color.fromARGB(255, 185, 220, 238), Color.fromARGB(255, 96, 139, 124)], // Replace with your desired gradient colors
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
  ),
            height: Get.height / 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top section
                Container(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            'https://cdn-icons-png.flaticon.com/512/3787/3787263.png',
                            height: 48,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Admin Panel',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'RWU Cafeteria System',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 21, 21, 21),
                        ),
                      ),
                    ],
                  ),
                ),
                // Menu section
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          buildMenuItem(context, 'Food Items', Icons.food_bank_sharp, () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FoodsScreen(),
                              ),
                            );
                          }),
                          SizedBox(height: 16),
                          buildMenuItem(context, 'Add Food Item', Icons.add, () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddFoodScreen(),
                              ),
                            );
                          }),
                          SizedBox(height: 16),
                          buildMenuItem(context, 'Contact Messages', Icons.contact_mail, () {
                            Get.to(ContactFormScreen());
                          }),
                          SizedBox(height: 16),
                          buildMenuItem(context, 'Orders', Icons.shopping_cart, () {
                            Get.to(OrdersScreen());
                          }),
                            SizedBox(height: 16),
                          buildMenuItem(context, 'FeedBacks', Icons.feedback_sharp, () {
                            Get.to(FeedbackScreen());
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMenuItem(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 6.0,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: primaryColor,
              size: 28,
            ),
            SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
