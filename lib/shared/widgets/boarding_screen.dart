import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../constants/constants.dart';

class BoardingScreen extends StatelessWidget {
  final controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            // Status bar color
            statusBarColor: Colors.transparent,
            // Status bar brightness (optional)
            statusBarIconBrightness: Brightness.dark,
            // For Android (dark icons)
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
          actions: [
            TextButton(
              onPressed: () {},
              child: Text(
                "SKIP",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(flex: 2, child: buildBoardingCard(context)),
            Expanded(flex: 3, child: Column(
              children: [
                Text("Welcome to our App",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Text("Appp gamedddd gdnn")
              ],
            )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  TextButton(onPressed:(){}, child:Text('Previous',
                style: TextStyle(
                fontSize: 16, color: Colors.black),
            )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SmoothPageIndicator(
                      controller: controller,
                      count:  3,
                      axisDirection: Axis.horizontal,
                      effect: JumpingDotEffect(
                        dotHeight: 16,
                        dotWidth: 16,
                        jumpScale: .7,
                        verticalOffset: 15,
                        activeDotColor: kAppBackgroundColor,
                      ),
                    ),
                  ),
                  TextButton(onPressed:(){}, child:Text('Next',
                      style: TextStyle(
                          fontSize: 16, color: Colors.black)),

                  ),

                ],

              ),
            )
          ],
        ));
  }

  Widget buildBoardingCard(context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: LayoutBuilder(builder: (context, constraints) {
              return Container(
                height: constraints.maxHeight - 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(colors: [
                      Colors.red.withOpacity(0.2),
                      Colors.red.withOpacity(1)
                    ])),
              );
            }),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: LayoutBuilder(builder: (context, constraints) {
              return Container(
                height: constraints.maxHeight / 1.2,
                width: constraints.maxWidth / 1.5,
                child: Image.asset(
                  "assets/Item_1.png",
                  fit: BoxFit.contain,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
