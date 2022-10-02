import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  //const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  cursorColor: const Color.fromRGBO(191, 122, 47, 1),
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
                      color: Color.fromRGBO(191, 122, 47, 1),
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
              color: const Color.fromRGBO(191, 122, 47, 1),
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
          height: MediaQuery.of(context).size.height > 700
              ? MediaQuery.of(context).size.height * 0.57
              : MediaQuery.of(context).size.height * 0.45,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 25.0),
                child: Container(
                  padding: EdgeInsets.all(12.0),
                  width: MediaQuery.of(context).size.width > 700
                      ? MediaQuery.of(context).size.width * 0.53
                      : MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.favorite_border),
                        ],
                      ),
                      Image.asset('assets/Item_1.png'),
                      Text(
                        "Havan Chair",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              "EGP 5,000",
                              style: TextStyle(
                                color: Color.fromRGBO(191, 122, 47, 1),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Material(
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.add_shopping_cart,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromRGBO(191, 122, 47, 1),
                            ),
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
                  width: MediaQuery.of(context).size.width > 700
                      ? MediaQuery.of(context).size.width * 0.53
                      : MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.favorite_border),
                        ],
                      ),
                      Image.asset('assets/Item_1.png'),
                      Text(
                        "Havan Chair",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              "EGP 5,000",
                              style: TextStyle(
                                color: Color.fromRGBO(191, 122, 47, 1),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Material(
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.add_shopping_cart,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromRGBO(191, 122, 47, 1),
                            ),
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
                  width: MediaQuery.of(context).size.width > 700
                      ? MediaQuery.of(context).size.width * 0.53
                      : MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.favorite_border),
                        ],
                      ),
                      Image.asset('assets/Item_1.png'),
                      Text(
                        "Havan Chair",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              "EGP 5,000",
                              style: TextStyle(
                                color: Color.fromRGBO(191, 122, 47, 1),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Material(
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.add_shopping_cart,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromRGBO(191, 122, 47, 1),
                            ),
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
    );
  }
}
