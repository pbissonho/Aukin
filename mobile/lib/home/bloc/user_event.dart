part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class UserChanged extends UserEvent {
  final IdentiyUser identiyUser;

  UserChanged(this.identiyUser);
}
