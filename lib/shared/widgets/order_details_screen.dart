import 'package:ar_furniture_app/shared/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 100,
      child: Column(
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: kAppBackgroundColor,
              borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft:Radius.circular(20) ),
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
                          "Order id: ",
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
                      height: 2*MediaQuery.of(context).size.height / 5.5,
                      width: MediaQuery.of(context).size.width-10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[300]),
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 2,
                          itemBuilder: (context, index) {
                            return Row(
                              // mainAxisAlignment: MainAxisAlignment.,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width / 4,
                                  height: MediaQuery.of(context).size.height / 5.5,
                                  child: Image.asset("assets/chair.png"),
                                  // color: Colors.purple,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width:MediaQuery.of(context).size.width/2.3,
                                      // color:Colors.red,
                                      child: Text(
                                        "${index}Porche sports foots",
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
                                      "\$85",
                                      style: GoogleFonts.raleway(
                                        textStyle: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
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
