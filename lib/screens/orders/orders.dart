import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rwu_cafeteria_system/utils/color.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';



class OrdersScreen extends StatelessWidget {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Future<pw.Document> generateReceiptPdf(Map<String, dynamic> data) async {
  final pdf = pw.Document();

  pdf.addPage(
  pw.Page(
  build: (pw.Context context) => pw.Center(
    child: pw.Container(
      width: double.infinity,
      padding: pw.EdgeInsets.all(32),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Receipt',
            style: pw.TextStyle(fontSize: 40, fontWeight: pw.FontWeight.bold),
            textAlign: pw.TextAlign.center,
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            'Name: ${data['name']}',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(
            'Email: ${data['email']}',
            style: pw.TextStyle(fontSize: 18),
          ),
          pw.Text(
            'Phone: ${data['phone']}',
            style: pw.TextStyle(fontSize: 18),
          ),
          pw.Text(
            'Total: ${data['totalPrice']} /Rs',
            style: pw.TextStyle(fontSize: 20, color: PdfColors.red),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            'Items:',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.ListView.builder(
            itemCount: data['item'].length,
            itemBuilder: (pw.Context context, int index) {
              final item = data['item'][index];
              return pw.Padding(
                padding: pw.EdgeInsets.only(top: 8),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      '${item['name']}',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      'Price: ${item['price']}',
                      style: pw.TextStyle(
                        fontSize: 14,
                        color: PdfColors.grey,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    ),
  ),
  )

  );

  return pdf;
}

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text('Orders'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Approved'),
              Tab(text: 'Rejected'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildPendingOrders(),
            buildApprovedOrders(),
            buildRejectedOrders(),
          ],
        ),
      ),
    );
  }

  Widget buildPendingOrders() {
    return StreamBuilder<QuerySnapshot>(
        stream: _firebaseFirestore.collection('orders').where('is_reject',isEqualTo: false).where('is_aprove',isEqualTo: false).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text("Loading"));
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return Padding(
  padding: const EdgeInsets.all(8.0),
  child: ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      // You can also add a border using the 'borderSide' property
    ),
    tileColor: Colors.grey[200], // Customize the background color
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data['name'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          data['email'],
          style: TextStyle(
            fontSize: 12,
            color: Colors.blue,
          ),
        ),
        GestureDetector(
          onTap: () {
            // Functionality to open dialer with the phone number
            launch("tel:${data['phone']}");
          },
          child: Text(
            data['phone'],
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
         Text(
              "Total: " + data['totalPrice'].toString() + " /Rs",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
      ],
    ),
    subtitle: Column(
      children: [
        Column(
          children: data['item'].map<Widget>((item) {
            return ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item['imgUrl'],
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                item['name'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Price: ${item['price']}',
                style: TextStyle(
                  color: Colors.grey[700],
                ),
              ),
            );
          }).toList(),
        ),
         Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    TextButton(
      child: Text(
        'Print',
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () async {
        final pdf = await generateReceiptPdf(data);
        await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdf.save(),
        );
      },
    ),
    TextButton(
      child: Text(
        'Approve',
        style: TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () {
        document.reference.update({'is_aprove': true}).then((value) =>  Get.snackbar("Approved", "Order Approved"));
      },
    ),
    TextButton(
      child: Text(
        'Reject',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () {
        
        document.reference.update({'is_reject': true}).then((value) =>  Get.snackbar("Rejected", "Order Rejected"));
      },
    ),
  ],
),
      ],
    ),
  

  ),
);


            }).toList(),
          );
        },
      );
  }

  Widget buildRejectedOrders() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firebaseFirestore
          .collection('orders')
          .where('is_reject',isEqualTo: true).where('is_aprove',isEqualTo: false)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text("Loading"));
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            var id = document.id;
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return buildOrderItem(data, id);
          }).toList(),
        );
      },
    );
  }
   Widget buildApprovedOrders() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firebaseFirestore
          .collection('orders')
         .where('is_aprove',isEqualTo: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text("Loading"));
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            var id = document.id;
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return buildOrderItem(data, id);
          }).toList(),
        );
      },
    );
  }

  Widget buildOrderItem(Map<String, dynamic> data, String id) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            tileColor: Colors.grey[200],
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['name'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  data['email'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    launch("tel:${data['phone']}");
                  },
                  child: Text(
                    data['phone'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                Text(
                  "Total: " + data['totalPrice'].toString() + " /Rs",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            subtitle: Column(
              children: [
                Column(
                  children: data['item'].map<Widget>((item) {
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item['imgUrl'],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        item['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Price: ${item['price']}',
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                    );
                  }).toList(),
                ),
               
                SizedBox(height: 8),
                if (data['is_aprove'])
                  Text('Order Approved',
                      style: TextStyle(color: Color.fromARGB(255, 18, 95, 237)))
                else if (data['is_reject'])
                  Text('Order Rejected', style: TextStyle(color: Colors.red))
                
              ],
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
