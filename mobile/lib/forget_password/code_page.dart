import 'dart:async';

import 'package:authentication/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:authentication/shared/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'bloc/forget_bloc.dart';
import 'reset_page.dart';

class CodePage extends StatefulWidget {
  const CodePage({Key key, @required this.forgetBloc}) : super(key: key);

  final ForgetBloc forgetBloc;

  @override
  _CodePageState createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        CodeForm(
          forgetBloc: widget.forgetBloc,
        ),
        BlocListener<ForgetBloc, ForgetState>(
          cubit: widget.forgetBloc,
          child: StreamBuilder<ForgetState>(
              stream: widget.forgetBloc,
              builder: (context, snapshot) {
                var data = snapshot.data;
                if (!snapshot.hasData) return Loading.initial();
                if (snapshot.data.status == ForgetStateStatus.initial) {
                  return Loading.initial();
                }
                if (data.status == ForgetStateStatus.failed) {
                  return Loading.failed();
                }
                if (snapshot.data.status == ForgetStateStatus.loading) {
                  return Loading.loading();
                }
                return Loading.initial();
              }),
          listener: (BuildContext context, state) {
            if (state.status == ForgetStateStatus.successVerifyCode) {
              Scaffold.of(context)
                ..showSnackBar(
                  SnackBar(
                    content: Text('Code successfully verified.'),
                    backgroundColor: Colors.green,
                  ),
                );
            }

            if (state.status == ForgetStateStatus.resetAccountInitial) {
              FocusScope.of(context).requestFocus(FocusNode());
              Scaffold.of(context).removeCurrentSnackBar();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return ResetPage(forgetBloc: widget.forgetBloc);
                }),
              );
            }

            if (state.status == ForgetStateStatus.failed) {
              Scaffold.of(context)
                ..showSnackBar(
                  SnackBar(
                    duration: Duration(milliseconds: 4000),
                    content: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 1,
                      itemBuilder: (BuildContext context, int index) {
                        return Text('state.messages[index]');
                      },
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
            }
          },
        ),
      ],
    ));
  }
}

class CodeForm extends StatefulWidget {
  const CodeForm({Key key, this.forgetBloc}) : super(key: key);

  final ForgetBloc forgetBloc;

  @override
  _CodeFormFormState createState() => _CodeFormFormState();
}

class _CodeFormFormState extends State<CodeForm> {
  TextEditingController _codeController;
  StreamController<ErrorAnimationType> errorController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _codeController = TextEditingController();
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var textFieldDistance = 19.0;
    return Form(
      key: _formKey,
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.bottomCenter,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text.rich(
                        TextSpan(text: 'Code Verification'),
                        style: GoogleFonts.quicksand(
                            fontSize: 40,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff565558)),
                      ),
                      Text.rich(
                        TextSpan(text: 'Enter the code sento to your email.'),
                        style: GoogleFonts.quicksand(
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff565558)),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: textFieldDistance,
                      ),
                      PinCodeTextField(
                          textStyle: GoogleFonts.quicksand(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          length: 8,
                          obsecureText: false,
                          animationType: AnimationType.fade,
                          pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(5),
                              fieldHeight: 50,
                              fieldWidth: 40,
                              activeFillColor: Colors.white,
                              disabledColor: Colors.grey,
                              inactiveColor: color,
                              inactiveFillColor: Colors.white,
                              selectedFillColor: color,
                              selectedColor: color,
                              activeColor: color),
                          backgroundColor: Colors.white,
                          animationDuration: Duration(milliseconds: 300),
                          //backgroundColor: Colors.blue.shade50,
                          enableActiveFill: true,
                          errorAnimationController: errorController,
                          controller: _codeController,
                          onCompleted: (v) {
                            print('Completed');
                          },
                          onChanged: (value) {
                            print(value);
                            setState(() {
                              // currentText = value;
                            });
                          },
                          beforeTextPaste: (text) {
                            print('Allowing to paste $text');
                            //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                            //but you can show anything you want here, like your pop up saying wrong paste format or etc
                            return true;
                          }),
                      SizedBox(
                        height: textFieldDistance,
                      ),
                      LogInButton(
                        buttonText: 'Code',
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            widget.forgetBloc.add(VerifiyCodeEvent(
                              code: _codeController.value.text,
                            ));
                          }
                        },
                      ),
                      SizedBox(
                        height: 40,
                      )
                    ],
                  ),
                ),
              ),
              ArroBack(),
            ],
          )),
    );
  }
}
