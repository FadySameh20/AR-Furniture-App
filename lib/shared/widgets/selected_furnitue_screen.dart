import 'dart:convert';

import 'package:ar_furniture_app/cubits/home_cubit.dart';
import 'package:ar_furniture_app/cubits/home_states.dart';
import 'package:ar_furniture_app/models/furniture_model.dart';
import 'package:ar_furniture_app/shared/cache/sharedpreferences.dart';
import 'package:ar_furniture_app/shared/widgets/cart_screen.dart';
import 'package:ar_furniture_app/shared/widgets/favorite_icon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../constants/constants.dart';
import 'circle_avatar.dart';

class SelectedFurnitureScreen extends StatefulWidget {
  FurnitureModel selectedFurniture;
  List<Color?> availableColors;

  SelectedFurnitureScreen(
      {required this.selectedFurniture, required this.availableColors});

  @override
  State<SelectedFurnitureScreen> createState() =>
      _SelectedFurnitureScreenState();
}

class _SelectedFurnitureScreenState extends State<SelectedFurnitureScreen> {
  int quantity = 1;
  int selectedColorIndex = 0;

  Color? selectedColor;


  // Map<String, dynamic> cartMap = {};

  // List<ColorSwatch> availableColors = [
  //   Colors.red,
  //   Colors.deepOrange,
  //   // Colors.yellow,
  //   // Colors.lightGreen,
  //   // Colors.blue,
  // ];

  // @override
  // void initState() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     await this.isFavorite();
  //     setState(() { });
  //   });
  // }
  //
  // Future<void> isFavorite() async {
  //   List<String> favorites = await CacheHelper.getData("favorites") ?? [];
  //   print("Favorites");
  //   print(favorites);
  //   if(favorites.contains(widget.selectedFurniture.furnitureId)) {
  //     widget.selectedFurniture.isFavorite = true;
  //   }
  // }

  @override

  void initState() {
    selectedColor = widget.availableColors[0];
  }
  //
  // Future<void> isFavorite() async {
  //   List<String> favorites = await CacheHelper.getData("favorites") ?? [];
  //   print("Favorites");
  //   print(favorites);
  //   if(favorites.contains(widget.selectedFurniture.furnitureId)) {
  //     widget.selectedFurniture.isFavorite = true;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(191, 122, 47, 1),
            actions: [
              IconButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    CartScreen(furnitureList: BlocProvider
                        .of<HomeCubit>(context)
                        .furnitureList, cartMap: BlocProvider
                        .of<HomeCubit>(context)
                        .cache.cartMap)));
              }, icon: Icon(Icons.shopping_cart))
            ],
            centerTitle: true,
            title: Text(
              widget.selectedFurniture.name,
              style: TextStyle(),
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: MediaQuery
                    .of(context)
                    .size
                    .height > 700 ? 1 : 2,
                child: Container(
                  child: Stack(
                    children: [
                      Positioned(
                        top: MediaQuery
                            .of(context)
                            .size
                            .height > 700
                            ? -MediaQuery
                            .of(context)
                            .size
                            .height * 0.31
                            : -MediaQuery
                            .of(context)
                            .size
                            .height * 0.36,
                        left: MediaQuery
                            .of(context)
                            .size
                            .height > 700
                            ? -MediaQuery
                            .of(context)
                            .size
                            .height * 0.182
                            : -MediaQuery
                            .of(context)
                            .size
                            .height * 0.155,
                       child: CustomCircleAvatar(
                          radius: MediaQuery
                              .of(context)
                              .size
                              .height > 700
                              ? MediaQuery
                              .of(context)
                              .size
                              .width * 0.5
                              : MediaQuery
                              .of(context)
                              .size
                              .width * 0.45,
                          CavatarColor: kAppBackgroundColorLowOpacity,
                        ),

                        // child: CircleAvatar(
                        //   radius: MediaQuery.of(context).size.height > 700
                        //       ? MediaQuery.of(context).size.width * 0.5
                        //       : MediaQuery.of(context).size.width * 0.45,
                        //   backgroundColor: kAppBackgroundColorLowOpacity,
                        // ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          color: Colors.transparent,
                          child: Image.network(widget.selectedFurniture.shared[selectedColorIndex].image),
                        ),
                      ),
                      Positioned(
                        top: 15.0,
                        right: 15.0,
                        child: GestureDetector(
                              onTap: () {
                                int tempIndex = BlocProvider.of<HomeCubit>(context).furnitureList.indexWhere((element) => element.furnitureId == widget.selectedFurniture.furnitureId);
                                BlocProvider.of<HomeCubit>(context)
                                    .addOrRemoveFromFavorite(tempIndex);
                                BlocProvider.of<HomeCubit>(context).emit(
                                    AddOrRemoveFavoriteState());
                              },
                              child: widget.selectedFurniture.isFavorite
                                  ? FavoriteIcon(
                                iconLogo: Icons.favorite,
                                iconColor: kAppBackgroundColor,
                              )
                                  : FavoriteIcon(
                                iconLogo: Icons.favorite_border_rounded,
                                iconColor: kAppBackgroundColor,
                              ),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height > 700 ? 20.0 : 1.0,
              ),
              Expanded(
                flex: MediaQuery
                    .of(context)
                    .size
                    .height > 700 ? 3 : 6,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: ListTile(
                          contentPadding: EdgeInsets.only(
                              left: 0.0, right: 0.0),
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text(
                              widget.selectedFurniture.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          subtitle: widget.selectedFurniture.description == null
                              ? null
                              : Text(
                            widget.selectedFurniture.description!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.italic),
                          ),
                          trailing: Padding(
                            padding: EdgeInsets.only(bottom: 22.0, right: 0),
                            child: Container(
                              width: MediaQuery.of(context).size.width/1.5,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    (double.parse(widget.selectedFurniture
                                        .shared[selectedColorIndex]
                                        .price)).toStringAsFixed(2)+
                                        ' L.E',
                                    style: TextStyle(
                                      decoration: widget.selectedFurniture.shared[selectedColorIndex].discount!="0"?TextDecoration.lineThrough:null,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                      color: kAppBackgroundColor,
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  if(widget.selectedFurniture.shared[selectedColorIndex].discount!="0")

                                    Text(

                                      '${(double.parse(widget.selectedFurniture
                                        .shared[selectedColorIndex]
                                        .price) -( (double.parse(widget.selectedFurniture.shared[selectedColorIndex].discount)/100)*double.parse(widget.selectedFurniture
                                          .shared[selectedColorIndex]
                                          .price))).toStringAsFixed(2)} L.E',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                      color: kAppBackgroundColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height:
                        MediaQuery
                            .of(context)
                            .size
                            .height > 700 ? 10.0 : 15.0,
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            RatingBar.builder(
                              itemSize: 20.0,
                              initialRating:
                              widget.selectedFurniture
                                  .calculateAverageRating()
                                  .toString() == "NaN" ? 0.0: widget.selectedFurniture.calculateAverageRating(),
                              //minRating: 1,
                              direction: Axis.horizontal,
                              // allowHalfRating: true,
                              ignoreGestures: true,
                              itemCount: 5,
                              itemPadding: EdgeInsets.symmetric(
                                  horizontal: 1.0),
                              itemBuilder: (context, _) =>
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                              onRatingUpdate: (rating) {
                                //   print("Rating: " + rating.toString());
                                //   setState(() {
                                //     starsRating = rating;
                                //   });
                              },
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              widget.selectedFurniture
                                  .calculateAverageRating()
                                  .toString() == "NaN" ? "No ratings yet": widget.selectedFurniture
                                  .calculateAverageRating()
                                  .toString(),
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () {
                                Alert(
                                  context: context,
                                  //type: AlertType.success,
                                  //title: "Rating",
                                  desc: BlocProvider.of<HomeCubit>(context).unavailableQuantityFurniture.join('\n\n'),
                                  content: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(Icons.rate_review, size: 50.0, color: kAppBackgroundColor,),
                                      SizedBox(height: 20.0,),
                                      Text("Rating", style: TextStyle(fontSize: 23.0, letterSpacing: 0.8),),
                                      SizedBox(height: 20.0,),
                                      RatingBar.builder(
                                        itemSize: 30.0,
                                        initialRating: 1,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        // allowHalfRating: true,
                                        // ignoreGestures: true,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 1.0),
                                        itemBuilder: (context, _) =>
                                            Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                        onRatingUpdate: (rating) {
                                            print("Rating: " + rating.toString());
                                            setState(() {
                                              widget.selectedFurniture.ratings.add(rating);
                                            });
                                        },
                                      ),
                                    ],
                                  ),
                                  buttons: [
                                    DialogButton(
                                      child: Text(
                                        "Rate",
                                        style: TextStyle(color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () async {
                                        await  FirebaseFirestore.instance.collection('category').doc(widget.selectedFurniture.category).collection("furniture").doc(widget.selectedFurniture.furnitureId).update({"ratings": widget.selectedFurniture.ratings});
                                        setState(() {});
                                        Navigator.pop(context);
                                      } ,
                                      color: kAppBackgroundColor,
                                    ),
                                  ],
                                  style: AlertStyle(
                                    animationType: AnimationType.fromTop,
                                    animationDuration: Duration(milliseconds: 400),
                                    titleStyle: TextStyle(
                                      color: Colors.red,
                                    ),
                                    descStyle: TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                ).show();
                              },
                              child: Text(
                                'Add a review ?',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height:
                        MediaQuery
                            .of(context)
                            .size
                            .height > 700 ? 10.0 : 1.0,
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Text(
                              'Color',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              width: 54.5,
                            ),
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: widget.availableColors.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedColorIndex = index;

                                        selectedColor = widget.availableColors[index];

                                        //   chosenColor = availableColors[index];
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 8.0),
                                      child: CustomCircleAvatar(
                                        radius:
                                        MediaQuery
                                            .of(context)
                                            .size
                                            .height > 700
                                            ? 15.0
                                            : 12.0,
                                        CavatarColor: widget
                                            .availableColors[index],
                                        icon: index == selectedColorIndex
                                            ? Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: MediaQuery
                                              .of(context)
                                              .size
                                              .height >
                                              700
                                              ? 22.0
                                              : 18.0,
                                        )
                                            : null,
                                      ),
                                      // child:CircleAvatar(
                                      //   backgroundColor: availableColors[index],
                                      //   radius:
                                      //   MediaQuery.of(context).size.height > 700
                                      //       ? 15.0
                                      //       : 12.0,
                                      //   child: index == selectedColorIndex
                                      //       ? Icon(
                                      //     Icons.check,
                                      //     color: Colors.white,
                                      //     size: MediaQuery.of(context)
                                      //         .size
                                      //         .height >
                                      //         700
                                      //         ? 22.0
                                      //         : 18.0,
                                      //   )
                                      //       : null,
                                      // ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height:
                        MediaQuery
                            .of(context)
                            .size
                            .height > 700 ? 15.0 : 10.0,
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Text(
                              'Quantity',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .height > 700
                                  ? 30.0
                                  : 32.0,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (quantity > 1) {
                                    quantity--;
                                  }
                                });
                              },
                              child: CustomCircleAvatar(
                                radius: MediaQuery
                                    .of(context)
                                    .size
                                    .height > 700
                                    ? 15.0
                                    : 12.0,
                                CavatarColor: kAppBackgroundColor,
                                icon: Icon(
                                  Icons.remove,
                                  size: MediaQuery
                                      .of(context)
                                      .size
                                      .height > 700
                                      ? 22.0
                                      : 18.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              quantity.toString(),
                              style: TextStyle(
                                fontSize: MediaQuery
                                    .of(context)
                                    .size
                                    .height > 700
                                    ? 20.0
                                    : 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            InkWell(
                              onTap: () {
                                if (quantity + 1 <=
                                    int.parse(widget.selectedFurniture
                                        .shared[selectedColorIndex].quantity)) {
                                  setState(() {
                                    quantity++;
                                  });
                                }
                              },
                              child: CustomCircleAvatar(
                                radius: MediaQuery
                                    .of(context)
                                    .size
                                    .height > 700
                                    ? 15.0
                                    : 12.0,
                                CavatarColor: kAppBackgroundColor,
                                icon: Icon(
                                  Icons.add,
                                  size: MediaQuery
                                      .of(context)
                                      .size
                                      .height > 700
                                      ? 22.0
                                      : 18.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Spacer(),
                            Text(
                              "(Available Quantity: " +
                                  widget.selectedFurniture
                                      .shared[selectedColorIndex].quantity +
                                  ")",
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height:
                        MediaQuery
                            .of(context)
                            .size
                            .height > 700 ? 15.0 : 10.0,
                      ),
                      Expanded(
                        flex: 3,
                        child: Center(
                          child: ElevatedButton(
                                onPressed: () async {

                                  print("Selected Color");
                                  print('#${selectedColor!.value.toRadixString(16)}');
                                  print("Red: " + selectedColor!.red.toRadixString(16).padLeft(2, '0').toString().toUpperCase());
                                  print("Green: " + selectedColor!.green.toRadixString(16).padLeft(2, '0').toString().toUpperCase());
                                  print("Blue: " + selectedColor!.blue.toRadixString(16).padLeft(2, '0').toString().toUpperCase());
                                  String color = "#" + selectedColor!.red.toRadixString(16).padLeft(2, '0').toString().toUpperCase() + selectedColor!.green.toRadixString(16).padLeft(2, '0').toString().toUpperCase() + selectedColor!.blue.toRadixString(16).padLeft(2, '0').toString().toUpperCase();
                                  print(color);
                                  BlocProvider.of<HomeCubit>(context).addToCart(
                                      widget.selectedFurniture.furnitureId,
                                      color, quantity);

                                  // widget
                                  //     .selectedFurniture
                                  //     .shared[selectedColorIndex]
                                  //     .isAddedCart = true;
                                  // widget
                                  //     .selectedFurniture
                                  //     .shared[selectedColorIndex]
                                  //     .quantityCart = quantity.toString();

                                  // List<int> indices = [];
                                  // if (cartMap.keys.contains(cartMap[
                                  //     widget.selectedFurniture.furnitureId])) {
                                  //   indices = cartMap[
                                  //       widget.selectedFurniture.furnitureId];
                                  //   if (indices.contains(selectedColorIndex)) {
                                  //     return;
                                  //   }
                                  // }

                                  // indices.add(selectedColorIndex);
                                  // cartMap[widget.selectedFurniture.furnitureId] =
                                  //     indices;
                                  //
                                  // BlocProvider.of<HomeCubit>(context).updateCartInFirestore(widget.selectedFurniture);
                                  //
                                  // print("Encoded String");
                                  // print(json.encode(cartMap));
                                  // CacheHelper.setMap(
                                  //     key: 'cart', value: json.encode(cartMap));
                                  //}
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CartScreen(
                                            furnitureList: BlocProvider
                                                .of<HomeCubit>(context)
                                                .furnitureList,
                                            cartMap: BlocProvider
                                                .of<HomeCubit>(context)
                                                .cache.cartMap)),
                                  );
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.add_shopping_cart,
                                      size: MediaQuery
                                          .of(context)
                                          .size
                                          .height > 700
                                          ? 24.0
                                          : 21.0,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(
                                      'Add to cart',
                                      style: TextStyle(
                                        fontSize:
                                        MediaQuery
                                            .of(context)
                                            .size
                                            .height > 700
                                            ? 18.0
                                            : 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  backgroundColor: kAppBackgroundColor,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                ),
                              ),
                        ),
                      ),
                      SizedBox(
                        height:
                        MediaQuery
                            .of(context)
                            .size
                            .height > 700 ? 20.0 : 10.0,
                      ),
                      Text(
                        'Recommendations',
                        style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                      ),
                      Expanded(
                        flex: 9,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: BlocProvider.of<HomeCubit>(context).recommendedFurniture.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                InkWell(
                                  onTap: () {
                                    List<Color?> availableColors = [];
                                    availableColors = BlocProvider.of<HomeCubit>(context).getAvailableColorsOfFurniture(BlocProvider.of<HomeCubit>(context).recommendedFurniture[index]);
                                    Navigator.pop(context);
                                    print("Recoo " + BlocProvider.of<HomeCubit>(context).recommendedFurniture[index].name);
                                    FurnitureModel selectedRecommendedFurniture = BlocProvider.of<HomeCubit>(context).recommendedFurniture[index];
                                    BlocProvider.of<HomeCubit>(context).getFurnitureRecommendation(BlocProvider.of<HomeCubit>(context).recommendedFurniture[index], 0);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => SelectedFurnitureScreen(selectedFurniture: selectedRecommendedFurniture, availableColors: availableColors)),
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        right: 20.0, top: 20.0, bottom: 10.0),
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(191, 122, 47, 0.2),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Image.network(BlocProvider.of<HomeCubit>(context).recommendedFurniture[index].shared[0].image),
                                        ),
                                        Text(BlocProvider.of<HomeCubit>(context).recommendedFurniture[index].name),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 25.0,
                                  right: 29.0,
                                  child: InkWell(
                                    onTap: () {
                                      int tempIndex = BlocProvider.of<HomeCubit>(context).furnitureList.indexWhere((element) => element.furnitureId == BlocProvider.of<HomeCubit>(context).recommendedFurniture[index].furnitureId);
                                      BlocProvider.of<HomeCubit>(context).addOrRemoveFromFavorite(tempIndex);
                                      BlocProvider.of<HomeCubit>(context).emit(AddOrRemoveFavoriteState());
                                    },
                                    child: BlocProvider.of<HomeCubit>(context).recommendedFurniture[index].isFavorite ? FavoriteIcon(
                                      iconLogo: Icons.favorite,
                                      iconColor: kAppBackgroundColor,
                                      iconSize:
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .height > 700
                                          ? 22.0
                                          : 18.0,
                                    ): FavoriteIcon(
                                      iconLogo: Icons.favorite_border_rounded,
                                      iconColor: kAppBackgroundColor,
                                      iconSize:
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .height > 700
                                          ? 22.0
                                          : 18.0,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
