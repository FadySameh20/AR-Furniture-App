import 'dart:convert';

import 'package:ar_furniture_app/cubits/home_cubit.dart';
import 'package:ar_furniture_app/cubits/home_states.dart';
import 'package:ar_furniture_app/shared/cache/sharedpreferences.dart';
import 'package:ar_furniture_app/shared/constants/constants.dart';
import 'package:ar_furniture_app/shared/widgets/circle_avatar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/furniture_model.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CartScreen extends StatefulWidget {
  // List<FurnitureModel> furnitureList;
  // CartScreen({required this.furnitureList});

  List<FurnitureModel> furnitureList;
  Map<String, dynamic> cartMap;

  CartScreen({required this.furnitureList, required this.cartMap});


  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<String> furnitureNames = [];
  List<String> furnitureImages = [];
  List<String> furniturePrices = [];
  List<String> furnitureQuantities = [];
  List<String> availableQuantity = [];
  // Map<String, dynamic> cartMap = {};
  List<String> furnitureIds=[];
  List<String> furnitureColors=[];

  var quantity = 0;
  double subTotal = 0;
  double tax = 0;
  double totalPrice = 0;
  bool flag = false;
  double estimatingTax = 0.14;

  @override
  void initState() {
    // TODO: implement initState

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // await this.setCache();
      setCartData();
      setState(() {});
    });
  }

  // Future<void> setCache() async {
  //   cartMap = await json.decode(CacheHelper.getData('cart')) ?? {};
  //   print("Cart Map");
  //   print(cartMap);
  // }

  void setCartData() {
    print("Cart");
    print(widget.cartMap);
    widget.cartMap.forEach((key, value) {
      value.forEach((element) {

        if (int.parse(element.quantityCart) > 0) {
          furnitureQuantities.add(element.quantityCart);
          furnitureImages.add(element.image);
          availableQuantity.add(element.quantity);
          furniturePrices.add(element.price);
          furnitureColors.add(element.color);
          print("furnitureCOLORS");
          print(furnitureColors);
          furnitureNames.add(widget.furnitureList
              .where((element) => element.furnitureId == key)
              .first
              .name);

          furnitureIds.add(widget.furnitureList
              .where((element) => element.furnitureId == key)
              .first
              .furnitureId);
        }
      });
    });
    for (int i = 0; i < furniturePrices.length; i++) {
      subTotal +=
          int.parse(furnitureQuantities[i]) * int.parse(furniturePrices[i]);
    }

    tax = subTotal * estimatingTax;
    totalPrice = subTotal + tax;

    print(furnitureQuantities);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if(state is ErrorInCheckout) {
            Alert(
              context: context,
              type: AlertType.warning,
              title: "Unavailable Quantity",
              desc: BlocProvider.of<HomeCubit>(context).unavailableQuantityFurniture.join('\n\n'),
              buttons: [
                DialogButton(
                  child: Text(
                    "OK",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () => Navigator.pop(context),
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
          } else if(state is CheckoutSuccessfully) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Added to cart successfully !'),
            ));
            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          }
        },
        builder: (context, state) {
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

            // height: MediaQuery.of(context).size.height * 0.6,
            // flex: 2,
            body: Stack(
              children: [
                Container(
                  child: ListView.builder(
                    itemCount: furnitureNames.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: UniqueKey(),
                        // Provide a function that tells the app
                        // what to do after an item has been swiped away
                        onDismissed: (direction) {
                          BlocProvider.of<HomeCubit>(context).removeFromCart(
                              furnitureIds[index], furnitureColors[index]);
                          subTotal =subTotal- (int.parse(
                              furniturePrices[index])*int.parse(
                              furnitureQuantities[index]));
                          tax = subTotal *
                              estimatingTax;
                          totalPrice =
                          (subTotal + tax);
                          // Remove the item from the data source.
                          setState(() {
                            furnitureNames.removeAt(index);

                          });

                          // Then show a snackbar.
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('$furnitureNames dismissed')));
                        },
                        // Show a red background as the item is swiped away.
                        background: ColoredBox(color: Colors.red,child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.delete),
                          ),
                        ),),

                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(30),
                            child: Stack(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Image.network(
                                            furnitureImages[index],
                                            fit: BoxFit.contain,
                                          ),
                                        )),
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            furnitureNames[index],
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  print(int.parse(
                                                      furnitureQuantities[
                                                          index]));
                                                  setState(() {
                                                    if (int.parse(
                                                            furnitureQuantities[
                                                                index]) >
                                                        1) {
                                                      quantity = int.parse(
                                                          furnitureQuantities[
                                                              index]);
                                                      quantity--;

                                                      print("Quantityyyy");
                                                      print(furnitureQuantities[
                                                          index]);
                                                      furnitureQuantities[index] =
                                                          quantity.toString();
                                                      subTotal -= int.parse(
                                                          furniturePrices[index]);
                                                      tax = subTotal *
                                                          estimatingTax;
                                                      totalPrice =
                                                          (subTotal + tax);

                                                      BlocProvider.of<HomeCubit>(context).addToCart(
                                                          furnitureIds[index], furnitureColors[index], quantity);
                                                      print('minus quantity');
                                                      print(furnitureQuantities[
                                                          index]);
                                                    }
                                                  });
                                                },
                                                child: CustomCircleAvatar(
                                                  radius: MediaQuery.of(context)
                                                              .size
                                                              .height >
                                                          700
                                                      ? 15.0
                                                      : 12.0,
                                                  CavatarColor:
                                                      kAppBackgroundColor,
                                                  icon: Icon(
                                                    Icons.remove,
                                                    size: MediaQuery.of(context)
                                                                .size
                                                                .height >
                                                            700
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
                                                furnitureQuantities[index],
                                                style: TextStyle(
                                                  fontSize: MediaQuery.of(context)
                                                              .size
                                                              .height >
                                                          700
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
                                                  if (int.parse(
                                                              furnitureQuantities[
                                                                  index]) +
                                                          1 <=
                                                      int.parse(availableQuantity[
                                                          index])) {
                                                    quantity = int.parse(
                                                        furnitureQuantities[
                                                            index]);
                                                    setState(() {
                                                      quantity++;
                                                      furnitureQuantities[index] =
                                                          quantity.toString();
                                                      subTotal += int.parse(
                                                          furniturePrices[index]);
                                                      tax = subTotal *
                                                          estimatingTax;
                                                      totalPrice = subTotal + tax;
                                                      BlocProvider.of<HomeCubit>(context).addToCart(
                                                          furnitureIds[index], furnitureColors[index], quantity);
                                                      print('quantity new:');
                                                      print(furnitureQuantities[
                                                          index]);
                                                    });
                                                  }
                                                },
                                                child: CustomCircleAvatar(
                                                  radius: MediaQuery.of(context)
                                                              .size
                                                              .height >
                                                          700
                                                      ? 15.0
                                                      : 12.0,
                                                  CavatarColor:
                                                      kAppBackgroundColor,
                                                  icon: Icon(
                                                    Icons.add,
                                                    size: MediaQuery.of(context)
                                                                .size
                                                                .height >
                                                            700
                                                        ? 22.0
                                                        : 18.0,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              Spacer(),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10.0),
                                                child: Text(
                                                  '\EGP ${furniturePrices[index]}',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.35,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                            topLeft: Radius.circular(30)),
                      ),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Sub Total            "),
                                  Text("\EGP ${subTotal.toStringAsFixed(2)}"),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Text("Shipping fee    "),
                              //     Text('\EGP 300'),
                              //   ],
                              // ),
                              // SizedBox(
                              //   height: 10,
                              // ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Estimating Tax(14%)            "),
                                  Text("\EGP ${tax.toStringAsFixed(2)}"),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Divider(
                                color: Colors.black,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Total"),
                                  Text("\EGP ${totalPrice.toStringAsFixed(2)}"),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10),
                                            backgroundColor:
                                                Color.fromRGBO(191, 122, 47, 1),
                                          ),
                                          onPressed: () async {
                                            await BlocProvider.of<HomeCubit>(context).checkAvailableFurnitureQuantity(context);
                                          },
                                          child: Text(
                                            "Checkout",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ))),
                                ],
                              )
                            ],
                          ),
                        ),
                      )),
                )
              ],
            ),
          );
        });
  }
}
