import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/constants.dart';

class SplashWelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: Colors.transparent,
          // Status bar brightness (optional)
          statusBarIconBrightness: Brightness.light,
          // For Android (dark icons)
          statusBarBrightness: Brightness.dark, // For iOS (dark icons)
        ),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height / 1.4,
              child: Image.asset(
                "assets/welcome.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 20.0,
            left: MediaQuery.of(context).size.width/8.5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: kAppBackgroundColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.all(10),
                        minimumSize: Size(150, 50)),
                    child: Text(
                      "signup",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),

                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAppBackgroundColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.all(10),
                    minimumSize: Size(150, 50),
                  ),
                  child: Text(
                    "login",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
          ClipPath(
            clipper: WaveClip(),
            child: Container(
              height: MediaQuery.of(context).size.height / 2.1,
              width: double.infinity,
              // color: const Colors.blue,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  // 234,
                  Color.fromRGBO(248, 197, 142, 1.0),

                  Color.fromRGBO(239, 169, 93, 1.0),

                  kAppBackgroundColor,
                ]),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Hello.",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Welcome to our App!",
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),

                    // ElevatedButton(onPressed: (){},
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor:       Color.fromRGBO(191, 122, 47, 1),
                    //
                    //   ),
                    //   child: Text("signup",
                    //   style:TextStyle(fontSize: 18),
                    // ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.white,
      //   child: const Icon(
      //     Icons.navigate_next,
      //     color: Colors.black,
      //   ),
      //   onPressed: () {
      //
      //   },
      // ),
    );
  }
}

class WaveClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();
    final lowPoint = size.height - 20;
    final highPoint = size.height - 40;
    path.lineTo(0,
        size.height); //Make a line starting from top left of screen till down

    /// Adds a quadratic bezier segment that curves from the current
    /// point to the given point (x2,y2), using the control point
    /// (x1,y1).
    path.quadraticBezierTo(size.width / 4, highPoint, size.width / 2, lowPoint);
    path.quadraticBezierTo(
        3 / 4 * size.width, size.height, size.width, lowPoint);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
