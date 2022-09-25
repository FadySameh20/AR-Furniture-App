import 'package:ar_furniture_app/shared/widgets/category_screen.dart';
import 'package:ar_furniture_app/shared/widgets/edit_profile.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xE9E89235),
      appBar: AppBar(
        backgroundColor: Color(0xB2E89235),
        leading: FlutterLogo(),
        actions:[
          IconButton(onPressed: (){}, icon: Icon(Icons.shopping_cart))
        ] ,
          centerTitle: true,
          title:Text("Home",style: TextStyle(),)
      ),
      body: CategoriesScreen(),
    );
  }
}

