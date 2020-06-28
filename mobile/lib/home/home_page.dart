import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:authentication/home/bloc/home_bloc.dart';
import 'package:koin_flutter/koin_flutter.dart';
import '../authentication/bloc/authentication_bloc.dart';
import 'package:identity_auth/identity_auth.dart';

class CustomDrawer extends StatelessWidget {
  final HomeBloc homeBloc;

  const CustomDrawer({Key key, this.homeBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocBuilder<HomeBloc, IdentiyUser>(
        bloc: homeBloc,
        builder: (context, state) {
          return ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(state.userName),
                accountEmail: Text(state.email),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(state.userName),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(
        homeBloc: scope.get(),
      ),
      appBar: AppBar(title: const Text('Home')),
      body: Container(
          child: Center(
              child: Text(
        "Hello",
        style: TextStyle(fontSize: 32),
      ))),
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
