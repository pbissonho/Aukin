import 'package:authentication/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:authentication/login/login_page.dart';
import 'package:authentication/shared/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bloc/bloc.dart';
import 'package:koin_flutter/koin_flutter.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with ScopeStateMixin {
  SignUpBloc _signUpBloc;

  @override
  void initState() {
    _signUpBloc = currentScope.get<SignUpBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        SignUpForm(
          signUpBloc: _signUpBloc,
        ),
        BlocListener<SignUpBloc, SignUpState>(
            bloc: _signUpBloc,
            listener: (BuildContext context, state) {
              if (state is SuccessRegistered) {
                Scaffold.of(context)
                  ..showSnackBar(
                    SnackBar(
                      content:
                          Text("Your account has been successfully created."),
                      backgroundColor: Colors.green,
                    ),
                  );
              }

              if (state is SignUpCreatedAccount) {
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
              if (state is SignUpFailed) {
                Scaffold.of(context)
                  ..showSnackBar(
                    SnackBar(
                      duration: Duration(milliseconds: 4000),
                      content: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.messages.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Text(state.messages[index]);
                        },
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
              }
            },
            child: StreamBuilder<SignUpState>(
                stream: _signUpBloc,
                builder: (context, snapshot) {
                  var data = snapshot.data;
                  if (snapshot.data is SignUpStarted) return Loading.initial();
                  if (data is SignUpFailed) return Loading.failed();
                  if (snapshot.data is SignUpLoading) Loading.loading();
                  return Loading.initial();
                })),
      ],
    ));
  }
}

class SignUpForm extends StatefulWidget {
  final SignUpBloc signUpBloc;

  const SignUpForm({Key key, this.signUpBloc}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  TextEditingController _emailController;
  TextEditingController _nameController;
  TextEditingController _passwordController;
  TextEditingController _passwordConfirmController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController();
    _nameController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordConfirmController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double textFieldDistance = 19;
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
                        TextSpan(text: "Sign \n     Up"),
                        style: GoogleFonts.quicksand(
                            fontSize: 55,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff565558)),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      CustomTextField(
                          controller: _nameController,
                          labelTest: "Name",
                          textInputType: TextInputType.text),
                      SizedBox(
                        height: textFieldDistance,
                      ),
                      CustomTextField(
                        controller: _emailController,
                        labelTest: "Email",
                        textInputType: TextInputType.emailAddress,
                      ),
                      SizedBox(
                        height: textFieldDistance,
                      ),
                      CustomTextField(
                        controller: _passwordController,
                        labelTest: "Password",
                        textInputType: TextInputType.visiblePassword,
                        obscureText: true,
                      ),
                      SizedBox(
                        height: textFieldDistance,
                      ),
                      CustomTextField(
                        controller: _passwordConfirmController,
                        labelTest: "Confirm Password",
                        textInputType: TextInputType.visiblePassword,
                        obscureText: true,
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      LogInButton(
                        buttonText: "Sign In",
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            widget.signUpBloc.add(
                                CreateUserWithRegisterCredentials(
                                    confirmPassword: 'Aa12345678!',
                                    email: _emailController.value.text,
                                    name: _nameController.value.text,
                                    password: 'Aa12345678!'));
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
