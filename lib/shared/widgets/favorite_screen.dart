import 'dart:convert';
import 'dart:ffi';

import 'package:ar_furniture_app/cubits/home_cubit.dart';
import 'package:ar_furniture_app/cubits/home_states.dart';
import 'package:ar_furniture_app/models/furniture_model.dart';
import 'package:ar_furniture_app/shared/constants/constants.dart';
import 'package:ar_furniture_app/shared/widgets/favorite_icon.dart';
import 'package:ar_furniture_app/shared/widgets/selected_furnitue_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    return BlocConsumer<HomeCubit,HomeState>(builder: (context,index){
      List<FurnitureModel> myFavorites=BlocProvider.of<HomeCubit>(context).furnitureList.where((element) => element.isFavorite==true).toList();
      print("Mylist:${myFavorites.length}");
      return myFavorites.isEmpty?Center(child: Text("No Favorites Yet",style: Theme.of(context).textTheme.bodyText1?.copyWith(
          color: BlocProvider.of<HomeCubit>(context).isDark?Colors.white:Colors.black,
          fontSize: 24
      ),),):Container(
        // height: MediaQuery.of(context).size.height * 0.6,
        // flex: 2,
        child: ListView.builder(
            itemCount: myFavorites.length,
            itemBuilder: (context, index) {
              List<Color> myColors=[];
              myFavorites[index].shared.forEach((element) {
                myColors.add(BlocProvider.of<HomeCubit>(context).getColorFromHex(element.color)!);
              });
              // BlocProvider.of<HomeCubit>(context).getColorFromHex()
              return FavoriteItemWidget(myFavorites[index],myColors);
            }),
      );
    }, listener:(context,state){});

  }
}

class FavoriteItemWidget extends StatefulWidget {
  FurnitureModel myFavorite;
  List<Color> myColor;
  FavoriteItemWidget(this.myFavorite, this.myColor);
  @override
  State<FavoriteItemWidget> createState() => _FavoriteItemWidgetState();
}

class _FavoriteItemWidgetState extends State<FavoriteItemWidget> {
  int currentColorIndex=0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap:(){
          List<Color?> availableColors = [];
          availableColors = BlocProvider.of<HomeCubit>(context).getAvailableColorsOfFurniture(widget.myFavorite);
          BlocProvider.of<HomeCubit>(context).getFurnitureRecommendation(widget.myFavorite, 0);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SelectedFurnitureScreen(selectedFurniture: widget.myFavorite, availableColors: availableColors)),
          );
        },
        child: Material(
          borderRadius: BorderRadius.circular(20),
          color: !BlocProvider.of<HomeCubit>(context).isDark?Colors.white:Color(0xff414147),
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
                        child: Container(
                          width: MediaQuery.of(context).size.width/3,
                          height: MediaQuery.of(context).size.height/10,
                          child: Image.network(
                            widget.myFavorite.shared[currentColorIndex].image,
                            fit: BoxFit.contain,
                          ),
                        ),
                      )),

                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          BlocProvider.of<HomeCubit>(context).capitalizeFirstLettersInView(widget.myFavorite.name),
                          style: TextStyle(fontSize: 15,color:BlocProvider.of<HomeCubit>(context).isDark?Colors.white:Colors.black),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Spacer(),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  (double.parse(widget.myFavorite.shared[currentColorIndex].price
                                  )).toStringAsFixed(2)+
                                      ' L.E',
                                  style: TextStyle(
                                    decoration: double.parse(widget.myFavorite.shared[currentColorIndex].discount).toInt()!=0?TextDecoration.lineThrough:null,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                    color: kAppBackgroundColor,
                                  ),
                                ),
                                SizedBox(width: 10,),
                                if(double.parse(widget.myFavorite.shared[currentColorIndex].discount).toInt()!=0)

                                  Text(

                                    '${(double.parse(widget.myFavorite.shared[currentColorIndex].price) -( (double.parse(widget.myFavorite.shared[currentColorIndex].discount)/100)*double.parse(widget.myFavorite.shared[currentColorIndex].price))).toStringAsFixed(2)} L.E',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600,
                                      color: kAppBackgroundColor,
                                    ),
                                  )
                              ],
                            ),
                          ],
                        ),
                        Container(
                          height: 30,
                          width: MediaQuery.of(context).size.width/3,
                          // color: Colors.black,
                          child:ListView.builder(scrollDirection: Axis.horizontal,itemCount: widget.myColor.length,itemBuilder: (context,index){
                            return Padding(

                              padding: const EdgeInsets.only(right:8.0),
                              child: InkWell(
                                onTap: (){
                                  setState(() {
                                    currentColorIndex=index;
                                  });
                                },
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: widget.myColor[index],
                                  child: index==currentColorIndex?Icon(Icons.check):null,
                                ),
                              ),
                            );
                          }),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  // borderRadius: BorderRadius.circular(20),
                  onTap: ()async{
                    setState(() {
                      BlocProvider.of<HomeCubit>(context).addOrRemoveFromFavorite(widget.myFavorite.furnitureId);
                      // BlocProvider.of<HomeCubit>(context).emit(CheckoutSuccessfully());
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
      ),
    );
  }
}

