import 'package:ar_furniture_app/shared/constants/constants.dart';
import 'package:ar_furniture_app/shared/widgets/categories_scroller.dart';
import 'package:ar_furniture_app/shared/widgets/circle_avatar.dart';
import 'package:flutter/material.dart';


class SearchFilterScreen extends StatefulWidget {
  RangeValues rangeValues;
  Map<Color,bool> availableColors;
  SearchFilterScreen(this.rangeValues, this.availableColors,{super.key});
  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  //const SearchFilterScreen({Key? key}) : super(key: key);
  List<Color> selectedColors = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filter"),
        centerTitle: true,
        backgroundColor: kAppBackgroundColor,
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
                  max: 500,
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
                  Navigator.pop(context, {'priceFilterRange':widget.rangeValues, 'categoryName':CategoriesScroller.selectedCategoryName, 'colors':widget.availableColors});
                },
                child: const Text("Apply"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
