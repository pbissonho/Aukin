import 'package:authentication/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:authentication/shared/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koin_flutter/koin_flutter.dart';
import 'bloc/forget_bloc.dart';
import 'code_page.dart';

class ForgetPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<ForgetPage> with ScopeStateMixin {
  ForgetBloc _forgetBloc;

  @override
  void initState() {
    _forgetBloc = currentScope.get<ForgetBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        ForgetForm(
          signUpBloc: _forgetBloc,
        ),
        BlocListener<ForgetBloc, ForgetState>(
            bloc: _forgetBloc,
            listener: (BuildContext context, state) {
              if (state.status == ForgetStateStatus.successForgetCodeSend) {
                Scaffold.of(context)
                  ..showSnackBar(
                    SnackBar(
                      content: Text(
                          "A verification code has been sent to your email."),
                      backgroundColor: Colors.green,
                    ),
                  );
              }

              if (state.status == ForgetStateStatus.verifyCodeInitial) {
                FocusScope.of(context).requestFocus(FocusNode());
                Scaffold.of(context).removeCurrentSnackBar();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return CodePage(forgetBloc: _forgetBloc);
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
                          return Text("state.messages[index]");
                        },
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
              }
            },
            child: StreamBuilder<ForgetState>(
                stream: _forgetBloc,
                builder: (context, snapshot) {
                  var data = snapshot.data;

                  if (!snapshot.hasData) return Loading.initial();
                  if (snapshot.data.status == ForgetStateStatus.initial)
                    return Loading.initial();
                  if (data.status == ForgetStateStatus.failed)
                    return Loading.failed();
                  if (snapshot.data.status == ForgetStateStatus.loading)
                    return Loading.loading();
                  return Loading.initial();
                })),
      ],
    ));
  }
}

class ForgetForm extends StatefulWidget {
  const ForgetForm({Key key, this.signUpBloc}) : super(key: key);

  final ForgetBloc signUpBloc;

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<ForgetForm> {
  TextEditingController _emailController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController();
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
                        TextSpan(text: "Forget password"),
                        style: GoogleFonts.quicksand(
                            fontSize: 40,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff565558)),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      CustomTextField(
                        controller: _emailController,
                        labelTest: "Email",
                        textInputType: TextInputType.emailAddress,
                      ),
                      SizedBox(
                        height: textFieldDistance,
                      ),
                      LogInButton(
                        buttonText: "Send email code.",
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            widget.signUpBloc.add(SendEmailEvent(
                              email: _emailController.value.text,
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
