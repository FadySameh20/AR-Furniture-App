import 'package:ar_furniture_app/shared/widgets/favorite_icon.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';
import 'categories_scroller.dart';

class HomePage extends StatelessWidget {
  List<String> furniture = ["Chair", "Sofa", "Drawer"];
  List<String> images = [
    "assets/chair.png",
    "assets/seater-sofa.png",
    "assets/drawers.png"
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
            items: [
              "assets/furniture_sale.png",
              "assets/furniture_sale2.jpg",
              "assets/furniture_sale3.jpeg"
            ].map((i) {
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
                        child: Image.asset(
                          i,
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
                                    children: const [
                                      Text(
                                        "Curtains",
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
                                        color: Colors.yellow,size: 20,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow,size: 20,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow,size: 20,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Colors.grey,size: 20,
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: Row(
                                    children: [
                                      const Text(
                                        "\$75",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17),
                                      ),
                                      const Spacer(),
                                      FavoriteIcon(iconLogo: Icons.favorite_border_rounded),
                                      const Text(
                                        "(123)",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17),
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
              itemCount: 2,
            ),
          ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
