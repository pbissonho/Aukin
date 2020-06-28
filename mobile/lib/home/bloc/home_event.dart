part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class UserChanged extends HomeEvent {
  final IdentiyUser identiyUser;

  UserChanged(this.identiyUser);
}
