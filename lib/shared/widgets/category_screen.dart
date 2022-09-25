import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  List<String> categories = ['Chairs', 'Sofas', 'Beds', 'Comodes', 'Drawers'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(top: 20.0, left: 15.0),
                padding: EdgeInsets.all(5.0),
                child: Center(
                  child: Text(
                    categories[index],
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black38,
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: 25,
        ),
        Expanded(
          flex: 11,
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: 60),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    topLeft: Radius.circular(20.0),
                  ),
                ),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          top: 18.0, left: 12.0, right: 12.0, bottom: 8.0),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              padding: EdgeInsets.all(5.0),
                              child: Text('EGP 300'),
                              decoration: BoxDecoration(
                                color: Colors.yellow[700],
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, bottom: 20.0, right: 8.0),
                            child: Align(
                              child: ListTile(
                                title: Text('Havan Chair'),
                                subtitle: Text('Comfortable'),
                              ),
                              alignment: Alignment.centerLeft,
                            ),
                          ),
                          // Align(
                          //   alignment: Alignment.topCenter,
                          //   child: Image.asset("assets/Item_1.png"),
                          // ),
                          Positioned(
                            top: -20,
                            right: 30.0,
                            child: Container(
                              height: 125.0,
                              width: 125.0,
                              child: Image.asset(
                                "assets/Item_1.png",
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
