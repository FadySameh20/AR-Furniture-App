import 'package:flutter/material.dart';

import 'order_details_screen.dart';

class OrderScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(191, 122, 47, 1),
        // leading: FlutterLogo(),
        centerTitle: true,
        title: Text(
          "My Orders",
          style: TextStyle(),
        ),
      ),

      body: ListView.builder(
              itemCount: 6,
               itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(20),

                  child: Container(
                    margin:EdgeInsets.all(15),
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height/5,
                    // child:Expanded(
                    // flex: 3,
                    child:Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children:[
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                      Text("Order NO:",

                  style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                 ),
                        Spacer(),
                        Text("date",

                          style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                        ),
                      ],
                      ),
                        SizedBox(
                          height: 32,
                        ),
                        Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text("Quatlity:",

                              style: TextStyle(fontSize: 15,color: Colors.grey),
                            ),
                            Spacer(),
                            Text("Total Amount:",

                              style: TextStyle(fontSize: 15,color: Colors.grey),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                    OutlinedButton(
                      style: ElevatedButton.styleFrom(side:BorderSide(width:2,color: Colors.black),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                        onPressed: ()
                    { showModalBottomSheet(isScrollControlled: true,shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),

                    ),context: context, builder: (BuildContext context) { return OrderDetailsScreen(); }); },
                        child:Text("Details", style:TextStyle(color:Colors.black))),

                      ]
                  ),
                 ),
                ),

                );

               },



      ),
      );
  }
}
