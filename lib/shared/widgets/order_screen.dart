import 'package:ar_furniture_app/shared/widgets/order_details_screen.dart';
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
        title: const Text('My Orders'),
      ),
      body: Center(
        child: TextButton(onPressed: () { showModalBottomSheet(isScrollControlled: true,shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
        ),context: context, builder: (BuildContext context) { return OrderDetailsScreen(); }); },
        child:Text("Order")),
      ),
    );
  }
}
