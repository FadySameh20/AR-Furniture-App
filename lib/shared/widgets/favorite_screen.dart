import 'dart:ffi';

import 'package:ar_furniture_app/cubits/home_cubit.dart';
import 'package:ar_furniture_app/models/furniture_model.dart';
import 'package:ar_furniture_app/shared/constants/constants.dart';
import 'package:ar_furniture_app/shared/widgets/favorite_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cache/sharedpreferences.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    List<FurnitureModel> myFavorites=BlocProvider.of<HomeCubit>(context).furnitureList.where((element) => element.isFavorite==true).toList();
    return Container(
      // height: MediaQuery.of(context).size.height * 0.6,
      // flex: 2,
      child: ListView.builder(
          itemCount: myFavorites.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Material(
                borderRadius: BorderRadius.circular(20),
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(20)

                // ),
                child: Stack(
                  children: [
                    Row(
                      // mainAxisSize: MainAxisSize.max,
                      children: [
                        // Column(),
                        Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Image.asset(
                                "assets/Item_1.png",
                                fit: BoxFit.contain,
                              ),
                            )),

                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                myFavorites[index].name,
                                style: TextStyle(fontSize: 15),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Text(
                                      myFavorites[index].shared.first.price,
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
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: ()async{

                            // BlocProvider.of<HomeCubit>(context).furnitureList;
                            // context.read<>;
                            // BlocProvider.of<HomeCubit>(context).furnitureList.where((element) => element.furnitureId==myFavorites[index].furnitureId).first.isFavorite=false;
                            myFavorites[index].isFavorite=false;
                            List<String> favorites=await CacheHelper.getData("favorites")??[];
                            favorites.remove(myFavorites[index].furnitureId);
                            setState(() {
                              CacheHelper.setList(key: "favorites", value: favorites);
                            });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top:15.0,right:15.0),
                          child: FavoriteIcon(iconLogo:Icons.favorite,iconColor: kAppBackgroundColor,),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
