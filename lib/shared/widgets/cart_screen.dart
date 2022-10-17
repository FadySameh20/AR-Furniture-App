import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class CartScreen extends StatelessWidget {


  List<String> names = <String>['chair1', 'chair2', 'chair3', 'chair4'];
  List<String> images = <String>[
    'assets/Item_1.png',
    'assets/Item_1.png',
    'assets/Item_1.png',
    'assets/Item_1.png'
  ];
  List<int> prices = <int>[100, 200, 300, 400];
  @override
  Widget build(BuildContext context)  {
  //  FirebaseFirestore.instance.collection('names').get().then((value) {
    //  for(var document in value.docs){
    //    document.data();
   //   }
   // });
    return Stack(
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
                                          '1',
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
    );
  }
}
