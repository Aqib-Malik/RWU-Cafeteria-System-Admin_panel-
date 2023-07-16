import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:rwu_cafeteria_system/models/Food.dart';
import 'package:rwu_cafeteria_system/screens/update_food_item.dart';
import 'package:rwu_cafeteria_system/utils/color.dart';



class FoodsScreen extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Food Items'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firestore.collection('foodItems').orderBy('title').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
             EasyLoading.show(status: 'Loading...');
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
             EasyLoading.dismiss();
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
             EasyLoading.dismiss();
            final foodItems = snapshot.data!.docs.map((doc) {
              final data = doc.data();
              
              return FoodItem(
                
                id: doc.id,
                title: data['title'],
                price: data['price'],
                imageUrl: data['image_url'],
              );
            }).toList();

            return ListView.builder(
              itemCount: foodItems.length,
              itemBuilder: (context, index) {
                final foodItem = foodItems[index];
                return foodItemWidget(foodItem,()async{
                  await FirebaseFirestore.instance.collection('foodItems').doc(foodItem.id).delete();
                },(){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateFoodScreen(foodItem: foodItem),
                      ),
                    );
                });
              },
            );
          }
        },
      ),
    );
  }
Neumorphic foodItemWidget(FoodItem foodItem, Function onDelete, Function onUpdate) {
  return Neumorphic(
    margin: EdgeInsets.symmetric(vertical: 8.0),
    padding: EdgeInsets.all(12.0),
    style: NeumorphicStyle(
      shape: NeumorphicShape.flat,
      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12.0)),
      depth: 10,
      intensity: 0.8,
      surfaceIntensity: 0.4,
      color: Colors.white,
    ),
    child: ListTile(
      contentPadding: EdgeInsets.all(0.0),
      leading: Container(
        width: 80.0,
        height: 80.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6.0,
              offset: Offset(0, 3),
            ),
          ],
          image: DecorationImage(
            image: NetworkImage(foodItem.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        foodItem.title,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        'Price: ${foodItem.price.toStringAsFixed(2)}'+  '.\Rs',
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.grey[600],
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => onUpdate(),
            icon: Icon(Icons.edit, color: Colors.blue),
          ),
          IconButton(
            onPressed: () => onDelete(),
            icon: Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
    ),
  );
}
}
