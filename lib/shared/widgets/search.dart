import 'package:ar_furniture_app/shared/widgets/categories_scroller.dart';
import 'package:ar_furniture_app/shared/widgets/favorite_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/home_cubit.dart';
import '../../cubits/home_states.dart';
import '../../models/furniture_model.dart';
import '../../models/name_model.dart';
import '../constants/constants.dart';


class FurnitureSearch{
  final String name;

  const FurnitureSearch({
    required this.name,
  });
}
// List<FurnitureModel> filteredFurniture = [];

List<String> searchResult = [];

class Search extends StatefulWidget {
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  //const Search({Key? key}) : super(key: key);
  List<String> searchR = searchResult;
  bool viewSuggestions = false;
  List<FurnitureModel> filteredFurniture = [];



  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {

        },
        builder: (context, state) {
          // print("haaaa");
          // print(BlocProvider.of<HomeCubit>(context).furnitureList.length);
          // print("hola");
          // print(filteredFurniture[0].name);
          // print("plz");
          // print(BlocProvider.of<HomeCubit>(context).categories.length);
          filteredFurniture = BlocProvider.of<HomeCubit>(context).allFurnitureList.toList();
          print("sammm");
          print(filteredFurniture.length);
          for (var element in filteredFurniture) {
            searchResult.add(element.name);
          }

          return SingleChildScrollView(
              child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        cursorColor: kAppBackgroundColor,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(25.7),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(25.7),
                          ),
                          hintText: 'What are you looking for?',
                          prefixIcon: const Icon(
                            Icons.search,
                            color: kAppBackgroundColor,
                            size: 25,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 5.0, top: 5.0),
                        ),
                        onChanged: searchItem,
                      ),
                    ),
                  ),
                  Material(
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.filter_list,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                    borderRadius: BorderRadius.circular(10),
                    color: kAppBackgroundColor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
              if(viewSuggestions == true)
                Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / 5,
                  child: ListView.builder(
                    itemCount: searchR.length,
                    itemBuilder: (context, index) {
                      final fur = searchR[index];
                      return ListTile(
                        title: Text(fur,
                        ),
                        leading: FavoriteIcon(iconLogo: Icons.search),
                      );
                    },),
                ),
              if(viewSuggestions == false)
                Text(
                  "Categories",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              if(viewSuggestions == false)
                CategoriesScroller(),
              if(viewSuggestions == false)
                const Text(
                  "Recently Viewed",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              if(viewSuggestions == false)
                const SizedBox(
                  height: 10,
                ),
              if(viewSuggestions == false)
                Container(
                  height: MediaQuery.of(context).size.height > 350
                      ? MediaQuery.of(context).size.height * 0.45
                      : MediaQuery.of(context).size.height * 0.3,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 25.0),
                        child: Container(
                          padding: EdgeInsets.all(12.0),
                          width: MediaQuery.of(context).size.width > 200
                              ? MediaQuery.of(context).size.width * 0.45
                              : MediaQuery.of(context).size.width * 0.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  FavoriteIcon(iconLogo: Icons.favorite_border_rounded),
                                ],
                              ),
                              Container(
                                  height: MediaQuery.of(context).size.height/5,
                                  width: MediaQuery.of(context).size.width/3,
                                  child: Image.asset('assets/Item_1.png')
                              ),
                              Text(
                                "Havan Chair",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "EGP 5,000",
                                    style: TextStyle(
                                      color: kAppBackgroundColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Spacer(),
                                  Material(
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.add_shopping_cart,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    color: kAppBackgroundColor,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 25.0),
                        child: Container(
                          padding: EdgeInsets.all(12.0),
                          width: MediaQuery.of(context).size.width > 200
                              ? MediaQuery.of(context).size.width * 0.45
                              : MediaQuery.of(context).size.width * 0.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  FavoriteIcon(iconLogo: Icons.favorite_border_rounded),
                                ],
                              ),
                              Container(
                                  height: MediaQuery.of(context).size.height/5,
                                  width: MediaQuery.of(context).size.width/3,
                                  child: Image.asset('assets/Item_1.png')
                              ),
                              Text(
                                "Havan Chair",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "EGP 5,000",
                                    style: TextStyle(
                                      color: kAppBackgroundColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Spacer(),
                                  Material(
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.add_shopping_cart,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    color: kAppBackgroundColor,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 25.0),
                        child: Container(
                          padding: EdgeInsets.all(12.0),
                          width: MediaQuery.of(context).size.width > 200
                              ? MediaQuery.of(context).size.width * 0.45
                              : MediaQuery.of(context).size.width * 0.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  FavoriteIcon(iconLogo: Icons.favorite_border_rounded),
                                ],
                              ),
                              Container(
                                  height: MediaQuery.of(context).size.height/5,
                                  width: MediaQuery.of(context).size.width/3,
                                  child: Image.asset('assets/Item_1.png')
                              ),
                              Text(
                                "Havan Chair",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "EGP 5,000",
                                    style: TextStyle(
                                      color: kAppBackgroundColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Spacer(),
                                  Material(
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.add_shopping_cart,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    color: kAppBackgroundColor,
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
            ],
          ),
        );
          }
    );}
  void searchItem(String query){
    if (query == ''){
      setState(() => viewSuggestions = false);
    }else{
      setState(() => viewSuggestions = true);
      final suggestions = searchResult.where((fur) {
        final searchTitle = fur.toLowerCase();
        final input = query.toLowerCase();
        return searchTitle.contains(input);
      }).toList();
      setState(() => searchR = suggestions);
    }
  }
}
