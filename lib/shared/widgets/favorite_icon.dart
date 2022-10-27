import 'package:flutter/material.dart';

class FavoriteIcon extends StatefulWidget {

  IconData iconLogo;
  Color? iconColor;
  double? iconSize;

  FavoriteIcon({required this.iconLogo, this.iconColor, this.iconSize});

  @override
  State<FavoriteIcon> createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon> {
  @override
  Widget build(BuildContext context) {
    return Icon(
      widget.iconLogo,
      color: widget.iconColor,
      size: widget.iconSize,
    );
  }
}
