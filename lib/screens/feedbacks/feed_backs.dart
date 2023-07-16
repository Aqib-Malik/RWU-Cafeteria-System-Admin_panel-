import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:rwu_cafeteria_system/utils/color.dart';

class FeedbackScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,

        title: Text('Feedback'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection('feedback')
              .get(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error fetching feedback'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('No feedback available'),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final feedback = snapshot.data!.docs[index];
                final rating = feedback['rating'] ?? 0.0;
                final feedbackText = feedback['feedback_text'] ?? '';
                final customeremail = feedback['customer_email'] ?? '';

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Neumorphic(
                    style: NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      depth: 8,
                      intensity: 0.5,
                      lightSource: LightSource.topLeft,
                      color: Colors.white,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Rating: $rating',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                            ],
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Feedback:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            feedbackText,
                            style: TextStyle(fontSize: 16.0),
                          ),
                           SizedBox(height: 8.0),
                          Text(
                            customeremail,
                            style: TextStyle(fontSize: 16.0,color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
