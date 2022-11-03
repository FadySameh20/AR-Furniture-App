import 'package:ar_furniture_app/shared/constants/constants.dart';
import 'package:ar_furniture_app/shared/widgets/categories_scroller.dart';
import 'package:ar_furniture_app/shared/widgets/circle_avatar.dart';
import 'package:flutter/material.dart';


class SearchFilterScreen extends StatefulWidget {
  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  //const SearchFilterScreen({Key? key}) : super(key: key);
  List<String> priceFilter = ['EGP 0 - 4,999', 'EGP 5,000 - 9,999', 'EGP 10,000 - 14,999', 'EGP 15,000 - 19,999', 'EGP 20,000+'];

  List<Color> colors = [
    Colors.teal,
    Colors.red,
    Colors.yellow,
    Colors.blue,
  ];

  List<bool> isCheck = [false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filter"),
        centerTitle: true,
        backgroundColor: kAppBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Price',
                style: TextStyle(
                  color: kAppBackgroundColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: priceFilter.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(priceFilter[index], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),),
                          SizedBox(
                            height: 25,
                            child: Checkbox(value: false,
                                onChanged: (bool? newValue){

                                }
                            ),
                          ),
                        ],
                      ),
                    );
                  },
              ),
              const Text(
                'Category',
                style: TextStyle(
                  color: kAppBackgroundColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              CategoriesScroller(),
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
                children: List.generate(colors.length, (index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [InkWell(
                        onTap: (){
                          setState(() {
                            isCheck[index] = !isCheck[index];
                          });
                        },
                        child: CustomCircleAvatar(radius: MediaQuery.of(context).size.height > 350 ? 25.0 : 20.0, CavatarColor: colors[index], icon: isCheck[index] == true? const Icon(Icons.check, size: 30, color: Colors.white,):null),
                    ),
                  ]);
                }),
              ),
              ElevatedButton(
                child: Text("Apply"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAppBackgroundColor,
                ),
                onPressed: (){},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
