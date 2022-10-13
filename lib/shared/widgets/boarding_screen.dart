import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BoardingScreen extends StatelessWidget {
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
            statusBarBrightness: Brightness.dark, // For iOS (dark icons)
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
            Expanded(flex: 3, child: Container())
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
