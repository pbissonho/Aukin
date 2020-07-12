import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:authentication/home/bloc/user_bloc.dart';
import 'package:koin_flutter/koin_flutter.dart';
import '../authentication/bloc/authentication_bloc.dart';
import 'package:identity_auth/identity_auth.dart';

import 'repository_sample.dart';

class CustomDrawer extends StatelessWidget {
  final UserBloc homeBloc;

  const CustomDrawer({Key key, this.homeBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocBuilder<UserBloc, IdentiyUser>(
        bloc: homeBloc,
        builder: (context, state) {
          var name = state.userName;

          if (name.length >= 1) name = name.substring(0, 1);

          return ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(state.userName),
                accountEmail: Text(state.email),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(name),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with ScopeStateMixin{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(
        homeBloc: currentScope.get(),
      ),
      appBar: AppBar(title: const Text('Home')),
      body: Column(
        children: <Widget>[
          Container(
              child: Center(
                  child: Text(
            "Hello",
            style: TextStyle(fontSize: 32),
          ))),
          FutureBuilder<String>(
            future: currentScope.get<RepositorySample>().get(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) return Text(snapshot.data);

              return CircularProgressIndicator();
            },
          )
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: 1,
            child: const Icon(Icons.exit_to_app),
            onPressed: () {
              get<AuthenticationBloc>().add(LoggedOut());
            },
          ),
        ],
      ),
    );
  }
}
