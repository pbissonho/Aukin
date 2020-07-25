import 'package:authentication/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:authentication/login/login_page.dart';
import 'package:authentication/shared/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bloc/forget_bloc.dart';

class ResetPage extends StatefulWidget {
  const ResetPage({Key key, @required this.forgetBloc}) : super(key: key);

  final ForgetBloc forgetBloc;

  @override
  _ResetPageState createState() => _ResetPageState();
}

class _ResetPageState extends State<ResetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        ResetForm(
          forgetBloc: widget.forgetBloc,
        ),
        BlocListener<ForgetBloc, ForgetState>(
          cubit: widget.forgetBloc,
          listener: (BuildContext context, state) {
            if (state.status == ForgetStateStatus.successAccountReset) {
              Scaffold.of(context)
                ..showSnackBar(
                  SnackBar(
                    content: Text('Account reset successfully.'),
                    backgroundColor: Colors.green,
                  ),
                );
            }

            if (state.status == ForgetStateStatus.resetCompleted) {
              FocusScope.of(context).requestFocus(FocusNode());
              Scaffold.of(context).removeCurrentSnackBar();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) {
                  return Login();
                }),
                (_) => false,
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
          child: StreamBuilder<ForgetState>(
              stream: widget.forgetBloc,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Loading.initial();
                if (snapshot.data.status == ForgetStateStatus.initial) {
                  return Loading.initial();
                }
                if (snapshot.data.status == ForgetStateStatus.failed) {
                  return Loading.failed();
                }
                if (snapshot.data.status == ForgetStateStatus.loading) {
                  return Loading.loading();
                }
                return Loading.initial();
              }),
        )
      ],
    ));
  }
}

class ResetForm extends StatefulWidget {
  const ResetForm({Key key, this.forgetBloc}) : super(key: key);

  final ForgetBloc forgetBloc;

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<ResetForm> {
  TextEditingController _passwordController;
  TextEditingController _passwordConfirmController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _passwordController = TextEditingController();
    _passwordConfirmController = TextEditingController();
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
                        TextSpan(text: 'Reset'),
                        style: GoogleFonts.quicksand(
                            fontSize: 55,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff565558)),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: textFieldDistance,
                      ),
                      SizedBox(
                        height: textFieldDistance,
                      ),
                      CustomTextField(
                        controller: _passwordController,
                        labelTest: 'New Password',
                        textInputType: TextInputType.visiblePassword,
                        obscureText: true,
                      ),
                      SizedBox(
                        height: textFieldDistance,
                      ),
                      CustomTextField(
                        controller: _passwordConfirmController,
                        labelTest: 'Confirm New Password',
                        textInputType: TextInputType.visiblePassword,
                        obscureText: true,
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      LogInButton(
                        buttonText: 'Reset',
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            widget.forgetBloc.add(ResetAccountEvent(
                                confirmpassword: _passwordController.value.text,
                                password: _passwordController.value.text));
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
