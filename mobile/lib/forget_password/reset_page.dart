import 'package:authentication/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:authentication/login/login_page.dart';
import 'package:authentication/shared/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koin_devtools/koin_devtools.dart';
import 'bloc/forget_bloc.dart';

class ResetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: KoinDevTools(),
        body: Stack(
          children: <Widget>[
            ResetForm(),
            BlocListener<ForgetBloc, ForgetState>(
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
              child: BlocBuilder<ForgetBloc, ForgetState>(
                  builder: (context, state) {
                if (state.status == ForgetStateStatus.initial) {
                  return Loading.initial();
                }
                if (state.status == ForgetStateStatus.failed) {
                  return Loading.failed();
                }
                if (state.status == ForgetStateStatus.loading) {
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
  const ResetForm({Key key}) : super(key: key);

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
    final forgetBloc = context.bloc<ForgetBloc>();

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
                            forgetBloc.add(ResetAccountEvent(
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
