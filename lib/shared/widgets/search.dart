import 'package:ar_furniture_app/cubits/home_cubit.dart';
import 'package:ar_furniture_app/cubits/home_states.dart';
import 'package:ar_furniture_app/models/furniture_model.dart';
import 'package:ar_furniture_app/shared/widgets/SearchFilterScreen.dart';
import 'package:ar_furniture_app/shared/widgets/categories_scroller.dart';
import 'package:ar_furniture_app/shared/widgets/favorite_icon.dart';
import 'package:ar_furniture_app/shared/widgets/selected_furnitue_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants/constants.dart';
import 'circle_avatar.dart';


List<FurnitureModel> filteredFurniture = [];
class Search extends StatefulWidget {
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  //const Search({Key? key}) : super(key: key);
  List<FurnitureModel> searchR = filteredFurniture;
  List<FurnitureModel> tempSearchR = filteredFurniture;
  bool viewSuggestions = false;
  int flag = 0;
  ScrollController _scrollController = ScrollController();
  TextEditingController _searchController = TextEditingController();

  // filter
  RangeValues currentRangeValues = const RangeValues(0, 500);
  Map<Color,bool> colors = {};
  var arguments;
  bool requestPriceFilter = false;
  bool requestColorFilter = false;
  int colorFlag = 0;

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
              searchR = [...addSearchData];
              tempSearchR = [...addSearchData];
            });
            if(checkFilter()) {
              setState(() {
                searchR = applyFilter();
              });
            }
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
                        arguments = await Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchFilterScreen(currentRangeValues, colors)));
                        setState(() {
                          currentRangeValues = arguments["priceFilterRange"];
                          colors = arguments["colors"];
                          checkFilter();
                          if(checkFilter()) {
                            searchR = applyFilter();
                          }else {
                            searchR = [...tempSearchR];
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
              if(viewSuggestions == true &&(requestColorFilter == true || requestPriceFilter == true))
                Container(
                  height: MediaQuery.of(context).size.height > 350
                      ? MediaQuery.of(context).size.height * 0.1
                      : MediaQuery.of(context).size.height * 0.05,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      if(requestColorFilter == true)
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: ClipOval(
                          child: Container(
                            color: Colors.grey.shade400,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                child: Row(
                                  children: [
                                    Text("Color: "),
                                    ...colors.entries.where((element) => element.value == true).map((e) => CustomCircleAvatar(radius: MediaQuery.of(context).size.height > 350 ? 10.0 : 5.0, CavatarColor: e.key))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if(requestPriceFilter == true)
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: ClipOval(
                          child: Container(
                            color: Colors.grey.shade400,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text("Price: ${currentRangeValues.start.round()} - ${currentRangeValues.end.round()}"),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if(viewSuggestions == true)
              searchR.isEmpty? const Center(
                child: Text("No Items To Show"),
              ):LayoutBuilder(
                builder: (context,constraints) {
                  return Container(
                    height: MediaQuery.of(context).size.height-(160+ MediaQuery.of(context).padding.top+AppBar(
                        backgroundColor: const Color.fromRGBO(191, 122, 47, 1),
                        leading: const FlutterLogo(),
                        actions: [
                          IconButton(onPressed: () {context.read<HomeCubit>().logout(context);}, icon: Icon(Icons.shopping_cart))
                        ],
                        centerTitle: true,
                        title: const Text(
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
                              padding: const EdgeInsets.all(12.0),
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
                                          BlocProvider.of<HomeCubit>(context).addOrRemoveFromFavorite(fur.furnitureId);
                                          BlocProvider.of<HomeCubit>(context).emit(AddOrRemoveFavoriteState());
                                        },
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                          minimumSize: const Size(0, 0),
                                        ),
                                        child: fur.isFavorite ? FavoriteIcon(iconLogo: Icons.favorite, iconColor: kAppBackgroundColor,) : FavoriteIcon(iconLogo: Icons.favorite_border_rounded, iconColor: kAppBackgroundColor,),
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
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${fur.shared[0].price}  EGP",
                                        style: const TextStyle(
                                          color: kAppBackgroundColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const Spacer(),
                                      TextButton(
                                        onPressed: () {
                                          BlocProvider.of<HomeCubit>(context).addToCart(fur.furnitureId, fur.shared[0].color, 1);
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                            content: Text('Added to cart successfully !'),
                                          ));
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: kAppBackgroundColor,
                                          padding: EdgeInsets.zero,
                                          tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                          minimumSize: Size(0, 0),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.add_shopping_cart,
                                            color: Colors.white,
                                          ),
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
                const Text(
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
                      ? MediaQuery.of(context).size.height * 0.1
                      : MediaQuery.of(context).size.height * 0.05,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: recentlyViewed.length,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: ClipOval(
                          child: Container(
                            color: Colors.grey.shade400,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(recentlyViewed[index]),
                              ),
                            ),
                          ),
                        ),
                      );
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
      if(colorFlag == 0) {
        getAvailableColors(0);
        colorFlag = 1;
      }
      setState(() => viewSuggestions = true);
      final input = query.toLowerCase();
      List<FurnitureModel> suggestions = filteredFurniture.where((fur) {
        final searchTitle = fur.name.toLowerCase();
        return searchTitle.contains(input);
      }).toList();
      if (suggestions.length < 4){
        suggestions = await addMoreData(suggestions,input);
      }
      setState(() {
        searchR = [...suggestions];
        tempSearchR = [...suggestions];
      });
      if(requestColorFilter == true || requestPriceFilter == true) {
        setState(() {
          searchR = applyFilter();
        });
      }
    }
  }

  Future<List<FurnitureModel>> addMoreData(List<FurnitureModel> suggestions1, String input) async {
    int moreFurnitureCount = filteredFurniture.length;
    if(BlocProvider.of<HomeCubit>(context).lastSearchbarName == input) {
      await BlocProvider.of<HomeCubit>(context).getMoreSearchData(input);
    } else {
      await BlocProvider.of<HomeCubit>(context).getSearchData(input);
    }
    filteredFurniture = BlocProvider.of<HomeCubit>(context).furnitureList.toList();
    if (moreFurnitureCount != filteredFurniture.length){
      getAvailableColors(moreFurnitureCount);
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

  void getAvailableColors(int start) {
    int i;
    FurnitureModel element;
    for (i=start; i<filteredFurniture.length; i++) {
      element = filteredFurniture[i];
      List<Color?> availableColors = BlocProvider.of<HomeCubit>(context).getAvailableColorsOfFurniture(element);
      for (var valColor in availableColors) {
        if(!colors.containsKey(valColor)) {
          setState(() {
            colors[valColor!] = false;
          });
        }
      }
    }
  }

  bool checkFilter() {
    print("gowaaaa filter");
    if(colors.containsValue(true)){
      setState(() {
        requestColorFilter = true;
      });
    }else {
      setState(() {
        requestColorFilter = false;
      });
    }
    print("check filter price");
    print(currentRangeValues.start.round());
    print(currentRangeValues.end.round());
    if(currentRangeValues.start.round() != 0 || currentRangeValues.end.round() != 500) {
      setState(() {
        requestPriceFilter = true;
      });
    }
    else {
      setState(() {
        requestPriceFilter = false;
      });
    }
    if(requestPriceFilter == true || requestColorFilter == true) {
      return true;
    }
    return false;
  }

  List<FurnitureModel> applyFilter() {
    print("ANA APPLY FILTER");
    searchR = [...tempSearchR];
    if(requestPriceFilter == true) {
      searchR = searchR.where((element) => int.parse(element.shared[0].price) >= currentRangeValues.start && int.parse(element.shared[0].price) <= currentRangeValues.end).toList();
    }
    if(requestColorFilter == true) {
      List<Color> tempColors=[];
      colors.forEach((key, value) {
        if(value==true){
          tempColors.add(key);
        }
      });
      print("TEST print");
      print(tempColors);
      searchR=searchR.where((element) {
        List<Color?> availableColorsFilter =BlocProvider.of<HomeCubit>(context).getAvailableColorsOfFurniture(element);
        bool isFound=availableColorsFilter.where((element) => tempColors.contains(element)).isNotEmpty;
        print(isFound);
        print("ya rb");
        if(isFound){
            return true;
          }
       return false;
      }).toList();
    }
    return searchR;
  }
}
