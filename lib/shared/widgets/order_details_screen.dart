import 'package:ar_furniture_app/shared/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/furniture_model.dart';
import '../../models/order_model.dart';

class OrderDetailsScreen extends StatelessWidget {
  List<FurnitureModel> furniture = [];
  OrderModel myOrder;
  OrderDetailsScreen(this.furniture,this.myOrder);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height - 100,
      child: Column(
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: kAppBackgroundColor,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 4,
                  width: 45,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [

                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Your Order Details",
                          style: GoogleFonts.raleway(
                            textStyle: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Order id: ${myOrder.orderId}",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.raleway(
                            textStyle: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: furniture.length * MediaQuery
                          .of(context)
                          .size
                          .height / 5.5,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width - 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[300]),
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: furniture.length,
                          itemBuilder: (context, index) {
                            return Row(
                              // mainAxisAlignment: MainAxisAlignment.,
                              children: [
                                Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width / 4,
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .height / 5.5,
                                  child: Image.network(furniture[index].shared.first.image),
                                  // color: Colors.purple,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width / 2.3,
                                      // color:Colors.red,
                                      child: Text(
                                        furniture[index].name,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: GoogleFonts.raleway(
                                          textStyle: const TextStyle(
                                              fontSize: 16,

                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "\$ ${furniture[index].shared.first.price}",
                                      style: GoogleFonts.raleway(
                                        textStyle: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(right:15.0),
                                  child: Text("${furniture[index].shared.first.quantityCart}"),
                                )
                              ],
                            );
                          }),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Your Shipping address: ",
                          style: GoogleFonts.raleway(
                            textStyle: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Text("Apartment No:${myOrder.appartmentNumber}, Floor no:${myOrder.floorNumber},Building no:${myOrder.buildingNumber}, Street no: ${myOrder.streetName},Area:${myOrder.area}"),
                    SizedBox(
                      height: 30,
                    ),
                    // Column(
                    //   children: [
                    //
                    //     Row(
                    //       mainAxisAlignment: MainAxisAlignment.start,
                    //       children: [
                    //         Text(
                    //           "Your Shipping address: ",
                    //           style: GoogleFonts.raleway(
                    //             textStyle: const TextStyle(
                    //                 fontSize: 14, fontWeight: FontWeight.bold),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ],
                    // ),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
