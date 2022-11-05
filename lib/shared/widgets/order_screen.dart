import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(191, 122, 47, 1),
        // leading: FlutterLogo(),
        centerTitle: true,
        title: const Text('Edit Profile'),
      ),
      body: Center(
        child: Text("My orders"),
      ),
    );
  }
}
