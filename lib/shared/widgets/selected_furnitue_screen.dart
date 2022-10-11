import 'package:ar_furniture_app/shared/widgets/favorite_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../constants/constants.dart';

class SelectedFurnitureScreen extends StatefulWidget {
  @override
  State<SelectedFurnitureScreen> createState() =>
      _SelectedFurnitureScreenState();
}

class _SelectedFurnitureScreenState extends State<SelectedFurnitureScreen> {
  double starsRating = 1.0;
  int quantity = 1;
  List<ColorSwatch> availableColors = [
    Colors.red,
    Colors.deepOrange,
    Colors.yellow,
    Colors.lightGreen,
    Colors.blue,
  ];
  Color? chosenColor;
  int selectedColorIndex = 0;
  int recommendationIndex = -1;
  bool addedToFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: MediaQuery.of(context).size.height > 700 ? 1 : 2,
          child: Container(
            child: Stack(
              children: [
                Positioned(
                  top: MediaQuery.of(context).size.height > 700
                      ? -MediaQuery.of(context).size.height * 0.31
                      : -MediaQuery.of(context).size.height * 0.36,
                  left: MediaQuery.of(context).size.height > 700
                      ? -MediaQuery.of(context).size.height * 0.182
                      : -MediaQuery.of(context).size.height * 0.155,
                  child: CircleAvatar(
                    radius: MediaQuery.of(context).size.height > 700
                        ? MediaQuery.of(context).size.width * 0.5
                        : MediaQuery.of(context).size.width * 0.45,
                    backgroundColor: kAppBackgroundColorLowOpacity,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    color: Colors.transparent,
                    child: Image.asset('assets/Item_1.png'),
                  ),
                ),
                Positioned(
                  top: 15.0,
                  right: 15.0,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        addedToFavorites = !addedToFavorites;
                      });
                    },
                    child: addedToFavorites
                        ? FavoriteIcon(iconLogo: Icons.favorite, iconColor: kAppBackgroundColor,)
                        : FavoriteIcon(iconLogo: Icons.favorite_border_rounded, iconColor: kAppBackgroundColor,),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height > 700 ? 20.0 : 1.0,
        ),
        Expanded(
          flex: MediaQuery.of(context).size.height > 700 ? 3 : 6,
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: ListTile(
                    contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        'Havan Chair',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    subtitle: Text(
                      'Comfortable Chair',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic),
                    ),
                    trailing: Padding(
                      padding: EdgeInsets.only(bottom: 22.0, right: 10.0),
                      child: Text(
                        '300 L.E',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: kAppBackgroundColor,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height:
                      MediaQuery.of(context).size.height > 700 ? 10.0 : 15.0,
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      RatingBar.builder(
                        itemSize: 20.0,
                        initialRating: 1,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          print("Rating: " + rating.toString());
                          setState(() {
                            starsRating = rating;
                          });
                        },
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        starsRating.toString(),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height > 700 ? 10.0 : 1.0,
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
                          itemCount: availableColors.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selectedColorIndex = index;
                                  chosenColor = availableColors[index];
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: CircleAvatar(
                                  backgroundColor: availableColors[index],
                                  radius:
                                      MediaQuery.of(context).size.height > 700
                                          ? 15.0
                                          : 12.0,
                                  child: index == selectedColorIndex
                                      ? Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: MediaQuery.of(context)
                                                      .size
                                                      .height >
                                                  700
                                              ? 22.0
                                              : 18.0,
                                        )
                                      : null,
                                ),
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
                      MediaQuery.of(context).size.height > 700 ? 15.0 : 10.0,
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Text(
                        'Quantity',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.height > 700
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
                        child: CircleAvatar(
                          radius: MediaQuery.of(context).size.height > 700
                              ? 15.0
                              : 12.0,
                          child: Icon(
                            Icons.remove,
                            size: MediaQuery.of(context).size.height > 700
                                ? 22.0
                                : 18.0,
                            color: Colors.white,
                          ),
                          backgroundColor: kAppBackgroundColor,
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        quantity.toString(),
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height > 700
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
                          setState(() {
                            quantity++;
                          });
                        },
                        child: CircleAvatar(
                          radius: MediaQuery.of(context).size.height > 700
                              ? 15.0
                              : 12.0,
                          child: Icon(
                            Icons.add,
                            size: MediaQuery.of(context).size.height > 700
                                ? 22.0
                                : 18.0,
                            color: Colors.white,
                          ),
                          backgroundColor: kAppBackgroundColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height:
                      MediaQuery.of(context).size.height > 700 ? 15.0 : 10.0,
                ),
                Expanded(
                  flex: 3,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add_shopping_cart,
                            size: MediaQuery.of(context).size.height > 700
                                ? 24.0
                                : 21.0,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            'Add to cart',
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height > 700
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
                      MediaQuery.of(context).size.height > 700 ? 20.0 : 10.0,
                ),
                Text(
                  'Recommendations',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
                Expanded(
                  flex: 9,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                right: 20.0, top: 20.0, bottom: 10.0),
                            padding: EdgeInsets.all(10.0),
                            color: Color.fromRGBO(191, 122, 47, 0.2),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Image.asset('assets/Item_1.png'),
                                ),
                                Text('Havan Chair')
                              ],
                            ),
                          ),
                          Positioned(
                            top: 22.0,
                            right: 22.0,
                            child: FavoriteIcon(
                              iconLogo: Icons.favorite_border_rounded,
                              iconColor: kAppBackgroundColor,
                              iconSize: MediaQuery.of(context).size.height > 700
                                        ? 22.0
                                        : 18.0,
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
    );
  }
}
