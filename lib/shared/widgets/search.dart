import 'package:ar_furniture_app/cubits/home_cubit.dart';
import 'package:ar_furniture_app/cubits/home_states.dart';
import 'package:ar_furniture_app/models/furniture_model.dart';
import 'package:ar_furniture_app/shared/widgets/categories_scroller.dart';
import 'package:ar_furniture_app/shared/widgets/favorite_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/shared_model.dart';
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
        // var temp= FirebaseFirestore.instance.collection("category").doc("beds").collection("furniture").doc();
        // print("hello");
        // print(temp.id);
        // temp.set(FurnitureModel(furnitureId: temp.id,category: "beds", name: "iraqian bed", model: "", shared: [SharedModel(color: "#FF0000", image: "https://firebasestorage.googleapis.com/v0/b/ar-furniture-7fb69.appspot.com/o/furniture%2FItem_1.png?alt=media&token=0bd24e89-91c4-4c7a-a8f1-65dde2dd7cbf", price: "200", quantity: "5")], ratings: []).toMap());
        filteredFurniture = BlocProvider.of<HomeCubit>(context).furnitureList.toList();
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
                      icon: Icon(Icons.filter_list, color: Colors.white, size: 25,),
                      onPressed: () {
                        Navigator.pushNamed(context, '/filter');
                      },
                    ),
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
                  child: searchR.isEmpty? const Center(
                    child: Text("No Items To Show"),
                  ):ListView.builder(
                    controller: _scrollController,
                    itemCount: searchR.length,
                    itemBuilder: (context, index) {
                      final fur = searchR[index];
                      return ListTile(
                        title: Text(fur.name),
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
