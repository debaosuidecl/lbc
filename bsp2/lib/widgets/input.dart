import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Input extends StatelessWidget {
  TextEditingController controller;
  String title;
  Widget prefixIcon;
  FocusNode focus;
  TextInputType type;
  bool obscureText = false;
  Input(
      {@required required this.title,
      @required required this.controller,
      @required required this.type,
      @required required this.obscureText,
      @required required this.focus,
      @required required this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 19),
      child: Material(
        elevation: 4,
        shadowColor: const Color(0xffeeeeee),
        child: TextField(
          focusNode: focus,
          keyboardAppearance: Brightness.dark,
          controller: controller,
          // keyboardType: TextInputType.phone,
          obscureText: obscureText,
          // inputFormatters: <TextInputFormatter>[
          //   FilteringTextInputFormatter.digitsOnly
          // ],
          decoration: InputDecoration(
            prefixIcon: prefixIcon,
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2.0),
              // borderRadius: BorderRadius.circular(25.0),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2),
            ),
            fillColor: Colors.white,
            filled: true,
            labelText: title,
            labelStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: focus.hasFocus ? Colors.black : Colors.black,
            ),
            hintStyle: const TextStyle(
                color: Colors.white, fontSize: 10, fontWeight: FontWeight.w100),
          ),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
        ),
      ),
    );
  }
}
