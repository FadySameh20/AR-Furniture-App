import 'package:ar_furniture_app/cubits/home_states.dart';
import 'package:ar_furniture_app/shared/cache/sharedpreferences.dart';
import 'package:ar_furniture_app/shared/constants/constants.dart';
import 'package:ar_furniture_app/shared/widgets/circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:ar_furniture_app/models/name_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/home_cubit.dart';


class SearchFilterScreen extends StatefulWidget {
  RangeValues rangeValues;
  Map<Color,bool> availableColors;
  Map<CategoryItem,bool> categories;
  SearchFilterScreen(this.rangeValues, this.availableColors, this.categories,{super.key});
  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  //const SearchFilterScreen({Key? key}) : super(key: key);
  List<Color> selectedColors = [];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit,HomeState>(
      listener: (context,state){},
      builder:(context,state){return Scaffold(
        appBar: AppBar(
          title:  Text("Filter",style: TextStyle(color: !BlocProvider.of<HomeCubit>(context).isDark?Colors.white:Colors.black),),
          centerTitle: true,
          backgroundColor: kAppBackgroundColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,color: CacheHelper.getData("darkMode")==false||CacheHelper.getData("darkMode")==null?Colors.white:Colors.black,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Text(
                  'Price',
                  style: TextStyle(
                    color: kAppBackgroundColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                RangeSlider(
                    values: widget.rangeValues,
                    min: 0,
                    max: 10000,
                    divisions: 10,
                    labels: RangeLabels(
                        widget.rangeValues.start.round().toString(),
                        widget.rangeValues.end.round().toString()
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        widget.rangeValues = values;
                      });
                    }),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    'Category',
                    style: TextStyle(
                      color: kAppBackgroundColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15.0),
                  height: MediaQuery.of(context).size.height > 700
                      ? MediaQuery.of(context).size.height * 0.15
                      : MediaQuery.of(context).size.height * 0.175,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.categories.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding:
                          const EdgeInsets.only(bottom: 15.0, left: 15, right: 15),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                widget.categories.update(widget.categories.keys.elementAt(index), (value) => !widget.categories.values.elementAt(index));
                              });
                            },
                            child: Container(
                              height: 30,
                              width: 70,
                              decoration: BoxDecoration(
                                  color: widget.categories.values.elementAt(index)? kAppBackgroundColor
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
                                              widget.categories.keys.elementAt(index).image,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        )),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      widget.categories.keys.elementAt(index).name,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color:
                                          widget.categories.values.elementAt(index) ? Colors.white : Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                const Text(
                  'Color',
                  style: TextStyle(
                    color: kAppBackgroundColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 4,
                  scrollDirection: Axis.vertical,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 5.0,
                  reverse: false,
                  children: List.generate(widget.availableColors.length, (index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [InkWell(
                          onTap: (){
                            setState(() {
                              widget.availableColors.update(widget.availableColors.keys.elementAt(index), (value) => !widget.availableColors.values.elementAt(index));
                            });
                          },
                          child: CustomCircleAvatar(radius: MediaQuery.of(context).size.height > 350 ? 25.0 : 20.0, CavatarColor: widget.availableColors.keys.elementAt(index), icon: widget.availableColors.values.elementAt(index) == true? const Icon(Icons.check, size: 30, color: Colors.white,):null),
                      ),
                    ]);
                  }),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAppBackgroundColor,
                  ),
                  onPressed: (){
                    Navigator.pop(context, {'priceFilterRange':widget.rangeValues, 'categories':widget.categories, 'colors':widget.availableColors});
                  },
                  child: const Text("Apply"),
                ),
              ],
            ),
          ),
        ),
      );}
    );
  }
}
