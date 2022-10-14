import 'package:ar_furniture_app/shared/constants/constants.dart';
import 'package:flutter/material.dart';

class InputTextField extends StatefulWidget {
  TextEditingController textController;
  String hint;
  IconData prefixIconData;

  InputTextField(
      {required this.textController,
      required this.hint,
      required this.prefixIconData,
      });

  @override
  State<InputTextField> createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextField> {
  bool isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 13.0, bottom: 12.0, left: 8.0, right: 8.0),
      child: TextFormField(
        onChanged: (val) {
          setState(() {});
        },
        obscureText: widget.hint == "Password" || widget.hint == "Confirm Password" ? isPasswordHidden : false,
        controller: widget.textController,
        decoration: InputDecoration(
          prefixIcon: Icon(widget.prefixIconData, color: kAppBackgroundColor,),
          focusColor: kAppBackgroundColor,
          prefixIconColor: kAppBackgroundColor,
          suffixIcon: (widget.hint == "Password" || widget.hint == "Confirm Password") && widget.textController.text.length != 0
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isPasswordHidden = !isPasswordHidden;
                    });
                  },
                  icon: Icon(isPasswordHidden ? Icons.visibility_off : Icons.visibility, color: kAppBackgroundColor,))
              : null,
          label: Text(widget.hint),
          floatingLabelStyle: TextStyle(
            color: kAppBackgroundColor,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            borderSide: BorderSide(color: kAppBackgroundColor),
          ),
        ),
        validator: (String? value) {
          return (value!.isEmpty) ? 'Required field is required !' : null;
        },
      ),
    );
  }
}
