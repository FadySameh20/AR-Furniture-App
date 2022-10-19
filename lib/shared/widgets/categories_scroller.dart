import 'package:ar_furniture_app/cubits/home_cubit.dart';
import 'package:ar_furniture_app/cubits/home_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/constants.dart';

class CategoriesScroller extends StatefulWidget {
  // List<String> furniture = ["Chair", "Sofa", "Drawer"];
  // List<String> categoriesImages = [
  //   "assets/chair.png",
  //   "assets/seater-sofa.png",
  //   "assets/drawers.png"
  // ];
  static String selectedCategoryName="";

  @override
  State<CategoriesScroller> createState() => _CategoriesScrollerState();
}

class _CategoriesScrollerState extends State<CategoriesScroller> {
  int selectedCategoryIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    CategoriesScroller.selectedCategoryName=BlocProvider.of<HomeCubit>(context).categories.first.name;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print("hahahaha");
    print(CategoriesScroller.selectedCategoryName);

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
              child: InkWell(
                onTap: () {
                  setState(() {
                    CategoriesScroller.selectedCategoryName=BlocProvider.of<HomeCubit>(context).categories[index].name;
                    selectedCategoryIndex = index;
                  });
                  // BlocProvider.of<HomeCubit>(context).furnitureList.clear();
                  if(!BlocProvider.of<HomeCubit>(context).returnedCategory.contains(BlocProvider.of<HomeCubit>(context).categories[index].name)) {
                    BlocProvider.of<HomeCubit>(context).getFurniture(
                        BlocProvider
                            .of<HomeCubit>(context)
                            .categories[index].name);
                  } else {
                    BlocProvider.of<HomeCubit>(context).emit(SuccessOffersState());
                  }
                  print("List");
                  // BlocProvider.of<HomeCubit>(context).emit(SuccessOffersState());
                  // BlocProvider.of<HomeCubit>(context).emit(SuccessOffersState());
                  print(BlocProvider.of<HomeCubit>(context).furnitureList);
                },
                child: Container(
                  height: 30,
                  width: 70,
                  decoration: BoxDecoration(
                      color: index == selectedCategoryIndex
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
                              index == selectedCategoryIndex ? Colors.white : Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
