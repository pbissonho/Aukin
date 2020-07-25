import 'package:flutter/material.dart';
import 'package:authentication/shared/hello_page.dart';
import 'package:google_fonts/google_fonts.dart';

var color = Color(0xff5d6abe);

class ArroBack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var paddingTop = MediaQuery.of(context).padding.top;
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.only(top: paddingTop + 35),
        child: IconButton(
          icon: Icon(Icons.arrow_back, color: color, size: 32),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) {
                return HelloPage();
              }),
              (_) => false,
            );
          },
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {Key key,
      this.labelTest,
      this.textInputType,
      this.obscureText = false,
      this.controller})
      : super(key: key);

  final String labelTest;
  final TextInputType textInputType;
  final bool obscureText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom:
              BorderSide(color: color, width: 0.7, style: BorderStyle.solid),
        ),
      ),
      child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: textInputType,
          decoration: InputDecoration(
              border: InputBorder.none,
              labelText: labelTest,
              labelStyle: GoogleFonts.quicksand(
                  color: color, fontWeight: FontWeight.w500))),
    );
  }
}

class LogInButton extends StatelessWidget {
  const LogInButton({Key key, this.buttonText, this.onPressed})
      : super(key: key);
  final String buttonText;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: color,
            offset: Offset(0, 20),
            blurRadius: 28,
            spreadRadius: -13),
      ]),
      alignment: Alignment.center,
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: color,
        onPressed: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 15.0,
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  buttonText,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
