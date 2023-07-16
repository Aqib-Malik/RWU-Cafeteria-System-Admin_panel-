import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rwu_cafeteria_system/utils/color.dart';

class AddFoodScreen extends StatefulWidget {
  @override
  _AddFoodScreenState createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String title = '';
  double price = 0.0;
  File? selectedImage;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
  }

 

  Future<void> _uploadData() async {
    if (_formKey.currentState!.validate() && selectedImage != null) {
      _formKey.currentState!.save();
      EasyLoading.show(status: 'Uploading...');
      try {
        final String imageName = DateTime.now().toString();
        final Reference storageReference =
            storage.ref().child('food_items_images/$imageName.jpg');
        await storageReference.putFile(selectedImage!);
        final String imageUrl = await storageReference.getDownloadURL();

        await firestore.collection('foodItems').add({
          'title': title,
          'price': price,
          'image_url': imageUrl,
        });

        setState(() {
          title = '';
          price = 0.0;
         
          selectedImage = null;
        });
        EasyLoading.dismiss();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Food Item uploaded successfully.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text('An error occurred: $e'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please select an image.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage != null) {
      setState(() {
        selectedImage = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Add Food Iem'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    title = value;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a Food Name';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Food Item Name',
                ),
              ),
             
              const SizedBox(height: 16.0),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    price = double.tryParse(value) ?? 0.0;
                  });
                },
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a price';
                  }
                  final double? parsedValue = double.tryParse(value);
                  if (parsedValue == null || parsedValue <= 0) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
              ),
              const SizedBox(height: 16.0),
            
              const SizedBox(height: 16.0),
              if (selectedImage != null) Image.file(selectedImage!),
              const SizedBox(height: 16.0),
              NeumorphicButton(
                onPressed: _pickImage,
                style: NeumorphicStyle(
                  color: Colors.grey[200],
                  boxShape: NeumorphicBoxShape.stadium(),
                ),
                child: const Text('Select Image'),
              ),
              const SizedBox(height: 16.0),
              NeumorphicButton(
                onPressed: _uploadData,
                style: NeumorphicStyle(
                  color: primaryColor,
                  boxShape: NeumorphicBoxShape.stadium(),
                ),
                child: const Text(
                  'Upload',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
