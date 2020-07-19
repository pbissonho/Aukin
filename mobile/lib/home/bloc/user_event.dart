part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class UserChanged extends UserEvent {
  UserChanged(this.identiyUser);
  final IdentiyUser identiyUser;
}
