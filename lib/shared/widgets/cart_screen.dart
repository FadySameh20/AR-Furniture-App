import 'dart:convert';

import 'package:ar_furniture_app/cubits/home_cubit.dart';
import 'package:ar_furniture_app/cubits/home_states.dart';
import 'package:ar_furniture_app/shared/cache/sharedpreferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class CartScreen extends StatefulWidget {


  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<String> names = <String>['chair1', 'chair2', 'chair3', 'chair4'];

  List<String> images = <String>[
    'assets/Item_1.png',
    'assets/Item_1.png',
    'assets/Item_1.png',
    'assets/Item_1.png'
  ];

  List<int> prices = <int>[100, 200, 300, 400];
  List<String> quantities = [];
  Map<String, dynamic> cartMap = {};

  @override
  void initState() {
    // TODO: implement initState
    print('Ya3maaa');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await this.setCache();
      setState(() { });
    });
  }

  Future<void> setCache() async {
    cartMap = await json.decode(CacheHelper.getData('cart')) ?? {};
    print("Cart Map");
    print(cartMap);
  }

  // void setLists() {
  //
  //   print("Quantities");
  //   print(quantities);
  // }

  @override
  Widget build(BuildContext context)  {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        cartMap.forEach((key, value) {
          value.forEach((element) {
            quantities.add(BlocProvider.of<HomeCubit>(context).furnitureList.where((element) => element.furnitureId == key).first.shared[element].quantityCart);
          });
        });
        print("Quantities");
        print(quantities);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(191, 122, 47, 1),
            actions: [
              IconButton(onPressed: () {}, icon: Icon(Icons.shopping_cart))
            ],
            centerTitle: true,
            title: Text(
              "Cart",
              style: TextStyle(),
            ),
          ),
          body: Stack(
            children: [
              Container(
                height: double.infinity,
              ),
              Container(
                height: MediaQuery.of(context).size.height / 1.2,
                width: MediaQuery.of(context).size.width,
                //color: Colors.white,
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.8),
                      child: Container(
                        height: 60,
                        color: Colors.white,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Material(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.asset(
                                    images[index],
                                    fit: BoxFit.contain,
                                  )),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      names[index],
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          //width:MediaQuery.of(context).size.width*.4,

                                          color: Colors.grey.shade200,
                                          height: MediaQuery.of(context).size.height *
                                              .02,
                                          child: Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.only(
                                                    bottom: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                        .02),
                                                child: Icon(
                                                  Icons.minimize,
                                                  size: 10,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    .06,
                                              ),
                                              Text(
                                                "1",
                                                overflow: TextOverflow.ellipsis,
                                                //textAlign:TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 8, color: Colors.black),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    .06,
                                              ),
                                              Icon(
                                                Icons.add,
                                                size: 10,
                                                color: Colors.black,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Text(
                                            '\EGP ${prices[index].toString()}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
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
                    );
                  },
                  itemCount: names.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 2,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
