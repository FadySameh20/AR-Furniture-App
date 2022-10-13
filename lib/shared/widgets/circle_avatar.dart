import 'package:flutter/material.dart';

class CustomCircleAvatar extends StatelessWidget {
  double? radius;
  Color? CavatarColor;
  Icon? icon;

  CustomCircleAvatar({required this.radius, required this.CavatarColor, this.icon});
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: radius,
        backgroundColor: CavatarColor,
        child: icon,
    );

  }
}