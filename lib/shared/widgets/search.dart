import 'package:ar_furniture_app/cubits/home_cubit.dart';
import 'package:ar_furniture_app/cubits/home_states.dart';
import 'package:ar_furniture_app/models/furniture_model.dart';
import 'package:ar_furniture_app/shared/widgets/categories_scroller.dart';
import 'package:ar_furniture_app/shared/widgets/favorite_icon.dart';
import 'package:ar_furniture_app/shared/widgets/selected_furnitue_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants/constants.dart';


List<FurnitureModel> filteredFurniture = [];
class Search extends StatefulWidget {
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  //const Search({Key? key}) : super(key: key);
  List<FurnitureModel> searchR = filteredFurniture;
  bool viewSuggestions = false;
  int flag = 0;
  ScrollController _scrollController = ScrollController();
  TextEditingController _searchController = TextEditingController();

  // filter
  //Map<String, bool> priceFilter = {'EGP 0 - 4999': false, 'EGP 5000 - 9999': false, 'EGP 10000 - 14999': false, 'EGP 15000 - 19999': false, 'EGP 20000 +': false};
  Map<String, bool> priceFilter = {'EGP 0 - 50': false, 'EGP 200 - 299': false, 'EGP 300 - 399': false, 'EGP 400 - 499': false, 'EGP 500 +': false};
  var arguments;

  // recently viewed
  List<String> recentlyViewed = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(() async {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0) {
          int lengthSearchR = searchR.length;
          List<FurnitureModel> addSearchData = await addMoreData(searchR, _searchController.text.toLowerCase());
          if (addSearchData.length > lengthSearchR){
            setState(() {
              searchR = addSearchData;
            });
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state){

      },
      builder: (context, state)  {
        filteredFurniture = BlocProvider.of<HomeCubit>(context).furnitureList.toList();
        recentlyViewed = BlocProvider.of<HomeCubit>(context).cache.cacheRecentlySearchedNames;
        return SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        controller: _searchController,
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
                        onChanged: (value) async {
                          await searchItem(value);
                        },
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: kAppBackgroundColor,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.filter_list, color: Colors.white, size: 25,),
                      onPressed: () async{
                        print(priceFilter);
                        arguments = await Navigator.pushNamed(context, '/filter', arguments: {'priceFilter': priceFilter});
                        print("====================================");
                        // print(priceFilter.keys.elementAt(0).split(' '));
                        // print(priceFilter.keys.elementAt(0).split(' ')[3]);
                        // print(int.tryParse(priceFilter.keys.elementAt(0).split(' ')[3]));
                        // print(priceFilter.keys.elementAt(priceFilter.length-1).split(' '));

                        // List<FurnitureModel> applyFilters = [];
                        priceFilter.forEach((key, value) {
                          if(value == true){
                            print(key +  "   " + value.toString());
                            if(key.split(' ').length == 4){
                              print("yessssss");
                              print(searchR.length);
                              searchR.forEach((element) {
                                print(element.name);
                              });
                              print("after filter");
                              setState(() {
                              searchR = searchR.where((element) => int.parse(element.shared[0].price) >= int.parse(key.split(' ')[1]) && int.parse(element.shared[0].price) <= int.parse(key.split(' ')[3])).toList();
                              });
                              searchR.forEach((element) {
                                print(element.name);
                              });
                              // searchR.forEach((element) {
                              //   if (!applyFilters.contains(element)) {
                              //     for (var element1 in element.shared) {
                              //       if (int.parse(element1.price) >= int.parse(key.split(' ')[1]) && int.parse(element1.price) <= int.parse(key.split(' ')[3])) {
                              //         applyFilters.add(element);
                              //         print(element.name);
                              //         break;
                              //       }
                              //     }
                              //   }
                              // });
                            }
                            //print("apply filter length");
                            //print(applyFilters.length);
                            // else if (key.split(' ').length == 3) {
                            //   print(key.split(' ')[1]);
                            //   searchR.forEach((element) {
                            //     if (!applyFilters.contains(element)) {
                            //       for (var element1 in element.shared) {
                            //         if (int.parse(element1.price) >= int.parse(key.split(' ')[1])) {
                            //           applyFilters.add(element);
                            //           break;
                            //         }
                            //       }
                            //     }
                            //   });
                            // }
                          }
                        });
                        print("====================================");
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
              if(viewSuggestions == true)
              searchR.isEmpty? const Center(
                child: Text("No Items To Show"),
              ):LayoutBuilder(
                builder: (context,constraints) {
                  return Container(
                    height: MediaQuery.of(context).size.height-(160+ MediaQuery.of(context).padding.top+AppBar(
                        backgroundColor: Color.fromRGBO(191, 122, 47, 1),
                        leading: FlutterLogo(),
                        actions: [
                          IconButton(onPressed: () {context.read<HomeCubit>().logout(context);}, icon: Icon(Icons.shopping_cart))
                        ],
                        centerTitle: true,
                        title: Text(
                          "Home",
                          style: TextStyle(),
                        )).preferredSize.height),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 0.6,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10),
                      controller: _scrollController,
                      itemCount: searchR.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        final fur = searchR[index];
                        return Padding(
                          padding:
                          const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 25.0),
                          child: InkWell(
                            onTap: (){
                              BlocProvider.of<HomeCubit>(context).addToRecentlySearchedName(fur.name);
                              List<Color?> availableColors = [];
                              availableColors = BlocProvider.of<HomeCubit>(context).getAvailableColorsOfFurniture(searchR[index]);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SelectedFurnitureScreen(selectedFurniture: searchR[index], availableColors: availableColors)),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(12.0),
                              width: MediaQuery.of(context).size.width > 200
                                  ? MediaQuery.of(context).size.width * 0.45
                                  : MediaQuery.of(context).size.width * 0.3,
                              height: 300,
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
                                      TextButton(
                                        onPressed: () {
                                          int tempIndex = BlocProvider.of<HomeCubit>(context).furnitureList.indexWhere((element) => element.furnitureId == fur.furnitureId);
                                          BlocProvider.of<HomeCubit>(context).addOrRemoveFromFavorite(tempIndex);
                                          BlocProvider.of<HomeCubit>(context).emit(AddOrRemoveFavoriteState());
                                        },
                                        child: fur.isFavorite ? FavoriteIcon(iconLogo: Icons.favorite, iconColor: kAppBackgroundColor,) : FavoriteIcon(iconLogo: Icons.favorite_border_rounded, iconColor: kAppBackgroundColor,),
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                          minimumSize: Size(0, 0),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                      height: MediaQuery.of(context).size.height/5,
                                      width: MediaQuery.of(context).size.width/3,
                                      child: Image.network(fur.shared[0].image)
                                  ),
                                  Text(
                                    fur.name,
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
                                        fur.shared[0].price + "  EGP",
                                        style: TextStyle(
                                          color: kAppBackgroundColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Spacer(),
                                      TextButton(
                                        onPressed: () {
                                          BlocProvider.of<HomeCubit>(context).addToCart(fur.furnitureId, fur.shared[0].color, 1);
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            content: Text('Added to cart successfully !'),
                                          ));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.add_shopping_cart,
                                            color: Colors.white,
                                          ),
                                        ),
                                        style: TextButton.styleFrom(
                                          backgroundColor: kAppBackgroundColor,
                                          padding: EdgeInsets.zero,
                                          tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                          minimumSize: Size(0, 0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },),
                  );
                }
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
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: recentlyViewed.length,
                    itemBuilder: (context, index){
                      return Text(recentlyViewed[index]);
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }


  Future<void> searchItem (String query) async {
    if (query == ''){
      setState(() => viewSuggestions = false);
    }else{
      setState(() => viewSuggestions = true);
      final input = query.toLowerCase();
      List<FurnitureModel> suggestions = filteredFurniture.where((fur) {
        final searchTitle = fur.name.toLowerCase();
        return searchTitle.contains(input);
      }).toList();
      if (suggestions.length < 4){
        suggestions = await addMoreData(suggestions,input);
      }
      setState(() => searchR = suggestions);
    }
  }
  Future<List<FurnitureModel>> addMoreData(List<FurnitureModel> suggestions1, String input) async {
    int moreFurnitureCount = filteredFurniture.length;

    print("FURNITURE LIST:");
    await BlocProvider.of<HomeCubit>(context).getSearchData(input);
    filteredFurniture = BlocProvider.of<HomeCubit>(context).furnitureList.toList();
    print("hi");
    filteredFurniture.forEach((element) {
      print(element.name);
    });
    print("end");
    print("FURNITURE LIST ENDEDDDD");
    if (moreFurnitureCount != filteredFurniture.length){
      int j;
      for(j=moreFurnitureCount; j<filteredFurniture.length; j++){
        final searchTitle = filteredFurniture[j].name.toLowerCase();
        if(searchTitle.contains(input)){
          suggestions1.add(filteredFurniture[j]);
        }
      }
    }
    return suggestions1;
  }
}
