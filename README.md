# Sign up/Log in

A simple application to demonstrate the Sign up and Log in flow using Flutter and ASP.Net Core.

## Design

![alt-text](https://github.com/pbissonho/Authentication-Flow-Flutter/blob/master/design.png)

Design created by [Andrea](https://dribbble.com/shots/5601302-Mobile-Sign-Up-UI) 

## Demo

![alt-text](https://github.com/pbissonho/Authentication-Flow-Flutter/blob/master/authapp.gif)


## Current features

- Log in
- Sign up
- Loggout
- Password reset


## Mobile

### Core packages used:

- Koin - Dependency injection/Service Locator
- Bloc/flutter_bloc - State management
- Fresh(FORK) - Helps implement token refresh. I currently use a [fork](https://github.com/pbissonho/fresh) with some changes.
- Flutter Secure Storage - Store token data in secure storage
- Equatable - Helps to implement equality
- Dio - Http client 
- Corsac_jwt - Help read the JTW token data.

### Start

git clone https://github.com/pbissonho/Flutter-Authentication.git

cd mobile

flutter run


### Test without the backend 

Just change the line 'app.modules (prod)' to 'app.modules (dev)' in the file 'app.dart'.
Then the application will use the services/repositories fakes.

```dart
@override
  void initState() {
    super.initState();

    startKoin((app) {
      app.printLogger(level: Level.debug);

      // Development
      app.modules(dev);

      //Production
      //app.module(prod)
    });
  }
```

  


## Backend

### Core packages used:

- Database - InMemory 
- Cache - InMemory (I will add token cache and refresh-token with Redis)
- Identity - Manages users, passwords, profile data,tokens.
- NetDevPack.Identity - A set of implementations to assist help use of Identity
- Sendgrid - Email service




