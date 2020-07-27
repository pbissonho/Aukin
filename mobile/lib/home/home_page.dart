import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:authentication/home/bloc/user_bloc.dart';
import 'package:koin_devtools/koin_devtools.dart';
import 'package:koin_flutter/koin_flutter.dart';
import '../authentication/bloc/authentication_bloc.dart';
import 'package:identity_auth/identity_auth.dart';

import 'repository_sample.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key key, this.homeBloc}) : super(key: key);

  final UserBloc homeBloc;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocBuilder<UserBloc, IdentiyUser>(
        cubit: homeBloc,
        builder: (context, state) {
          var name = state.userName;

          if (name.isNotEmpty) name = name.substring(0, 1);

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





class Page extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     /// Just insert the KoinDevTools Widget somewhere in your application or use showDevTools;
      endDrawer: KoinDevTools(),
      body: IconButton(icon: Text('DevTools'), onPressed: () {
        // Or use this
        showDevTools(context);
      },),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with ScopeStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: KoinDevTools(),
      drawer: CustomDrawer(
        homeBloc: currentScope.get(),
      ),
      appBar: AppBar(title: const Text('Home')),
      body: Column(
        children: <Widget>[
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
