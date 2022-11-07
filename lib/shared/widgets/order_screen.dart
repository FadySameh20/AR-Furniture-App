import 'package:ar_furniture_app/cubits/home_cubit.dart';
import 'package:ar_furniture_app/models/furniture_model.dart';
import 'package:ar_furniture_app/shared/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        itemCount: BlocProvider.of<HomeCubit>(context).orders.length,
        itemBuilder: (BuildContext context, int index) {
          int quantity = 0;
          double totalPrice = 0;
          List<FurnitureModel> orderFurniture = [];
          BlocProvider.of<HomeCubit>(context)
              .orders[index]
              .order
              .forEach((key, shared) {
            // FirebaseFirestore.instance.collectionGroup("category")
            for (int i = 0;
                i < BlocProvider.of<HomeCubit>(context).categories.length;
                i++) {
              FurnitureModel furniture;
              int flag = 0;
              FirebaseFirestore.instance
                  .collection("category")
                  .doc(BlocProvider.of<HomeCubit>(context).categories[i].name)
                  .collection(
                      BlocProvider.of<HomeCubit>(context).categories[i].name)
                  .doc(key)
                  .get()
                  .then((value) {
                if (value.data() != null) {
                  for (int j = 0; j < shared.length; j++) {
                    furniture = FurnitureModel.fromJson(
                        value.data() as Map<String, dynamic>);
                    furniture.shared=[];
                    furniture.shared.add(shared[j]);

                    // print(furniture.shared.first.colorName);
                    // print(furniture.shared.length);

                    orderFurniture.add(furniture);
                    print("hahahah");
                    print(shared[i].quantityCart);
                    print(orderFurniture.last.name);
                    print(orderFurniture.last.shared.last.quantityCart);

                  }
                  flag = 1;
                }
              });
              if(flag==1){
                break;
              }
            }
            shared.forEach((element) {
              if (element.quantityCart != null) {
                quantity += int.parse(element.quantityCart);
                totalPrice += double.parse(element.quantityCart) *
                    double.parse(element.price);
              }
            });
          });
          print("Quantity");
          print(quantity);
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                margin: EdgeInsets.all(15),
                color: Colors.white,
                height: MediaQuery.of(context).size.height / 5,
                // child:Expanded(
                // flex: 3,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text(
                              "Order NO: ${BlocProvider.of<HomeCubit>(context).orders[index].orderId}",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Spacer(),
                          Text(
                            "${BlocProvider.of<HomeCubit>(context).orders[index].time.toDate().year.toString()}-${BlocProvider.of<HomeCubit>(context).orders[index].time.toDate().month.toString()}-${BlocProvider.of<HomeCubit>(context).orders[index].time.toDate().day.toString()}",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Quantity: ${quantity}",
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                          Spacer(),
                          Text(
                            "Total Amount: ${totalPrice}",
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        OutlinedButton(
                            style: ElevatedButton.styleFrom(
                                side: BorderSide(
                                    width: 2, color: kAppBackgroundColor),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            onPressed: () {
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(25.0),
                                        topRight: Radius.circular(25.0)),
                                  ),
                                  context: context,
                                  builder: (BuildContext context) {
                                    return OrderDetailsScreen(
                                        orderFurniture,
                                        BlocProvider.of<HomeCubit>(context)
                                            .orders[index]);
                                  });
                            },
                            child: Text("Details",
                                style: TextStyle(color: kAppBackgroundColor))),
                      ]),
                    ]),
              ),
            ),
          );
        },
      ),
    );
  }
}
