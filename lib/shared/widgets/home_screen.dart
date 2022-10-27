import 'dart:convert';

import 'package:ar_furniture_app/cubits/home_cubit.dart';
import 'package:ar_furniture_app/shared/cache/sharedpreferences.dart';
import 'package:ar_furniture_app/shared/widgets/favorite_icon.dart';
import 'package:ar_furniture_app/shared/widgets/profile_edit.dart';
import 'package:ar_furniture_app/shared/widgets/search.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/home_states.dart';
import '../constants/constants.dart';
import 'categories_scroller.dart';
import 'category_screen.dart';
import 'favorite_screen.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List<String> furniture = ["Chair", "Sofa", "Drawer"];

  // List<String> images = [
  //   "assets/chair.png",
  //   "assets/seater-sofa.png",
  //   "assets/drawers.png"
  // ];

  int selectedPos = 0;
  List<Widget> NavbarPages = [HomePage(),FavoriteScreen(), Search(), CategoriesScreen(), ProfileEdit()];


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
    return BlocConsumer<HomeCubit,HomeState>(
        listener: (context,state){},
          builder: (context,state) {
            print(FirebaseAuth.instance.currentUser!.uid);
            return  Scaffold(
              // backgroundColor: Color(0xE9E89235),
              // backgroundColor: Colors.grey[300],
              backgroundColor: Color.fromRGBO(242, 246, 249, 1),
              appBar: AppBar(
                  backgroundColor: Color.fromRGBO(191, 122, 47, 1),
                  leading: FlutterLogo(),
                  actions: [
                    IconButton(onPressed: () {context.read<HomeCubit>().logout(context);}, icon: Icon(Icons.shopping_cart))
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
                    child:state is InitialHomeState?Center(child: CircularProgressIndicator(),): selectedPos!=0 ? NavbarPages[selectedPos] : SingleChildScrollView(
                      child: Column(
                        children: [
                          CarouselSlider(
                            options: CarouselOptions(
                              height: MediaQuery.of(context).size.height / 4.5,
                              aspectRatio: 16 / 9,
                              viewportFraction: 0.8,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              reverse: false,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 3),
                              autoPlayAnimationDuration: const Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                              onPageChanged: (page, _) {},
                              scrollDirection: Axis.horizontal,
                            ),
                            items:
                          BlocProvider.of<HomeCubit>(context).offers
                            .map((i) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Builder(
                                  builder: (BuildContext context) {
                                    return Container(
                                        width: MediaQuery.of(context).size.width,
                                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                        clipBehavior: Clip.antiAliasWithSaveLayer,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: Colors.amber),
                                        child: Image.network(
                                          i.img,
                                          fit: BoxFit.fill,
                                        ));
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  "Categories",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                ),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  "View All",
                                  style: TextStyle(color: Colors.black),
                                ),
                              )
                            ],
                          ),
                          CategoriesScroller(),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: const [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  "Recommended",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width / 1.7,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Container(
                                          clipBehavior: Clip.antiAliasWithSaveLayer,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20)),
                                          child: Image.asset("assets/recommended_chair.jpg"),
                                        ),
                                        Positioned(
                                          // alignment: Alignment.bottomCenter,
                                          top: 80,
                                          left: 5,
                                          child: Container(
                                            height: MediaQuery.of(context).size.height / 7,
                                            width: MediaQuery.of(context).size.width / 1.8,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: Colors.white,
                                            ),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 12.0),
                                                  child: Row(
                                                    children:  [
                                                      Text(
                                                        BlocProvider.of<HomeCubit>(context).furnitureList[index].name,
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 17),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 12.0),
                                                  child: Row(
                                                    children: const [
                                                      Icon(
                                                        Icons.star,
                                                        color: Colors.yellow,
                                                        size: 20,
                                                      ),
                                                      Icon(
                                                        Icons.star,
                                                        color: Colors.yellow,
                                                        size: 20,
                                                      ),
                                                      Icon(
                                                        Icons.star,
                                                        color: Colors.yellow,
                                                        size: 20,
                                                      ),
                                                      Icon(
                                                        Icons.star,
                                                        color: Colors.yellow,
                                                        size: 20,
                                                      ),
                                                      Icon(
                                                        Icons.star,
                                                        color: Colors.grey,
                                                        size: 20,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 12.0),
                                                  child: Row(
                                                    children: [
                                                       Text(
                                                        BlocProvider.of<HomeCubit>(context).furnitureList[index].shared.first.price,
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 17),
                                                      ),
                                                      const Spacer(),
                                                      InkWell(
                                                        onTap: () async{
                                                          context.read<HomeCubit>().addOrRemoveFromFavorite(index);
                                                          context.read<HomeCubit>().emit(SuccessOffersState());
                                                          },
                                                        child: FavoriteIcon(
                                                            iconLogo:
                                                            BlocProvider.of<HomeCubit>(context).furnitureList[index].isFavorite==false? Icons.favorite_border_rounded:Icons.favorite),
                                                      ),

                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              itemCount: BlocProvider.of<HomeCubit>(context).furnitureList.length,
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    ),
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
        ,
      );
  }
}


