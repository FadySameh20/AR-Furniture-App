
import 'package:ar_furniture_app/cubits/home_cubit.dart';
import 'package:ar_furniture_app/models/furniture_model.dart';
import 'package:ar_furniture_app/shared/constants/constants.dart';
import 'package:ar_furniture_app/shared/widgets/favorite_icon.dart';
import 'package:ar_furniture_app/shared/widgets/search.dart';
import 'package:ar_furniture_app/shared/widgets/selected_furnitue_screen.dart';
import 'package:ar_furniture_app/shared/widgets/settings.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/home_states.dart';
import '../cache/sharedpreferences.dart';
import 'cart_screen.dart';
import 'categories_scroller.dart';
import 'category_screen.dart';
import 'favorite_screen.dart';

class HomePage extends StatefulWidget {
  static int recommendedItems=0;
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
  List<Widget> NavbarPages = [
    HomePage(),
    FavoriteScreen(),
    Search(),
    CategoriesScreen(),
    SettingsScreen()
  ];

  double bottomNavBarHeight = 60;



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
    List<TabItem> tabItems = List.of([
      TabItem(
        Icons.home,
        "Home",
        const Color.fromRGBO(191, 122, 47, 1),
        labelStyle:  TextStyle(color: !BlocProvider.of<HomeCubit>(context).isDark
            ? Colors.black
            : Colors.white,fontSize: 16),
      ),
      TabItem(
        Icons.favorite,
        "Favorite",
        const Color.fromRGBO(191, 122, 47, 1),
        labelStyle:  TextStyle(color: !BlocProvider.of<HomeCubit>(context).isDark
            ? Colors.black
            : Colors.white,fontSize: 16),
      ),
      TabItem(
        Icons.search,
        "Search",
        const Color.fromRGBO(191, 122, 47, 1),
        labelStyle:  TextStyle(color: !BlocProvider.of<HomeCubit>(context).isDark
            ? Colors.black
            : Colors.white,fontSize: 16),
      ),
      TabItem(
        Icons.category,
        "Categories",
        const Color.fromRGBO(191, 122, 47, 1),
        labelStyle:  TextStyle(color: !BlocProvider.of<HomeCubit>(context).isDark
            ? Colors.black
            : Colors.white,fontSize: 16),
      ),
      TabItem(
        Icons.person,
        "Profile",
        const Color.fromRGBO(191, 122, 47, 1),
        labelStyle:  TextStyle(color: !BlocProvider.of<HomeCubit>(context).isDark
            ? Colors.black
            : Colors.white,fontSize: 16),
      ),
    ]);
    const screenTitles=["Home","Favorite","Search","Categories","Profile"];
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is UpdateUserDataSuccessData) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("User data updated Successfully")));
        }
        if (state is UpdateEmailSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("User Email updated Successfully")));
        }
        if (state is UpdateEmailErrorState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Failed to update Email")));
        }
        if (state is UpdatePasswordErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Failed to update password")));
        }
        if (state is UpdatedCategoriesScroller &&
            (selectedPos == 0 || selectedPos == 2)) {
          setState(() {
            _navigationController.value = 3;
          });
        }
      },
      builder: (context, state) {
        // var isDark=CacheHelper.getData("darkMode")??false;
        print("Dark is ");
        print(BlocProvider.of<HomeCubit>(context).isDark);
        // print(selectedPos);
        if (selectedPos != 3) {
          CategoriesScroller.selectedCategoryName = "";
          CategoriesScroller.selectedCategoryIndex = -1;
        }
        if (selectedPos == 0) {}

        // print(FirebaseAuth.instance.currentUser!.uid);
        return Scaffold(
          // backgroundColor: Color(0xE9E89235),
          // backgroundColor: Colors.grey[300],
          backgroundColor: !BlocProvider.of<HomeCubit>(context).isDark?const Color.fromRGBO(242, 246, 249, 1):const Color.fromRGBO(30, 30, 30, 1),

          appBar: AppBar(
              backgroundColor: const Color.fromRGBO(191, 122, 47, 1),
              leading: const FlutterLogo(),
              actions: [
                IconButton(
                    onPressed: () {
                      // print("ya rbbb");
                      // print(BlocProvider.of<HomeCubit>(context).cache.cartMap);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CartScreen(
                                  furnitureList:
                                  BlocProvider.of<HomeCubit>(context)
                                      .furnitureList,
                                  cartMap: BlocProvider.of<HomeCubit>(context)
                                      .cache
                                      .cartMap)));
                    },
                    icon: Icon(Icons.shopping_cart,color:!BlocProvider.of<HomeCubit>(context).isDark?Color.fromRGBO(242, 246, 249, 1):Color.fromRGBO(30, 30, 30, 1)))
              ],
              centerTitle: true,
              title: Text(screenTitles[selectedPos],style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 25,fontWeight: FontWeight.bold,color: BlocProvider.of<HomeCubit>(context).isDark?Colors.black:Colors.white)) ,
          ),
          body: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: bottomNavBarHeight),
                child: state is InitialHomeState
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : selectedPos != 0
                        ? NavbarPages[selectedPos]
                        : SingleChildScrollView(
                            child: Column(
                              children: [
                                CarouselSlider(
                                  options: CarouselOptions(
                                    height: MediaQuery.of(context).size.height /
                                        4.5,
                                    aspectRatio: 16 / 9,
                                    viewportFraction: 0.8,
                                    initialPage: 0,
                                    enableInfiniteScroll: true,
                                    reverse: false,
                                    autoPlay: true,
                                    autoPlayInterval:
                                        const Duration(seconds: 3),
                                    autoPlayAnimationDuration:
                                        const Duration(milliseconds: 800),
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    enlargeCenterPage: true,
                                    onPageChanged: (page, _) {},
                                    scrollDirection: Axis.horizontal,
                                  ),
                                  items: BlocProvider.of<HomeCubit>(context)
                                      .offers
                                      .map((i) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Builder(
                                        builder: (BuildContext context) {
                                          return InkWell(
                                            onTap: () {
                                              FurnitureModel furn;
                                              List<Color> availableColors = [];
                                              if (BlocProvider.of<HomeCubit>(
                                                      context)
                                                  .furnitureList
                                                  .where((element) =>
                                                      element.furnitureId ==
                                                      i.salesId)
                                                  .isEmpty) {
                                                // print("ya rb");
                                                // print(i.category);
                                                // print(i.salesId);
                                                FirebaseFirestore.instance
                                                    .collection("category")
                                                    .doc(i.category)
                                                    .collection("furniture")
                                                    .doc(i.salesId)
                                                    .get()
                                                    .then((value) {
                                                  BlocProvider.of<HomeCubit>(
                                                          context)
                                                      .furnitureList
                                                      .add(FurnitureModel
                                                          .fromJson(value.data()
                                                              as Map<String,
                                                                  dynamic>));
                                                });
                                                furn =
                                                    BlocProvider.of<HomeCubit>(
                                                            context)
                                                        .furnitureList
                                                        .last;
                                                furn.shared.forEach((element) {
                                                  availableColors.add(
                                                      BlocProvider.of<
                                                                  HomeCubit>(
                                                              context)
                                                          .getColorFromHex(
                                                              element.color)!);
                                                });
                                              } else {
                                                furn = BlocProvider.of<
                                                        HomeCubit>(context)
                                                    .furnitureList
                                                    .where((element) =>
                                                        element.furnitureId ==
                                                        i.salesId)
                                                    .first;
                                                furn.shared.forEach((element) {
                                                  availableColors.add(
                                                      BlocProvider.of<
                                                                  HomeCubit>(
                                                              context)
                                                          .getColorFromHex(
                                                              element.color)!);
                                                });
                                              }
                                              BlocProvider.of<HomeCubit>(context).getFurnitureRecommendation(furn, 0);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SelectedFurnitureScreen(
                                                            selectedFurniture:
                                                                furn,
                                                            availableColors:
                                                                availableColors)),
                                              );
                                            },
                                            child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5.0),
                                                clipBehavior:
                                                    Clip.antiAliasWithSaveLayer,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Colors.amber),
                                                child: Image.network(
                                                  i.img,
                                                  fit: BoxFit.fill,
                                                )),
                                          );
                                        },
                                      ),
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children:  [
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Text(
                                        "Categories",
                                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color:BlocProvider.of<HomeCubit>(context).isDark?Colors.white:Colors.black,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                                // Row(
                                //   children: [
                                //     const Padding(
                                //       padding:
                                //       EdgeInsets.symmetric(horizontal: 20),
                                //       child: Text(
                                //         "Categories",
                                //         style: TextStyle(
                                //             fontWeight: FontWeight.bold,
                                //             fontSize: 20),
                                //       ),
                                //     ),
                                //     const Spacer(),
                                //     TextButton(
                                //       onPressed: () {
                                //         setState(() {
                                //           _navigationController.value = 3;
                                //         });
                                //       },
                                //       child: const Text(
                                //         "View All",
                                //         style: TextStyle(color: Colors.black),
                                //       ),
                                //     )
                                //   ],
                                // ),
                                CategoriesScroller(),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children:  [
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Text(
                                        "Recommended",
                                        style:  Theme.of(context).textTheme.bodyLarge!.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color:BlocProvider.of<HomeCubit>(context).isDark?Colors.white:Colors.black,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            List<Color?> availableColors = [];
                                            availableColors = BlocProvider.of<
                                                    HomeCubit>(context)
                                                .getAvailableColorsOfFurniture(
                                                    BlocProvider.of<HomeCubit>(
                                                            context)
                                                        .furnitureList[index]);
                                            BlocProvider.of<HomeCubit>(context)
                                                .getFurnitureRecommendation(
                                                    BlocProvider.of<HomeCubit>(
                                                            context)
                                                        .furnitureList[index],
                                                    0);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SelectedFurnitureScreen(
                                                          selectedFurniture:
                                                              BlocProvider.of<HomeCubit>(
                                                                          context)
                                                                      .furnitureList[
                                                                  index],
                                                          availableColors:
                                                              availableColors)),
                                            );
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.7,
                                            child: Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.2,
                                                    height: 170,
                                                    clipBehavior: Clip
                                                        .antiAliasWithSaveLayer,
                                                    decoration: BoxDecoration(
                                                        // color:Colors.black,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                    child: Image.network(
                                                      BlocProvider.of<
                                                                  HomeCubit>(
                                                              context)
                                                          .furnitureList[index]
                                                          .shared
                                                          .first
                                                          .image,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  // alignment: Alignment.bottomCenter,
                                                  top: 170,
                                                  left: 5,
                                                  child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            7,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.8,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      color: Colors.white,
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 12.0),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                BlocProvider.of<
                                                                            HomeCubit>(
                                                                        context)
                                                                    .furnitureList[
                                                                        index]
                                                                    .name,
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        17),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 12.0),
                                                          child: Row(
                                                            children: [
                                                              // if
                                                              ...List.generate(
                                                                BlocProvider.of<HomeCubit>(context)
                                                                            .furnitureList[
                                                                                index]
                                                                            .calculateAverageRating()
                                                                            .toString() !=
                                                                        "NaN"
                                                                    ? BlocProvider.of<HomeCubit>(
                                                                            context)
                                                                        .furnitureList[
                                                                            index]
                                                                        .calculateAverageRating()
                                                                        .toInt()
                                                                    : 0,
                                                                (index) => const Icon(
                                                                  Icons.star,
                                                                  color: Colors
                                                                      .yellow,
                                                                  size: 20,
                                                                ),
                                                              ).toList(),
                                                              ...List.generate(
                                                                BlocProvider.of<HomeCubit>(context)
                                                                            .furnitureList[
                                                                                index]
                                                                            .calculateAverageRating()
                                                                            .toString() !=
                                                                        "NaN"
                                                                    ? 5 -
                                                                        BlocProvider.of<HomeCubit>(context)
                                                                            .furnitureList[index]
                                                                            .calculateAverageRating()
                                                                            .toInt()
                                                                    : 5,
                                                                (index) => const Icon(
                                                                  Icons.star,
                                                                  color: Colors
                                                                      .grey,
                                                                  size: 20,
                                                                ),
                                                              ).toList()
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      12.0),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                BlocProvider.of<
                                                                            HomeCubit>(
                                                                        context)
                                                                    .furnitureList[
                                                                        index]
                                                                    .shared
                                                                    .first
                                                                    .price,
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        17),
                                                              ),
                                                              const Spacer(),
                                                              InkWell(
                                                                onTap:
                                                                    () async {
                                                                  context.read<HomeCubit>().addOrRemoveFromFavorite(BlocProvider.of<
                                                                              HomeCubit>(
                                                                          context)
                                                                      .furnitureList[
                                                                          index]
                                                                      .furnitureId);
                                                                  context
                                                                      .read<
                                                                          HomeCubit>()
                                                                      .emit(
                                                                          SuccessOffersState());
                                                                },
                                                                child: FavoriteIcon(
                                                                    iconLogo: BlocProvider.of<HomeCubit>(context).furnitureList[index].isFavorite ==
                                                                            false
                                                                        ? Icons
                                                                            .favorite_border_rounded
                                                                        : Icons
                                                                            .favorite),
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
                                        ),
                                      );
                                    },
                                    itemCount:
                                       HomePage.recommendedItems,
                                  ),
                                ),
                              ],
                            ),
                          ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: CircularBottomNavigation(
                    tabItems,
                    selectedIconColor: BlocProvider.of<HomeCubit>(context).isDark
                        ? Colors.black
                        : Colors.white,
                    controller: _navigationController,
                    selectedPos: selectedPos,
                    barHeight: bottomNavBarHeight,
                    barBackgroundColor: BlocProvider.of<HomeCubit>(context).isDark
                        ? Colors.black
                        : Colors.white,
                    backgroundBoxShadow: const <BoxShadow>[
                      BoxShadow(color: kAppBackgroundColor, blurRadius: 10.0),
                    ],
                    animationDuration: const Duration(milliseconds: 300),
                    selectedCallback: (int? selectedPos) {
                      if (selectedPos == 3) {
                        if (CategoriesScroller.selectedCategoryIndex == -1) {
                          setState(() {
                            CategoriesScroller.selectedCategoryIndex = 0;
                            CategoriesScroller.selectedCategoryName =
                                BlocProvider.of<HomeCubit>(context)
                                    .categories
                                    .first
                                    .name;
                          });
                        }
                      }
                      setState(() {
                        this.selectedPos = selectedPos ?? 0;
                        // print(_navigationController.value);
                      });
                    },
                  ))
            ],
          ),
          // bottomNavigationBar: ,
        );
      },
    );
  }
}
