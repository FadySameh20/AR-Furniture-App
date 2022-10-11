import 'package:flutter/material.dart';

class FavoriteIcon extends StatelessWidget {

  IconData iconLogo;
  Color? iconColor;
  double? iconSize;

  FavoriteIcon({required this.iconLogo, this.iconColor, this.iconSize});

  @override
  Widget build(BuildContext context) {
    return Icon(
      iconLogo,
      color: iconColor,
      size: iconSize,
    );
  }
}
