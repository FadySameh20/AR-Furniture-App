import 'package:ar_furniture_app/shared/widgets/favorite_icon.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';

class Search extends StatelessWidget {
  //const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    cursorColor: kAppBackgroundColor,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                      hintText: 'What are you looking for?',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: kAppBackgroundColor,
                        size: 25,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 5.0, top: 5.0),
                    ),
                  ),
                ),
              ),
              Material(
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.filter_list,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
                borderRadius: BorderRadius.circular(10),
                color: kAppBackgroundColor,
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
          /*Text(
            "Categories",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),*/
          //Add Categories Amr
          const Text(
            "Recently Viewed",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 10,
          ),

          Container(
            height: MediaQuery.of(context).size.height > 350
                ? MediaQuery.of(context).size.height * 0.45
                : MediaQuery.of(context).size.height * 0.3,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 25.0),
                  child: Container(
                    padding: EdgeInsets.all(12.0),
                    width: MediaQuery.of(context).size.width > 200
                        ? MediaQuery.of(context).size.width * 0.45
                        : MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FavoriteIcon(iconLogo: Icons.favorite_border_rounded),
                          ],
                        ),
                        Container(
                            height: MediaQuery.of(context).size.height/5,
                            width: MediaQuery.of(context).size.width/3,
                            child: Image.asset('assets/Item_1.png')
                        ),
                        Text(
                          "Havan Chair",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "EGP 5,000",
                              style: TextStyle(
                                color: kAppBackgroundColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Spacer(),
                            Material(
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.add_shopping_cart,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                              borderRadius: BorderRadius.circular(10),
                              color: kAppBackgroundColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 25.0),
                  child: Container(
                    padding: EdgeInsets.all(12.0),
                    width: MediaQuery.of(context).size.width > 200
                        ? MediaQuery.of(context).size.width * 0.45
                        : MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FavoriteIcon(iconLogo: Icons.favorite_border_rounded),
                          ],
                        ),
                        Container(
                            height: MediaQuery.of(context).size.height/5,
                            width: MediaQuery.of(context).size.width/3,
                            child: Image.asset('assets/Item_1.png')
                        ),
                        Text(
                          "Havan Chair",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "EGP 5,000",
                              style: TextStyle(
                                color: kAppBackgroundColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Spacer(),
                            Material(
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.add_shopping_cart,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                              borderRadius: BorderRadius.circular(10),
                              color: kAppBackgroundColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 25.0),
                  child: Container(
                    padding: EdgeInsets.all(12.0),
                    width: MediaQuery.of(context).size.width > 200
                        ? MediaQuery.of(context).size.width * 0.45
                        : MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FavoriteIcon(iconLogo: Icons.favorite_border_rounded),
                          ],
                        ),
                        Container(
                            height: MediaQuery.of(context).size.height/5,
                            width: MediaQuery.of(context).size.width/3,
                            child: Image.asset('assets/Item_1.png')
                        ),
                        Text(
                          "Havan Chair",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "EGP 5,000",
                              style: TextStyle(
                                color: kAppBackgroundColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Spacer(),
                            Material(
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.add_shopping_cart,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                              borderRadius: BorderRadius.circular(10),
                              color: kAppBackgroundColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
