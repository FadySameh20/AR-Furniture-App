import 'package:ar_furniture_app/cubits/home_states.dart';
import 'package:ar_furniture_app/models/furniture_model.dart';
import 'package:ar_furniture_app/shared/widgets/favorite_icon.dart';
import 'package:ar_furniture_app/shared/widgets/selected_furnitue_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/home_cubit.dart';
import '../constants/constants.dart';
import 'categories_scroller.dart';

class CategoriesScreen extends StatefulWidget {

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Color?> colors = [
    Colors.teal[300],
    Colors.orange[300],
    Colors.red[300],
    Colors.lime[400],
    Colors.blue[300],
    Colors.greenAccent,
    Colors.purple[300],
    Colors.brown[300],
    Colors.pink[200],
    Colors.black26,
  ];

  int selectedColorIndex = 0;

  List<FurnitureModel> filteredFurniture = [];

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(() async {
      print("Listenerrrrr");
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0) {
          await getMoreFurniture();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {

      },
      builder: (context, state) {
        print("haaaa");
        print(BlocProvider.of<HomeCubit>(context).furnitureList.length);
        filteredFurniture = BlocProvider.of<HomeCubit>(context).furnitureList.where((element) => element.category==CategoriesScroller.selectedCategoryName).toList();
        return Column(
          children: [
            CategoriesScroller(),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 90),
                    decoration: BoxDecoration(
                      color: kAppBackgroundColorLowOpacity,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.0),
                        topLeft: Radius.circular(20.0),
                      ),
                    ),
                  ),
                  ListView.builder(
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemCount: filteredFurniture.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            print("Selecting furniture");
                            List<Color?> availableColors = [];
                            availableColors = BlocProvider.of<HomeCubit>(context).getAvailableColorsOfFurniture(filteredFurniture[index]);
                            BlocProvider.of<HomeCubit>(context).getFurnitureRecommendation(filteredFurniture[index], 0);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SelectedFurnitureScreen(selectedFurniture: filteredFurniture[index], availableColors: availableColors)),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 30.0, left: 12.0, right: 12.0, bottom: 15.0),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 5.0),
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height > 700
                                      ? MediaQuery.of(context).size.height * 0.23
                                      : MediaQuery.of(context).size.height * 0.28,
                                  decoration: BoxDecoration(
                                    color: colors[index % colors.length],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5.0, right: 7.0),
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height > 700
                                      ? MediaQuery.of(context).size.height * 0.23
                                      : MediaQuery.of(context).size.height * 0.28,
                                  decoration: BoxDecoration(
                                    color: !BlocProvider.of<HomeCubit>(context).isDark?Colors.white:Color(0xff414147),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  child: Container(
                                    height: MediaQuery.of(context).size.height > 700
                                        ? MediaQuery.of(context).size.height * 0.035
                                        : MediaQuery.of(context).size.height * 0.043,
                                    padding: EdgeInsets.all(5.0),
                                    child: Text(
                                      'EGP ' + (double.parse(filteredFurniture[index].shared[selectedColorIndex].price) - double.parse(filteredFurniture[index].shared[selectedColorIndex].price) * double.parse(filteredFurniture[index].shared[selectedColorIndex].discount) / 100).toStringAsFixed(0),                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: kAppBackgroundColor,
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, top: 30.0, right: 8.0),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: SizedBox(
                                          height: MediaQuery.of(context).size.width *
                                              0.19,
                                          width:
                                          MediaQuery.of(context).size.width * 0.4,
                                          child: ListTile(
                                            title: Padding(
                                              padding:
                                              const EdgeInsets.only(bottom: 5.0),
                                              child: Text(
                                                BlocProvider.of<HomeCubit>(context).capitalizeFirstLettersInView(filteredFurniture[index].name),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color:BlocProvider.of<HomeCubit>(context).isDark?Colors.white:Colors.black,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            subtitle: filteredFurniture[index].description == null ? null : Text(
                                              filteredFurniture[index].description!,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color:!BlocProvider.of<HomeCubit>(context).isDark?Color(
                                                    0xffb2b2b6):Color(
                                                    0xffb2b2b6),
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w400,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                        filteredFurniture[index].description == null ? MediaQuery.of(context).size.height * 0.01 : MediaQuery.of(context).size.height * 0.0225,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 15.0,
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              print('Add to favorites');
                                              // int tempIndex = BlocProvider.of<HomeCubit>(context).furnitureList.indexWhere((element) => element.furnitureId == filteredFurniture[index].furnitureId);
                                              BlocProvider.of<HomeCubit>(context).addOrRemoveFromFavorite(filteredFurniture[index].furnitureId);
                                              BlocProvider.of<HomeCubit>(context).emit(AddOrRemoveFavoriteState());
                                            },
                                            child: filteredFurniture[index].isFavorite ? FavoriteIcon(iconLogo: Icons.favorite, iconColor: kAppBackgroundColor,) : FavoriteIcon(iconLogo: Icons.favorite_border_rounded, iconColor: kAppBackgroundColor,),
                                            style: TextButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                              minimumSize: Size(0, 0),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 30.0,
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              print('Add to cart');
                                              BlocProvider.of<HomeCubit>(context).addToCart(filteredFurniture[index].furnitureId, filteredFurniture[index].shared[0].color, 1);
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                content: Text('Added to cart successfully !'),
                                              ));
                                              },
                                            child: Icon(
                                              Icons.add_shopping_cart,
                                              color: kAppBackgroundColor,
                                            ),
                                            style: TextButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                              minimumSize: Size(0, 0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: -32,
                                  right: 30.0,
                                  child: Container(
                                    //padding: EdgeInsets.only(top: 10.0),
                                    height: MediaQuery.of(context).size.height * 0.26,
                                    width: MediaQuery.of(context).size.width * 0.45,
                                    child: Image.network(
                                      filteredFurniture[index].shared[selectedColorIndex].image,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> getMoreFurniture() async {
    print("hna");
    await BlocProvider.of<HomeCubit>(context).getFurniture(
        BlocProvider
            .of<HomeCubit>(context)
            .categories[CategoriesScroller.selectedCategoryIndex].name, limit: 3);
  }
}
