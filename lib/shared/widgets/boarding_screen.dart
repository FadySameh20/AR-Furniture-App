import 'package:ar_furniture_app/shared/cache/sharedpreferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../constants/constants.dart';

class BoardingScreen extends StatefulWidget {

  @override
  State<BoardingScreen> createState() => _BoardingScreenState();
}

class _BoardingScreenState extends State<BoardingScreen> {
  final controller = PageController();
  int currentIndex=0;
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
              onPressed: () {
                goToWelcomeScreen();

              },
              child: const Text(
                "SKIP",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            )
          ],
        ),
        body: Column(
          children: [

            Expanded(flex:2,child: pages(context)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                 TextButton(onPressed:  currentIndex==0?null:(){
                    setState(() {
                      controller.previousPage(duration: const Duration(milliseconds: 500), curve: Curves.bounceInOut);

                    });

                  }, child: Text('Previous',
                style: TextStyle(
                fontSize: 16, color: currentIndex==0?Colors.grey:Colors.black),
            )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SmoothPageIndicator(
                      controller: controller,
                      count:  3,
                      axisDirection: Axis.horizontal,
                      effect: const JumpingDotEffect(
                        dotHeight: 16,
                        dotWidth: 16,
                        jumpScale: .7,
                        verticalOffset: 15,
                        activeDotColor: kAppBackgroundColor,
                      ),
                    ),
                  ),
                  TextButton(onPressed:(){
                    setState(() {
                      if(currentIndex==2){
                        goToWelcomeScreen();
                      }
                      else {
                        controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.bounceInOut);
                      }

                    });
                  }, child:const Text('Next',
                      style: TextStyle(
                          fontSize: 16, color: Colors.black)),

                  ),

                ],

              ),
            )
          ],
        ));
  }

  goToWelcomeScreen(){
    CacheHelper.setData(key: "hasPassedBoardingScreen", value: true);
    Navigator.pushReplacementNamed(context, "/");
  }

  Widget buildBoardingCard(context,img,color,title) {
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
                      color.withOpacity(0.2),
                      color.withOpacity(1.0)
                    ])),
              );
            }),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: LayoutBuilder(builder: (context, constraints) {
              return Container(
                height: constraints.maxHeight / 2.5,
                width: constraints.maxWidth / 1.2,
                // color: Colors.black,
                child: Image.asset(
                  img,
                  fit: BoxFit.contain,
                ),
              );
            }),
          ),
          Align(alignment: Alignment.bottomCenter,child: LayoutBuilder(
            builder: (context,constraints) {
              return Padding(
                padding:  EdgeInsets.only(bottom:constraints.maxHeight/3.2,left: 15,right: 15),
                child: Text(title,style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.bold,fontSize: 24),textAlign: TextAlign.center,
                // const TextStyle(fontWeight: FontWeight.bold,fontSize: 24),textAlign: TextAlign.center,),
                )
              );
            }
          )),
        ],
      ),
    );
  }

  Widget buildPageViewItem(context,img,color,title,){
    return Column(
      children: [

            Expanded(child: buildBoardingCard(context,img,color,title)),

      ],);
  }

  Widget pages(BuildContext context) {

    return PageView(
      controller: controller,
      onPageChanged: (page){
        setState((){currentIndex=page;});
      },
      children:  <Widget>[

        buildPageViewItem(context, "assets/Item_1.png", const Color(0xffd4a16a), "Explore world class top furniture as per your requirements and choice"),
        buildPageViewItem(context, "assets/Item_2.png", const Color(0xff795c3c), "Design your space with Augmented Reality by creating room"),
        buildPageViewItem(context, "assets/Item_3.png", const Color(0xff3c2e1e),  "View and experience furniture with the help of augmented reality"),
      ],
    );
  }
}
