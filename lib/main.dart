import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shqanda_application/Provider/product_provider.dart';
import 'package:shqanda_application/Screens/home_page.dart';
import 'package:shqanda_application/Screens/sign_in_screen.dart';
import 'package:shqanda_application/Utils/Langs/translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());

 // await readCategoriesAndSections();
//  await uploadData();
  //uploadCategoriesWithSections;
//  await testWrite();
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProductProvider>(
          create: (context) => ProductProvider(),
        ),
      ],
      child: GetMaterialApp(
        translations: Translation(),
        locale: Locale('ar'),
        fallbackLocale: Locale('en'),
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return HomePage();
            } else {
              return Login();
            }
          },
        ),
      ),
    );
  }
}

// Function to generate random products


Future<void> fetchCategoriesWithSections() async {
  final firestore = FirebaseFirestore.instance;
  final categoriesCollection = firestore.collection('Categories');
  final Map<String, dynamic> allData = {};

  try {
    // Fetch all documents in the 'Categories' collection
    QuerySnapshot querySnapshot = await categoriesCollection.get();

    for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
      String docId = docSnapshot.id;
      Map<String, dynamic> categoryData = docSnapshot.data() as Map<String, dynamic>;

      allData[docId] = {
        'categoryData': categoryData,
        'sections': await fetchSubcollections(docId) // Fetch subcollections
      };
    }
  } catch (e) {
    print('Error fetching categories: $e');
  }

  // Save the allData map as a JSON file
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/categories_data.json';
  print('Directory: ${directory.path}'); // Print the directory path

  final file = File(filePath);
  await file.writeAsString(jsonEncode(allData));
  print('Data saved to $filePath');

  // Print the entire JSON data
  print('JSON Content: ${jsonEncode(allData)}'); // Print the JSON content
}



// Assuming fetchSubcollections is defined elsewhere
Future<List<Map<String, dynamic>>> fetchSubcollections(String categoryId) async {
  final firestore = FirebaseFirestore.instance;
  final subcollectionRef = firestore.collection('Categories').doc(categoryId).collection('Sections');
  final List<Map<String, dynamic>> sectionsData = [];

  try {
    QuerySnapshot subQuerySnapshot = await subcollectionRef.get();
    for (QueryDocumentSnapshot subDocSnapshot in subQuerySnapshot.docs) {
      sectionsData.add(subDocSnapshot.data() as Map<String, dynamic>);
    }
  } catch (e) {
    print('Error fetching subcollections for $categoryId: $e');
  }

  return sectionsData;
}

  Future<void> fetchDataAndSaveToJson() async {
    final firestore = FirebaseFirestore.instance;
    final collections = ['Categories', 'Message', 'Order', 'Products', 'ShippingInfo', 'User'];
    final Map<String, dynamic> allData = {};

    for (String collection in collections) {
      try {
        QuerySnapshot querySnapshot = await firestore.collection(collection).get();
        List<Map<String, dynamic>> dataList = querySnapshot.docs.map((doc) {
          return doc.data() as Map<String, dynamic>;
        }).toList();
        allData[collection] = dataList;
      } catch (e) {
        print('Error fetching data from $collection: $e');
      }
    }
    // Save the allData map as a JSON file
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/firebase_data.json';
    print('Directory: ${directory.path}'); // Print the directory path

    final file = File(filePath);
    await file.writeAsString(jsonEncode(allData));
    print('Data saved to $filePath');
    // Print the entire JSON data
    print('JSON Content: ${jsonEncode(allData)}'); // Print the JSON content
  }
Future<void> uploadDataFromJson() async {
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/firebase_data.json';

  print('Directory: ${directory.path}'); // Print the directory path

  final file = File(filePath);
  if (!await file.exists()) {
    print('JSON file does not exist at $filePath');
    return;
  }

  // Read JSON data
  String jsonString = await file.readAsString();
  print('JSON Content: $jsonString'); // Print the entire JSON content
  Map<String, dynamic> allData = jsonDecode(jsonString);

  final firestore = FirebaseFirestore.instance;

  for (String collection in allData.keys) {
    List<dynamic> dataList = allData[collection];

    for (Map<String, dynamic> data in dataList) {
      try {
        await firestore.collection(collection).add(data);
        print('Uploaded data to $collection: $data');
      } catch (e) {
        print('Error uploading data to $collection: $e');
      }
    }
  }
}

Future<void> testWrite() async {
  final firestore = FirebaseFirestore.instance;
  await firestore.collection('test').add({'testField': 'testValue'});
  print('Test document written to Firestore.');
}


Future<void> uploadCategoriesWithSections() async {
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/categories_data.json';
  final file = File(filePath);

  if (!await file.exists()) {
    print('JSON file does not exist at $filePath');
    return;
  }

  // Read JSON data
  String jsonString = await file.readAsString();
  Map<String, dynamic> allData = jsonDecode(jsonString);

  final firestore = FirebaseFirestore.instance;

  for (String docId in allData.keys) {
    Map<String, dynamic> categoryData = allData[docId]['categoryData'];
    List<dynamic> sectionsData = allData[docId]['sections'];

    // Upload category data
    try {
      await firestore.collection('Categories').doc(docId).set(categoryData);
      print('Uploaded category data for $docId: $categoryData');
    } catch (e) {
      print('Error uploading category data for $docId: $e');
    }

    // Upload sections data
    final sectionsCollection = firestore.collection('Categories').doc(docId).collection('sections');

    for (var section in sectionsData) {
      try {
        await sectionsCollection.add(section);
        print('Uploaded section data to $docId: $section');
      } catch (e) {
        print('Error uploading section data to $docId: $e');
      }
    }
  }
}

