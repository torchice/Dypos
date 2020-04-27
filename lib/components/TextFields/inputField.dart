import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final TextInputType textInputType;
  final Color textFieldColor, iconColor;
  final bool obscureText;
  final double bottomMargin;
  final double topMargin;
  final TextStyle textStyle, hintStyle;
  final validateFunction;
  final onSaved;
  final Key key;
  final controllerFunction;
  final bool validation;
  final String initialVal;
  final FocusNode focusNode;
  final bool enabled;
  //passing props in the Constructor.
  InputField(
      {this.key,
      this.hintText,
      this.obscureText,
      this.textInputType,
      this.textFieldColor,
      this.icon,
      this.iconColor,
      this.bottomMargin,
      this.textStyle,
      this.validateFunction,
      this.onSaved,
      this.hintStyle,
      this.controllerFunction,
      this.validation,
      this.initialVal,
      this.topMargin,
      this.focusNode,
      this.enabled
      });

  @override
  Widget build(BuildContext context) {
    return (new Container(
        margin: new EdgeInsets.only(
          bottom: bottomMargin,
         ),
        child: new DecoratedBox(
          decoration: new BoxDecoration(
              borderRadius: new BorderRadius.all(new Radius.circular(30.0)),
              color: textFieldColor),
          child: new TextFormField(
            style: textStyle,
            key: key,
            obscureText: obscureText,
            keyboardType: textInputType,
            validator: validateFunction,
            controller: controllerFunction,
            onSaved: onSaved,
            initialValue: initialVal,
            focusNode: focusNode,
            enabled: enabled,
            decoration: new InputDecoration(
              hintText: hintText,
              hintStyle: hintStyle,
              icon: new Icon(
                icon,
                color: iconColor,
              ),
            ),
          ),
        )));
  }
}
