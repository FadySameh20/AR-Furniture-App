import 'package:ar_furniture_app/shared/widgets/login_screen.dart';
import 'package:ar_furniture_app/shared/widgets/search.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:ar_furniture_app/shared/widgets/profile_edit.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  print(FirebaseAuth.instance.currentUser!.email);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
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
            child: Search(),
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
