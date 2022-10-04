import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  List<String> furniture = ["Chair", "Sofa", "Drawer"];
  List<String> categoriesImages = [
    "assets/chair.png",
    "assets/seater-sofa.png",
    "assets/drawers.png"
  ];

  List<String> furnitureImages = [
    "assets/Item_1.png",
    "assets/Item_2.png",
    "assets/Item_3.png",
    "assets/Item_1.png",
    "assets/Item_2.png",
    "assets/Item_3.png",
    "assets/Item_1.png",
    "assets/Item_2.png",
    "assets/Item_3.png",
  ];

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 15.0),
          height: MediaQuery.of(context).size.height > 700
              ? MediaQuery.of(context).size.height * 0.15
              : MediaQuery.of(context).size.height * 0.175,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: furniture.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15.0, left: 15, right: 15),
                  child: Container(
                    height: 30,
                    width: 70,
                    decoration: BoxDecoration(
                        color: index == 1
                            ? const Color.fromRGBO(191, 122, 47, 1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(50)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                              child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.grey[300],
                            // radius: 10,
                            child: Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: Image.asset(
                                categoriesImages[index],
                                fit: BoxFit.fill,
                              ),
                            ),
                          )),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            furniture[index],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color:
                                    index == 1 ? Colors.white : Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
        Expanded(
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: 90),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(191, 122, 47, 0.2),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    topLeft: Radius.circular(20.0),
                  ),
                ),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: furnitureImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
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
                              color: Colors.white,
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
                                'EGP 300',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(191, 122, 47, 1),
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
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 15.0,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        print('Add to favorites');
                                      },
                                      child: Icon(
                                        Icons.favorite_border_rounded,
                                        color: Color.fromRGBO(191, 122, 47, 1),
                                      ),
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
                                      },
                                      child: Icon(
                                        Icons.add_shopping_cart,
                                        color: Color.fromRGBO(191, 122, 47, 1),
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
                              child: Image.asset(
                                furnitureImages[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ],
          ),
        ),
      ],
    );
  }
}
