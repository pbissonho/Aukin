import 'package:authentication/forget_password/forget_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:authentication/shared/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koin_devtools/koin_devtools.dart';
import 'package:koin_flutter/koin_flutter.dart';
import 'bloc/login_bloc.dart';
import 'bloc/login_state.dart';

class Login extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute(builder: (_) => Login());
  }

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with ScopeStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loginBloc = currentScope.get<LoginBloc>();

    return Scaffold(
      endDrawer: KoinDevTools(),
      body: BlocListener<LoginBloc, LoginState>(
          cubit: loginBloc,
          listener: (context, state) {
            if (state is LoginFailure) {
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
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
          child: LoginForm(loginBloc: loginBloc)),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key key, this.loginBloc}) : super(key: key);

  final LoginBloc loginBloc;

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController _nameController;
  TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _nameController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Log In',
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
                        labelTest: 'Username',
                        textInputType: TextInputType.text,
                      ),
                      CustomTextField(
                        controller: _passwordController,
                        labelTest: 'Password',
                        textInputType: TextInputType.visiblePassword,
                        obscureText: true,
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      LogInButton(
                        buttonText: 'Log In',
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            FocusScope.of(context).requestFocus(FocusNode());
                            widget.loginBloc.signInWithCredentials(
                                _nameController.value.text,
                                _passwordController.value.text);
                          }
                        },
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      Text.rich(
                        TextSpan(
                          text: 'Forget password? ',
                          style: GoogleFonts.quicksand(
                              textStyle: TextStyle(inherit: false),
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: color), // default text style
                          children: <TextSpan>[
                            TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (c) {
                                        return ForgetPage();
                                      },
                                    ));
                                  },
                                text: 'Reset here.',
                                style: GoogleFonts.quicksand(
                                    decoration: TextDecoration.underline,
                                    textStyle: TextStyle(inherit: false),
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: color)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      )
                    ],
                  ),
                ),
              ),
              ArroBack()
            ],
          )),
    );
  }
}
