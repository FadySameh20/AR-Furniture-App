import 'package:ar_furniture_app/models/user_model.dart';
import 'package:ar_furniture_app/shared/cache/sharedpreferences.dart';
import 'package:ar_furniture_app/shared/constants/constants.dart';
import 'package:ar_furniture_app/shared/widgets/SearchFilterScreen.dart';
import 'package:ar_furniture_app/shared/widgets/boarding_screen.dart';
import 'package:ar_furniture_app/shared/widgets/home_screen.dart';
import 'package:ar_furniture_app/shared/widgets/login_screen.dart';
import 'package:ar_furniture_app/shared/widgets/register_screen.dart';
import 'package:ar_furniture_app/shared/widgets/splash_welcome_screen.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:ar_furniture_app/shared/widgets/profile_edit.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'cubits/home_cubit.dart';
import 'models/furniture_model.dart';
import 'models/shared_model.dart';

void main() async{
  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  // var temp=await FirebaseFirestore.instance.collection("category").doc("tables").collection("tables").doc();
//print("hello");
//print(temp.id);
//   await temp.set(FurnitureModel(furnitureId: temp.id,category: "tables", name: "classic tables", model: "", shared: [SharedModel(color: "#FF0000", image: "https://firebasestorage.googleapis.com/v0/b/ar-furniture-7fb69.appspot.com/o/furniture%2FItem_1.png?alt=media&token=0bd24e89-91c4-4c7a-a8f1-65dde2dd7cbf", price: "200", quantity: "5", colorName: '')], ratings: []).toMap());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..getAllData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        theme: ThemeData(
          scaffoldBackgroundColor: Color.fromRGBO(242, 246, 249, 1),
          textTheme: TextTheme(
            bodyText1: GoogleFonts.crimsonPro()
          )
        ),
        routes: {
          '/': (context)=>FirebaseAuth.instance.currentUser!=null?HomePage():CacheHelper.getData("hasPassedBoardingScreen")!=null?SplashWelcomeScreen():BoardingScreen(),
          '/register': (context) => RegisterScreen(),
          '/login': (context) => LoginScreen(),
          '/home': (context) => HomePage(),
          '/filter': (context) => SearchFilterScreen(),
        },
        // home: BoardingScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedPos = 0;

  double bottomNavBarHeight = 60;

  List<TabItem> tabItems = List.of([
    TabItem(
      Icons.home,
      "Home",
      Color.fromRGBO(191, 122, 47, 1),
    ),
    TabItem(
      Icons.favorite,
      "Favorite",
      Color.fromRGBO(191, 122, 47, 1),
    ),
    TabItem(
      Icons.search,
      "Search",
      Color.fromRGBO(191, 122, 47, 1),
    ),
    TabItem(
      Icons.category,
      "Categories",
      Color.fromRGBO(191, 122, 47, 1),
    ),
    TabItem(
      Icons.person,
      "Profile",
      Color.fromRGBO(191, 122, 47, 1),
    ),
  ]);

  late CircularBottomNavigationController _navigationController;

  @override
  void initState() {
    super.initState();
    _navigationController = CircularBottomNavigationController(selectedPos);
  }

  void dispose() {
    super.dispose();
    _navigationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xE9E89235),
      // backgroundColor: Colors.grey[300],
      backgroundColor: Color.fromRGBO(242, 246, 249, 1),
      appBar: AppBar(
          backgroundColor: Color.fromRGBO(191, 122, 47, 1),
          leading: FlutterLogo(),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.shopping_cart))
          ],
          centerTitle: true,
          title: Text(
            "Home",
            style: TextStyle(),
          )),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: bottomNavBarHeight),
            child: HomePage(),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: CircularBottomNavigation(
                tabItems,
                controller: _navigationController,
                selectedPos: selectedPos,
                barHeight: bottomNavBarHeight,
                barBackgroundColor: Colors.white,
                backgroundBoxShadow: <BoxShadow>[
                  BoxShadow(color: Colors.black45, blurRadius: 10.0),
                ],
                animationDuration: Duration(milliseconds: 300),
                selectedCallback: (int? selectedPos) {
                  setState(() {
                    this.selectedPos = selectedPos ?? 0;
                    print(_navigationController.value);
                  });
                },
              ))
        ],
      ),
      // bottomNavigationBar: ,
    );
  }
}
