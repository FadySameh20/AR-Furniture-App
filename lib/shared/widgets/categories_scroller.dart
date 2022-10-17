import 'package:ar_furniture_app/cubits/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/constants.dart';

class CategoriesScroller extends StatelessWidget {
  // List<String> furniture = ["Chair", "Sofa", "Drawer"];
  // List<String> categoriesImages = [
  //   "assets/chair.png",
  //   "assets/seater-sofa.png",
  //   "assets/drawers.png"
  // ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15.0),
      height: MediaQuery.of(context).size.height > 700
          ? MediaQuery.of(context).size.height * 0.15
          : MediaQuery.of(context).size.height * 0.175,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: BlocProvider.of<HomeCubit>(context).categories.length,
          itemBuilder: (context, index) {
            return Padding(
              padding:
              const EdgeInsets.only(bottom: 15.0, left: 15, right: 15),
              child: Container(
                height: 30,
                width: 70,
                decoration: BoxDecoration(
                    color: index == 1
                        ? kAppBackgroundColor
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
                              child: Image.network(
                                BlocProvider.of<HomeCubit>(context).categories[index].image,
                                fit: BoxFit.fill,
                              ),
                            ),
                          )),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        BlocProvider.of<HomeCubit>(context).categories[index].name,
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
    );
  }
}
