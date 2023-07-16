import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:rwu_cafeteria_system/utils/color.dart';

class ContactFormScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Contact Forms'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('contact_forms').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.size == 0) {
            return Text('No contact forms available.');
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;

              String name = data['name'];
              String email = data['email'];
              String message = data['message'];

              return Neumorphic(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                style: NeumorphicStyle(
                  depth: 4,
                  intensity: 0.8,
                  color: Colors.white,
                ),
                child: InkWell(
                  onLongPress: ()async{
                    await FirebaseFirestore.instance.collection('contact_forms').doc(document.id).delete();

                  },
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text(
                      name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.email),
                            SizedBox(width: 4),
                            Text(email),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.message),
                            SizedBox(width: 4),
                            Text(message),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
