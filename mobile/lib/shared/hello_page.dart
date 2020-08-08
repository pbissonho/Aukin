import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:authentication/login/login_page.dart';
import 'package:authentication/signup/sign_up_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:authentication/theme.dart';

class BackgroundColor extends StatelessWidget {
  const BackgroundColor({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xff7A87C9), Color(0xff5462B7)],
                  stops: [0.6, 1],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ClipPath(
            clipper: WaveClipperTwo(),
            child: Container(
              height: height / 1.7,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xff94A3DF), Color(0xff7380CB)],
                    stops: [0.4, 1],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: child,
        )
      ],
    );
  }
}

class HelloPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BackgroundColor(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Hello. ',
                  style: GoogleFonts.questrial(
                      fontSize: 60,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
                Text(
                  'Lets Get Started!. \n',
                  style: GoogleFonts.questrial(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 60,
                ),
                CustomButton(
                  textColor: primaryColor,
                  buttonText: 'Sign Up',
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (c) {
                        return SignUpPage();
                      },
                    ));
                  },
                ),
                SizedBox(
                  height: 18,
                ),
                CustomButton(
                  textColor: Colors.grey,
                  buttonText: 'Sign Up with Google',
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (c) {
                        return Container();
                      },
                    ));
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                Text.rich(
                  TextSpan(
                    text: 'Already have account? ',
                    style: GoogleFonts.quicksand(
                        textStyle: TextStyle(inherit: false),
                        fontSize: 19,
                        fontWeight: FontWeight.normal,
                        color: Colors.white), // default text style
                    children: <TextSpan>[
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (c) {
                                  return Login();
                                },
                              ));
                            },
                          text: 'Sign in here.',
                          style: GoogleFonts.quicksand(
                              decoration: TextDecoration.underline,
                              textStyle: TextStyle(inherit: false),
                              fontSize: 19,
                              fontWeight: FontWeight.normal,
                              color: Colors.white)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            )),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({Key key, this.buttonText, this.onPressed, this.textColor})
      : super(key: key);

  final String buttonText;
  final void Function() onPressed;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: primaryColor,
            offset: Offset(0, 0),
            blurRadius: 17,
            spreadRadius: 0),
      ]),
      alignment: Alignment.center,
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
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
                      color: textColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
